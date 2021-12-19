package controllers {
	
	import components.KeyboardInput;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import core.TPStage;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import models.SceneModel;
	import states.AnimationInfoStates;
	import states.AnimationSceneStates;
	import states.EditorStates;
	import states.HierarchyStates;
	import states.ScriptRecordingStates;
	import ui.DialogueBox;
	import ui.DialogueBoxes;
	import ui.HierarchyPanel;
	import ui.ScenesPanel;
	import ui.Shortcuts;
	import utils.ArrayUtil;
	import utils.HierarchyUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationScenesControllerEditor extends AnimationScenesController {
		
		private var hierarchyPanel : HierarchyPanel;
		private var scenesPanel : ScenesPanel;
		
		private var activeChildPath : Vector.<String>;
		private var activeChildParentsChainLength : Number = -1;
		
		public function AnimationScenesControllerEditor(_animationSceneStates : AnimationSceneStates, _hierarchyPanel : HierarchyPanel, _scenesPanel : ScenesPanel) {
			super(_animationSceneStates);
			
			hierarchyPanel = _hierarchyPanel;
			scenesPanel = _scenesPanel;
			
			hierarchyPanel.selectEvent.listen(this, onHierarchyPanelChildSelected);
			scenesPanel.sceneSelectedEvent.listen(this, onScenesPanelSceneSelected);
			scenesPanel.mergeScenesEvent.listen(this, onScenesPanelMergeScenes);
			scenesPanel.deleteScenesEvent.listen(this, onScenesPanelDeleteScenes);
			
			HierarchyStates.listen(this, onHierarchyPanelLockedChildrenStateChange, [HierarchyStates.lockedChildren]);
			ScriptRecordingStates.listen(this, onIsDoneRecordingScriptStateChange, [ScriptRecordingStates.isDoneRecording]);
			
			AnimationSceneStates.activeChild.listen(this, onActiveChildStateChange);
			
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.togglePlaying1, this, onTogglePlayingShortcut, []);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.togglePlaying2, this, onTogglePlayingShortcut, []);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.stepFrameBackwards1, this, onStepFramesShortcut, [-1]);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.stepFrameBackwards2, this, onStepFramesShortcut, [-1]);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.stepFrameForwards1, this, onStepFramesShortcut, [1]);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.stepFrameForwards2, this, onStepFramesShortcut, [1]);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.rewind1, this, onRewindShortcut, []);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.rewind2, this, onRewindShortcut, []);

			// TODO: Remove this after the next release
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.clearStopFrame, this, onClearStopFrameShortcut, []);
		}
		
		public override function update() : void {
			if (EditorStates.isEditor.value == false) {
				super.update();
				return;
			}
			
			// TODO: Add some kind of indicator on in the scenes panel for the scene that will be active in play mode
			/* super.update();
			scenesPanel.update();
			return; */
			
			var activeChild : TPMovieClip = AnimationSceneStates.activeChild.value;
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			
			var didActiveChildChange : Boolean = false;
			
			if (activeChild != null && isActiveChildInDisplayList() == false) {
				activeChild = findActiveChildReplacement();
				animationSceneStates._activeChild.setValue(activeChild);
				didActiveChildChange = true;
			}
			
			if (activeChild == null && currentScene != null) {
				animationSceneStates._recoveryChildPath.setValue(ArrayUtil.vectorToArray(currentScene.getPath()));
			}
			
			if (didActiveChildChange == true && currentScene != null) {
				exitCurrentScene();
				currentScene = null;
			}
			
			// TODO: Add advanced scene options for auto selecting children
			
			// While no child have been selected find one that is potentially part of an existing scene
			/* if (activeChild == null) {
				var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
				var scenes : Array = AnimationSceneStates.scenes.value;
				for (var i : Number = 0; i < scenes.length; i++) {
					var scene : SceneModel = scenes[i];
					var childFromPath : TPMovieClip = HierarchyUtil.getMovieClipFromPath(root, scene.getPath());
					if (childFromPath != null) {
						activeChild = childFromPath;
						animationSceneStates._activeChild.setValue(activeChild);
					}
				}
			} */
			
			// Similar to above, but only try to find a child based on the previously selected one
			if (activeChild == null && AnimationSceneStates.recoveryChildPath.value != null) {
				var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
				var recoveryChildPath : Vector.<String> = ArrayUtil.addValuesFromArrayToVector(new Vector.<String>(), AnimationSceneStates.recoveryChildPath.value);
				activeChild = HierarchyUtil.getMovieClipFromPath(root, recoveryChildPath);
				animationSceneStates._activeChild.setValue(activeChild);
			}
			
			if (activeChild == null) {
				scenesPanel.update();
				return;
			}
			
			var sceneAtFrame : SceneModel = getSceneAtFrameForChild(activeChild);
			
			var hasBothScenes : Boolean = currentScene != null && sceneAtFrame != null;
			var isSameScene : Boolean = hasBothScenes == true && currentScene == sceneAtFrame;
			var isCurrentSceneUnavailable : Boolean = currentScene != null && currentScene.isAvailable() == false;
			var bothScenesHasSamePath : Boolean = hasBothScenes == true && currentScene.getPath().join(",") == sceneAtFrame.getPath().join(",");
			var currentEndsBeforeSceneAtFrame : Boolean = hasBothScenes == true && currentScene.getInnerEndFrame() + 1 == sceneAtFrame.getInnerStartFrame();
			var currentHasDifferentFrameRate : Boolean = currentScene != null && currentScene.getFrameRate() != TPStage.frameRate;
			
			var shouldEnterNewScene : Boolean = currentScene == null && sceneAtFrame == null;
			var shouldMergeWithSceneAtFrame : Boolean = isSameScene == false && bothScenesHasSamePath == true && currentEndsBeforeSceneAtFrame == true && sceneAtFrame.isTemporary == true;
			var shouldEnterSceneAtFrame : Boolean = sceneAtFrame != null && isSameScene == false && shouldMergeWithSceneAtFrame == false;
			var shouldExitCurrentScene : Boolean = currentScene != null && (shouldEnterSceneAtFrame == true || isCurrentSceneUnavailable == true || currentHasDifferentFrameRate == true);
			
			if (shouldExitCurrentScene == true) {
				exitCurrentScene();
				currentScene = null;
			}
			
			if (isCurrentSceneUnavailable == true) {
				animationSceneStates._activeChild.setValue(null);
				activeChild = null;
			}
			
			if (shouldEnterNewScene == true) {
				currentScene = new SceneModel(activeChildPath);
				currentScene.enter();
				currentScene.isTemporary = true;
				addScene(currentScene);
			}
			
			if (shouldEnterSceneAtFrame == true) {
				currentScene = sceneAtFrame;
				currentScene.enter();
			}
			
			if (shouldMergeWithSceneAtFrame == true) {
				currentScene.merge(sceneAtFrame);
				removeScene(sceneAtFrame);
			}
			
			setCurrentScene(currentScene);
			
			if (currentScene == null) {
				scenesPanel.update();
				return;
			}
			
			var updateStatus : String = currentScene.update();
			
			animationSceneStates._isForceStopped.setValue(currentScene.isForceStopped());
			
			if (updateStatus == SceneModel.UPDATE_STATUS_EXIT) {
				exitCurrentScene();
				update();
				return;
			}
			
			var shouldSplit : Boolean = updateStatus == SceneModel.UPDATE_STATUS_COMPLETELY_STOPPED && activeChild.currentFrame > currentScene.getInnerStartFrame();
			shouldSplit = shouldSplit || updateStatus == SceneModel.UPDATE_STATUS_LOOP_MIDDLE;
			shouldSplit = shouldSplit && ScriptRecordingStates.isRecording.value == false
			
			if (shouldSplit == true) {
				var firstHalf : SceneModel = currentScene.split();
				currentScene.isTemporary = false;
				addScene(firstHalf);
			}
			
			if (updateStatus == SceneModel.UPDATE_STATUS_LOOP_START) {
				var loopCount : Number = AnimationSceneStates.currentSceneLoopCount.value;
				animationSceneStates._currentSceneLoopCount.setValue(loopCount + 1);
			}
			
			scenesPanel.update();
		}
		
		private function onTogglePlayingShortcut() : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			if (currentScene == null) {
				return;
			}
			
			if (currentScene.isForceStopped() == true) {
				currentScene.play();
			} else {
				currentScene.stop();
			}
			
			animationSceneStates._isForceStopped.setValue(currentScene.isForceStopped());
		}
		
		private function onStepFramesShortcut(_frames : Number) : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			if (currentScene != null) {
				currentScene.stepFrames(_frames);
				animationSceneStates._isForceStopped.setValue(currentScene.isForceStopped());
			}
		}
		
		private function onRewindShortcut() : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			if (currentScene != null) {
				currentScene.gotoAndStop(currentScene.getStartFrames());
				animationSceneStates._isForceStopped.setValue(currentScene.isForceStopped());
			}
		}
		
		// TODO: Remove this after the next release
		private function onClearStopFrameShortcut() : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			if (currentScene != null) {
				currentScene.clearStopFrame();
			}
		}
		
		private function onIsDoneRecordingScriptStateChange() : void {
			if (ScriptRecordingStates.isDoneRecording.value == false) {
				return;
			}
			
			var recordingScene : SceneModel = ScriptRecordingStates.recordingScene.value;
			var recordingStartFrames : Vector.<Number> = new Vector.<Number>();
			ArrayUtil.addValuesFromArrayToVector(recordingStartFrames, ScriptRecordingStates.recordingStartFrames.value);
			
			switchToScene(recordingScene);
			
			recordingScene.gotoAndStop(recordingStartFrames);
		}
		
		private function onHierarchyPanelChildSelected(_child : TPDisplayObject) : void {
			if (KeyboardInput.areKeysPressed(Shortcuts.singleSelect) == true || KeyboardInput.areKeysPressed(Shortcuts.multiSelect) == true) {
				return;
			}
			
			if (TPMovieClip.isMovieClip(_child.sourceDisplayObject) == false) {
				return;
			}
			
			var lockedChildren : Array = HierarchyStates.lockedChildren.value;
			if (ArrayUtil.includes(lockedChildren, _child.sourceDisplayObject) == true) {
				return;
			}
			
			var activeChild : TPMovieClip = AnimationSceneStates.activeChild.value;
			if (activeChild != null && _child.sourceDisplayObject == activeChild.sourceDisplayObject) {
				return;
			}
			
			var movieClip : MovieClip = TPMovieClip.asMovieClip(_child.sourceDisplayObject);
			activeChild = new TPMovieClip(movieClip);
			
			animationSceneStates._activeChild.setValue(activeChild);
			
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			var sceneAtFrame : SceneModel = getSceneAtFrameForChild(activeChild);
			
			if (currentScene != null) {
				if (currentScene.isTemporary == true && currentScene.getTotalInnerFrames() == 1) {
					removeScene(currentScene);
				}
				exitCurrentScene();
			}
			
			if (sceneAtFrame == null) {
				currentScene = new SceneModel(activeChildPath);
				currentScene.isTemporary = true;
				currentScene.enter();
				
				addScene(currentScene);
				setCurrentScene(currentScene);
			}
		}
		
		private function onScenesPanelSceneSelected(_scene : SceneModel) : void {
			if (KeyboardInput.areKeysPressed(Shortcuts.singleSelect) == true) {
				animationSceneStates._selectedScenes.setValue([_scene]);
				return;
			}
			
			if (KeyboardInput.areKeysPressed(Shortcuts.multiSelect) == true) {
				var scenes : Array = AnimationSceneStates.selectedScenes.value;
				if (ArrayUtil.includes(scenes, _scene) == true) {
					ArrayUtil.remove(scenes, _scene);
				} else {
					scenes.push(_scene);
				}
				
				animationSceneStates._selectedScenes.setValue(scenes);
				return;
			}
			
			animationSceneStates._selectedScenes.setValue([_scene]);
			
			switchToScene(_scene);
		}
		
		private function onScenesPanelMergeScenes() : void {
			DialogueBoxes.openMergeScenesDialogueBox(this, onConfirmMergeScenes);
		}
		
		private function onScenesPanelDeleteScenes() : void {
			DialogueBoxes.openDeleteScenesDialogueBox(this, onConfirmDeleteScenes);
		}
		
		private function onConfirmMergeScenes() : void {
			var selectedScenes : Array = AnimationSceneStates.selectedScenes.value;
			var scene1 : SceneModel = selectedScenes[0];
			var scene2 : SceneModel = selectedScenes[1];
			
			scene1.merge(scene2);
			removeScene(scene2);
		}
		
		private function onConfirmDeleteScenes() : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			var scenes : Array = AnimationSceneStates.scenes.value;
			var selectedScenes : Array = AnimationSceneStates.selectedScenes.value;
			
			for (var i : Number = 0; i < selectedScenes.length; i++) {
				ArrayUtil.remove(scenes, selectedScenes[i]);
			}
			
			if (ArrayUtil.includes(selectedScenes, currentScene) == true) {
				exitCurrentScene();
				animationSceneStates._activeChild.setValue(null);
			}
			
			animationSceneStates._scenes.setValue(scenes);
			animationSceneStates._selectedScenes.setValue([]);
			animationSceneStates._recoveryChildPath.setValue(null);
		}
		
		private function onActiveChildStateChange() : void {
			var child : TPMovieClip = AnimationSceneStates.activeChild.value;
			if (child == null) {
				activeChildPath = null;
				activeChildParentsChainLength = -1;
				return;
			}
			
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var path : Vector.<String> = HierarchyUtil.getChildPath(root, child);
			var parents : Vector.<DisplayObjectContainer> = TPDisplayObject.getParents(child.sourceDisplayObject);
			
			activeChildPath = path;
			activeChildParentsChainLength = parents.length;
		}
		
		private function onHierarchyPanelLockedChildrenStateChange() : void {
			var activeChild : TPDisplayObject = AnimationSceneStates.activeChild.value;
			var lockedChildren : Array = HierarchyStates.lockedChildren.value;
			
			if (activeChild != null && ArrayUtil.includes(lockedChildren, activeChild.sourceDisplayObject) == true) {
				animationSceneStates._activeChild.setValue(null);
				activeChildPath = null;
				activeChildParentsChainLength = -1;
			}
		}
		
		private function switchToScene(_scene : SceneModel) : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			if (_scene == currentScene) {
				return;
			}
			
			if (currentScene != null) {
				exitCurrentScene();
			}
			
			if (AnimationSceneStates.isForceStopped.value == true) {
				_scene.gotoAndStop(_scene.getStartFrames());
			} else {
				_scene.gotoAndPlay(_scene.getStartFrames());
			}
			
			_scene.enter();
			
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var childAtPath : TPMovieClip = HierarchyUtil.getMovieClipFromPath(root, _scene.getPath());
			
			animationSceneStates._activeChild.setValue(childAtPath);
			setCurrentScene(_scene);
		}
		
		private function isActiveChildInDisplayList() : Boolean {
			var activeChild : TPMovieClip = AnimationSceneStates.activeChild.value;
			if (activeChild == null) {
				return false;
			}
			
			var parents : Vector.<DisplayObjectContainer> = TPDisplayObject.getParents(activeChild.sourceDisplayObjectContainer);
			return parents.length == activeChildParentsChainLength;
		}
		
		private function isChildVisible(_child : TPDisplayObject) : Boolean {
			if (_child.visible == false) {
				return false;
			}
			
			var parents : Vector.<DisplayObjectContainer> = TPDisplayObject.getParents(_child.sourceDisplayObject);
			for (var i : Number = 0; i < parents.length; i++) {
				if (parents[i].visible == false) {
					return false;
				}
			}
			
			return true;
		}
		
		private function findActiveChildReplacement() : TPMovieClip {
			var activeChild : TPMovieClip = AnimationSceneStates.activeChild.value;
			
			if (activeChildPath != null) {
				var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
				var childFromPath : TPMovieClip = HierarchyUtil.getMovieClipFromPath(root, activeChildPath);
				return childFromPath;
			}
			
			return null;
		}
		
		private function setCurrentScene(_scene : SceneModel) : void {
			animationSceneStates._currentScene.setValue(_scene);
			animationSceneStates._currentSceneLoopCount.setValue(0);
		}
		
		private function exitCurrentScene() : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			currentScene.exit();
			animationSceneStates._currentScene.setValue(null);
			animationSceneStates._currentSceneLoopCount.setValue(-1);
		}
		
		private function addScene(_scene : SceneModel) : void {
			var scenes : Array = AnimationSceneStates.scenes.value;
			
			scenes.push(_scene);
			
			scenes.sort(function(_a : SceneModel, _b : SceneModel) : Number {
				var aStartFrames : Vector.<Number> = _a.getStartFrames();
				var bStartFrames : Vector.<Number> = _b.getStartFrames();
				
				var maxLength : Number = Math.max(aStartFrames.length, bStartFrames.length);
				
				for (var i : Number = 0; i < maxLength; i++) {
					var aFrame : Number = aStartFrames.length > i ? aStartFrames[i] : -1;
					var bFrame : Number = bStartFrames.length > i ? bStartFrames[i] : -1;
					if (aFrame > bFrame) {
						return 1;
					}
					if (bFrame > aFrame) {
						return -1;
					}
				}
				
				return 0;
			});
			
			animationSceneStates._scenes.setValue(scenes);
		}
		
		private function removeScene(_scene : SceneModel) : void {
			var scenes : Array = AnimationSceneStates.scenes.value;
			var selectedScenes : Array = AnimationSceneStates.selectedScenes.value;
			
			ArrayUtil.remove(scenes, _scene);
			ArrayUtil.remove(selectedScenes, _scene);
			
			animationSceneStates._scenes.setValue(scenes);
			animationSceneStates._selectedScenes.setValue(selectedScenes);
		}
		
		private function getSceneAtFrameForChild(_child : TPMovieClip) : SceneModel {
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var path : Vector.<String> = HierarchyUtil.getChildPath(root, _child);
			var pathString : String = path.join(",");
			var scenes : Array = AnimationSceneStates.scenes.value;
			
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : SceneModel = scenes[i];
				if (scene.getPath().join(",") == pathString && scene.isActive() == true) {
					return scene;
				}
			}
			
			return null;
		}
	}
}