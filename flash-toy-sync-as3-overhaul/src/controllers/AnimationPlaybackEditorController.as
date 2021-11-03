package controllers {
	import components.KeyboardInput;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import models.SceneModel;
	import states.AnimationInfoStates;
	import states.AnimationPlaybackStates;
	import ui.HierarchyPanel;
	import ui.ScenesPanel;
	import utils.ArrayUtil;
	import utils.HierarchyUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationPlaybackEditorController extends AnimationPlaybackController {
		
		private var hierarchyPanel : HierarchyPanel;
		private var scenesPanel : ScenesPanel;
		
		private var activeChildPath : Vector.<String>;
		private var activeChildParentsChainLength : Number = -1;
		
		public function AnimationPlaybackEditorController(_animationPlaybackStates : AnimationPlaybackStates, _hierarchyPanel : HierarchyPanel, _scenesPanel : ScenesPanel) {
			super(_animationPlaybackStates);
			
			hierarchyPanel = _hierarchyPanel;
			scenesPanel = _scenesPanel;
			
			hierarchyPanel.selectEvent.listen(this, onHierarchyPanelChildSelected);
			scenesPanel.sceneSelectedEvent.listen(this, onScenesPanelSceneSelected);
			
			KeyboardInput.addShortcut([Keyboard.ENTER], this, onTogglePlayingShortcut, []);
			KeyboardInput.addShortcut([Keyboard.SPACE], this, onTogglePlayingShortcut, []);
			KeyboardInput.addShortcut([Keyboard.LEFT], this, onStepFramesShortcut, [-1]);
			KeyboardInput.addShortcut([Keyboard.A], this, onStepFramesShortcut, [-1]);
			KeyboardInput.addShortcut([Keyboard.RIGHT], this, onStepFramesShortcut, [1]);
			KeyboardInput.addShortcut([Keyboard.D], this, onStepFramesShortcut, [1]);
			KeyboardInput.addShortcut([Keyboard.SHIFT, Keyboard.LEFT], this, onRewindShortcut, []);
			KeyboardInput.addShortcut([Keyboard.SHIFT, Keyboard.A], this, onRewindShortcut, []);
		}
		
		public override function update() : void {
			var activeChild : TPMovieClip = AnimationPlaybackStates.activeChild.value;
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			
			var didActiveChildChange : Boolean = false;
			
			if (isActiveChildInDisplayList() == false) {
				activeChild = findActiveChildReplacement();
				setActiveChild(activeChild);
				didActiveChildChange = true;
			}
			
			if (didActiveChildChange && currentScene != null) {
				exitCurrentScene();
				currentScene = null;
			}
			
			if (activeChild == null) {
				scenesPanel.update();
				return;
			}
			
			var sceneAtFrame : SceneModel = getSceneAtFrameForChild(activeChild);
			
			var hasBothScenes : Boolean = currentScene != null && sceneAtFrame != null;
			var isSameScene : Boolean = hasBothScenes == true && currentScene == sceneAtFrame;
			var bothScenesHasSamePath : Boolean = hasBothScenes == true && currentScene.getPath().join(",") == sceneAtFrame.getPath().join(",");
			var currentEndsBeforeSceneAtFrame : Boolean = hasBothScenes == true && currentScene.getInnerEndFrame() + 1 == sceneAtFrame.getInnerStartFrame();
			
			var shouldEnterNewScene : Boolean = currentScene == null && sceneAtFrame == null;
			var shouldMergeWithSceneAtFrame : Boolean = isSameScene == false && bothScenesHasSamePath == true && currentEndsBeforeSceneAtFrame == true && sceneAtFrame.isTemporary == true;
			var shouldEnterSceneAtFrame : Boolean = sceneAtFrame != null && isSameScene == false && shouldMergeWithSceneAtFrame == false;
			var shouldExitCurrentScene : Boolean = currentScene != null && shouldEnterSceneAtFrame == true;
			
			if (shouldExitCurrentScene == true) {
				exitCurrentScene();
				currentScene = null;
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
			
			animationPlaybackStates._currentScene.setValue(currentScene);
			
			if (currentScene == null) {
				scenesPanel.update();
				return;
			}
			
			var updateStatus : String = currentScene.update();
			
			animationPlaybackStates._isForceStopped.setValue(currentScene.isForceStopped());
			
			if (updateStatus == SceneModel.UPDATE_STATUS_EXIT) {
				exitCurrentScene();
				update();
				return;
			}
			
			var firstHalf : SceneModel;
			
			if (updateStatus == SceneModel.UPDATE_STATUS_COMPLETELY_STOPPED) {
				if (currentScene.getTotalInnerFrames() > 1) {
					firstHalf = currentScene.split();
					currentScene.isTemporary = false;
					addScene(firstHalf);
				}
			}
			
			if (updateStatus == SceneModel.UPDATE_STATUS_LOOP_MIDDLE) {
				firstHalf = currentScene.split();
				currentScene.isTemporary = false;
				addScene(firstHalf);
			}
			
			scenesPanel.update();
		}
		
		private function onTogglePlayingShortcut() : void {
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			if (currentScene == null) {
				return;
			}
			
			if (currentScene.isForceStopped() == true) {
				currentScene.play();
			} else {
				currentScene.stop();
			}
			
			animationPlaybackStates._isForceStopped.setValue(currentScene.isForceStopped());
		}
		
		private function onStepFramesShortcut(_frames : Number) : void {
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			if (currentScene != null) {
				currentScene.stepFrames(_frames);
				animationPlaybackStates._isForceStopped.setValue(currentScene.isForceStopped());
			}
		}
		
		private function onRewindShortcut() : void {
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			if (currentScene != null) {
				currentScene.gotoAndStop(currentScene.getStartFrames());
				animationPlaybackStates._isForceStopped.setValue(currentScene.isForceStopped());
			}
		}
		
		private function onHierarchyPanelChildSelected(_child : TPDisplayObject) : void {
			if (TPMovieClip.isMovieClip(_child.sourceDisplayObject) == false) {
				return;
			}
			
			var activeChild : TPMovieClip = AnimationPlaybackStates.activeChild.value;
			if (activeChild != null && _child.sourceDisplayObject == activeChild.sourceDisplayObject) {
				return;
			}
			
			var movieClip : MovieClip = TPMovieClip.asMovieClip(_child.sourceDisplayObject);
			activeChild = new TPMovieClip(movieClip);
			
			setActiveChild(activeChild);
			
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
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
				
				animationPlaybackStates._currentScene.setValue(currentScene);
			}
		}
		
		private function onScenesPanelSceneSelected(_scene : SceneModel) : void {
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			if (_scene == currentScene) {
				return;
			}
			
			if (currentScene != null) {
				exitCurrentScene();
			}
			
			if (AnimationPlaybackStates.isForceStopped.value == true) {
				_scene.gotoAndStop(_scene.getStartFrames());
			} else {
				_scene.gotoAndPlay(_scene.getStartFrames());
			}
			
			_scene.enter();
			
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var childAtPath : TPMovieClip = HierarchyUtil.getMovieClipFromPath(root, _scene.getPath());
			
			setActiveChild(childAtPath);
			
			animationPlaybackStates._currentScene.setValue(_scene);
		}
		
		private function setActiveChild(_child : TPMovieClip) : void {
			animationPlaybackStates._activeChild.setValue(_child);
			
			if (_child == null) {
				return;
			}
			
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var path : Vector.<String> = HierarchyUtil.getChildPath(root, _child);
			var parents : Vector.<DisplayObjectContainer> = TPDisplayObject.getParents(_child.sourceDisplayObject);
			
			activeChildPath = path;
			activeChildParentsChainLength = parents.length;
		}
		
		private function isActiveChildInDisplayList() : Boolean {
			var activeChild : TPMovieClip = AnimationPlaybackStates.activeChild.value;
			if (activeChild == null) {
				return false;
			}
			
			if (activeChild != null) {
				var parents : Vector.<DisplayObjectContainer> = TPDisplayObject.getParents(activeChild.sourceMovieClip);
				if (parents.length != activeChildParentsChainLength) {
					return false;
				}
			}
			
			return true;
		}
		
		private function findActiveChildReplacement() : TPMovieClip {
			var activeChild : TPMovieClip = AnimationPlaybackStates.activeChild.value;
			
			if (activeChildPath != null) {
				var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
				var childFromPath : TPMovieClip = HierarchyUtil.getMovieClipFromPath(root, activeChildPath);
				return childFromPath;
			}
			
			return null;
		}
		
		private function exitCurrentScene() : void {
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			currentScene.exit();
			animationPlaybackStates._currentScene.setValue(null);
		}
		
		private function addScene(_scene : SceneModel) : void {
			var scenes : Array = AnimationPlaybackStates.scenes.value;
			
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
			
			animationPlaybackStates._scenes.setValue(scenes);
		}
		
		private function removeScene(_scene : SceneModel) : void {
			var scenes : Array = AnimationPlaybackStates.scenes.value;
			ArrayUtil.remove(scenes, _scene);
			animationPlaybackStates._scenes.setValue(scenes);
		}
		
		private function getSceneAtFrameForChild(_child : TPMovieClip) : SceneModel {
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var path : Vector.<String> = HierarchyUtil.getChildPath(root, _child);
			var pathString : String = path.join(",");
			var scenes : Array = AnimationPlaybackStates.scenes.value;
			
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