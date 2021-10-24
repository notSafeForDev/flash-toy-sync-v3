package controllers {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	
	import core.ArrayUtil;
	import core.DisplayObjectUtil;
	import core.KeyboardManager;
	import core.MathUtil;
	import core.MovieClipUtil;
	
	import global.EditorState;
	import global.ScenesState;
	import global.GlobalEvents;
	
	import components.Scene;
	
	import ui.ScenesPanel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenesEditorController extends ScenesController {
		
		public function ScenesEditorController(_scenesState : ScenesState, _scenesPanel : ScenesPanel, _animation : MovieClip) {
			super(_scenesState, _animation);
			
			var keyboardManager : KeyboardManager = new KeyboardManager(animation);
			
			if (EditorState.isEditor.value == true) {
				keyboardManager.addShortcut(this, [Keyboard.ENTER], onForceStopShortcut);
				keyboardManager.addShortcut(this, [Keyboard.SPACE], onForceStopShortcut);
				keyboardManager.addShortcut(this, [Keyboard.SHIFT, Keyboard.LEFT], onGotoStartShortcut);
				keyboardManager.addShortcut(this, [Keyboard.LEFT], onStepBackwardsShortcut);
				keyboardManager.addShortcut(this, [Keyboard.RIGHT], onStepForwardsShortcut);
			}
			
			_scenesPanel.onSceneSelected.listen(this, onScenesPanelSceneSelected);
			_scenesPanel.onDelete.listen(this, onScenesPanelSceneDelete);
		}
		
		private function onScenesPanelSceneSelected(_scene : Scene) : void {
			gotoSceneStart(_scene, true);
			nextExpectedFrame = -1;
		}
		
		private function onScenesPanelSceneDelete() : void {
			var scene : Scene = ScenesState.currentScene.value;
			var scenes : Array = ScenesState.scenes.value;
			var index : Number = ArrayUtil.indexOf(scenes, scene);
			
			scenes.splice(index, 1);
			scenesState._scenes.setValue(scenes);
			exitCurrentScene(ScenesState.selectedChild.value);
			clearSelectedChild();
			selectedChildPath = null; // This is intentionally not cleared as a part of the function above
			
			GlobalEvents.sceneDeleted.emit(scene);
		}
		
		public override function onEnterFrame() : void {
			// In case the ability to switch to a preview mode is added
			if (EditorState.isEditor.value == false) {
				super.onEnterFrame();
				return;
			}
			
			var selectedChild : MovieClip = ScenesState.selectedChild.value;
			if (selectedChildPath == null) {
				return;
			}
			
			var isSelectedChildRecovered : Boolean = false;
			var isRemovedFromDisplayList : Boolean = selectedChild == null || DisplayObjectUtil.getParents(selectedChild).length != selectedChildParentChainLength;
			
			if (isRemovedFromDisplayList == true) {
				var childFromPath : DisplayObject = DisplayObjectUtil.getChildFromPath(animation, selectedChildPath);
				if (MovieClipUtil.isMovieClip(childFromPath) == true) {
					exitCurrentScene(selectedChild);
					selectedChild = MovieClipUtil.objectAsMovieClip(childFromPath);
					setSelectedChild(selectedChild);
					isSelectedChildRecovered = true;
				} else {
					exitCurrentScene(selectedChild);
					clearSelectedChild();
					selectedChild = null;
				}
			}
			
			if (selectedChild == null || ScenesState.isForceStopped.value == true) {
				nextExpectedFrame = -1;
				previousFrame = -1;
				return;
			}
			
			var activeSceneForChild : Scene = getActiveSceneForChild(selectedChild);
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			var lastFrameInChild : Number = MovieClipUtil.getTotalFrames(selectedChild);
			
			var isAtSameScene : Boolean = currentScene != null && currentScene == activeSceneForChild;
			// We can't always read from currrentScene.isStopped, as we intentionally update the scene after, and it takes at most 2 frames to determine if it's stopped
			var isStopped : Boolean = currentScene != null && (currentFrame == previousFrame || currentScene.isStopped(selectedChild));
			var notAtExpectedFrame : Boolean = nextExpectedFrame >= 0 && currentFrame != nextExpectedFrame;
			var isNextFrameStartOfCurrentScene : Boolean = currentScene != null && currentFrame == currentScene.getFirstFrame() - 1;
			var didLoop : Boolean = isStopped == false && isAtSameScene == true && previousFrame > 0 && currentFrame < previousFrame;
			
			var canSplitScene : Boolean = didLoop == true && notAtExpectedFrame == true && currentFrame > currentScene.getFirstFrame();
			var canEnterExistingScene : Boolean = activeSceneForChild != null && isAtSameScene == false;
			var canCreateNewScene : Boolean = notAtExpectedFrame == true && activeSceneForChild == null && isAtSameScene == false
			
			if (currentScene != activeSceneForChild && currentScene != null && activeSceneForChild != null) {
				if (activeSceneForChild.isTemporary == true) {
					merge(currentScene, activeSceneForChild);
				}
			}
			
			if (canEnterExistingScene == true) {
				exitCurrentScene(selectedChild);
				setCurrentScene(activeSceneForChild);
				trace("Entered existing scene");
			} 
			else if (canSplitScene == true) {
				trace("Splitting current scene:");
				trace("Current: " + currentFrame + ", First: " + currentScene.getFirstFrame() + ", Last: " + currentScene.getLastFrame());
				splitCurrentScene();
			} 
			else if (didLoop == true || (notAtExpectedFrame == true && activeSceneForChild != currentScene && isNextFrameStartOfCurrentScene == true)) {
				GlobalEvents.sceneLooped.emit();
			} 
			else if (notAtExpectedFrame == true && activeSceneForChild == null && isAtSameScene == false) {
				exitCurrentScene(selectedChild);
				setCurrentScene(addNewScene(selectedChild));
				trace("Created new scene at a natural starting point, frame: " + currentFrame + ", previous: " + previousFrame);
			}
			else if (isSelectedChildRecovered == true) {
				exitCurrentScene(selectedChild);
				setCurrentScene(addNewScene(selectedChild));
				trace("Created new scene due to selected child recovery, frame: " + currentFrame);
			}
			
			if (currentScene != null) {
				currentScene.update(selectedChild);
			}
			
			nextExpectedFrame = isStopped ? currentFrame : getNextPlayingFrame(selectedChild);
			previousFrame = currentFrame;
		}
		
		protected override function onChildSelected(_child : MovieClip) : void {			
			super.onChildSelected(_child);
			
			if (EditorState.isEditor.value == true && ScenesState.currentScene.value == null) {
				trace("Created new scene at a potentially invalid starting point, total scenes: " + ScenesState.scenes.value.length);
				var addedScene : Scene = addNewScene(_child);
				setCurrentScene(addedScene);
				addedScene.isTemporary = true;
			}
		}
		
		private function onForceStopShortcut() : void {
			if (currentScene == null) {
				return;
			}
			
			var selectedChild : MovieClip = ScenesState.selectedChild.value;
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			var wasForceStopped : Boolean = currentScene.isForceStopped();
			
			if (wasForceStopped == true) {
				currentScene.play(selectedChild);
			} else {
				currentScene.stop(selectedChild);
			}
			
			scenesState._isForceStopped.setValue(!wasForceStopped);
		}
		
		private function onGotoStartShortcut() : void {
			if (currentScene != null) {
				var selectedChild : MovieClip = ScenesState.selectedChild.value;
				var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
				
				currentScene.stopAtStart();
				scenesState._isForceStopped.setValue(true);
			}
		}
		
		private function onStepBackwardsShortcut() : void {
			stepFrames(-1);
		}
		
		private function onStepForwardsShortcut() : void {
			stepFrames(1);
		}
		
		private function stepFrames(_direction : Number) : void {
			var selectedChild : MovieClip = ScenesState.selectedChild.value;
			if (currentScene == null || ScenesState.selectedChild.value == null) {
				return;
			}
			
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			var totalFrames : Number = MovieClipUtil.getTotalFrames(selectedChild);
			var min : Number = currentScene.getFirstFrame();
			var max : Number = currentScene.getLastFrame();
			if (currentScene.isLoop() == true && max < totalFrames) {
				max -= 1; // If max is not the last frame, remove 1, as that frame is most likely including code that makes it loop
			}
			var targetFrame : Number = MathUtil.clamp(currentFrame + _direction, min, max);
			
			currentScene.gotoAndStop(selectedChild, targetFrame);
			scenesState._isForceStopped.setValue(true);
		}
		
		private function addNewScene(_selectedChild : MovieClip) : Scene {
			var scenes : Array = ScenesState.scenes.value;
			var scene : Scene = new Scene(animation);
			scene.init(_selectedChild);
			
			scenes.push(scene);
			sortScenes(scenes);
			scenesState._scenes.setValue(scenes);
			
			return scene;
		}
		
		private function addScene(_scene : Scene) : void {
			var scenes : Array = ScenesState.scenes.value;
			scenes.push(_scene);
			sortScenes(scenes);
			scenesState._scenes.setValue(scenes);
		}
		
		private function sortScenes(scenes : Array) : void {
			scenes.sort(function(_a : Scene, _b : Scene) : Number {
				var aFirstFrames : Array = _a.getFirstFrames();
				var bFirstFrames : Array = _b.getFirstFrames();
				var aScore : Number = 0;
				var maxLength : Number = Math.max(aFirstFrames.length, bFirstFrames.length);
				
				for (var i : Number = 0; i < maxLength; i++) {
					var aFrame : Number = aFirstFrames.length > i ? aFirstFrames[i] : -1;
					var bFrame : Number = bFirstFrames.length > i ? bFirstFrames[i] : -1;
					if (aFrame > bFrame) {
						return 1;
					}
					if (bFrame > aFrame) {
						return -1;
					}
				}
				
				return 0;
			});
		}
		
		private function merge(_sceneToExpand : Scene, _sceneToRemove : Scene) : void {
			var scenes : Array = ScenesState.scenes.value;
			var index : Number = ArrayUtil.indexOf(scenes, _sceneToRemove);
			
			_sceneToExpand.merge(_sceneToRemove);
			scenes.splice(index, 1);
			scenesState._scenes.setValue(scenes);
			GlobalEvents.scenesMerged.emit(_sceneToRemove, _sceneToExpand);
			trace("Found scene to merge with");
		}
		
		private function splitCurrentScene() : void {
			if (ScenesState.currentScene.value == null) {
				throw new Error("Unable to split current scene, no current scene have been set");
			}
			
			var currentSceneBeforeSplit : Scene = ScenesState.currentScene.value;
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(ScenesState.selectedChild.value);
			var clonedScene : Scene = currentSceneBeforeSplit.clone();
			
			clonedScene.setFirstFrame(currentFrame);
			currentSceneBeforeSplit.setLastFrame(currentFrame - 1);
			addScene(clonedScene);
			
			exitCurrentScene(ScenesState.selectedChild.value);
			setCurrentScene(clonedScene);
			
			GlobalEvents.splitScene.emit(currentSceneBeforeSplit, clonedScene);
			nextExpectedFrame = -1;
		}
	}
}