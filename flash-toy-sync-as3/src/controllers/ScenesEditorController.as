package controllers {
	
	import core.ArrayUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import global.EditorState;
	import global.ScenesState;
	import ui.ScenesPanel;
	
	import core.DisplayObjectUtil;
	import core.KeyboardManager;
	import core.MathUtil;
	import core.MovieClipUtil;
	
	import global.GlobalEvents;
	
	import components.Scene;
	
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
			
			var isSelectedChildUpdated : Boolean = false;
			var isRemovedFromDisplayList : Boolean = selectedChild == null || DisplayObjectUtil.getParents(selectedChild).length != selectedChildParentChainLength;
			
			if (isRemovedFromDisplayList == true) {
				var childFromPath : DisplayObject = DisplayObjectUtil.getChildFromPath(animation, selectedChildPath);
				if (MovieClipUtil.isMovieClip(childFromPath) == true) {
					exitCurrentScene(selectedChild);
					selectedChild = MovieClipUtil.objectAsMovieClip(childFromPath);
					setSelectedChild(selectedChild);
					isSelectedChildUpdated = true;
				} else {
					exitCurrentScene(selectedChild);
					clearSelectedChild();
					selectedChild = null;
				}
			}
			
			if (selectedChild == null) {
				return;
			}
			
			var lastFrameInChild : Number = MovieClipUtil.getTotalFrames(selectedChild);
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			var isStopped : Boolean = currentScene != null && currentScene.isStopped(selectedChild);
			var notAtExpectedFrame : Boolean = nextExpectedFrame >= 0 && currentFrame != nextExpectedFrame;
			var didLoopNaturally : Boolean = currentFrame == 1 && previousFrame == lastFrameInChild && isStopped == false;
			var activeSceneForChild : Scene = getActiveSceneForChild(selectedChild);
			
			if (currentScene != null) {
				mergeWithOtherScenes(currentScene);
			}
			
			if (isSelectedChildUpdated == true || notAtExpectedFrame == true || didLoopNaturally == true) {
				var isAtCurrentScene : Boolean = currentScene != null && currentScene.isAtScene(animation, selectedChild, 0);
				// We check the next frame as well, as the loss could be caused by the scene being created 1 frame after it's intended to,
				// and since a scene can not consist of a single frame, this is a reasonable solution to that problem
				var isNextFrameInCurrentScene : Boolean = currentScene != null && currentScene.isAtScene(animation, selectedChild, 1);
				
				if (isAtCurrentScene == true || isNextFrameInCurrentScene == true) {
					GlobalEvents.sceneLooped.emit();
				}
				
				if (isAtCurrentScene && notAtExpectedFrame == true) {
					trace("Current: " + currentFrame + ", First: " + currentScene.getFirstFrame() + ", Expected: " + nextExpectedFrame + ", isStopped: " + isStopped);
				}
				
				if (activeSceneForChild != null && activeSceneForChild != currentScene) {
					exitCurrentScene(selectedChild);
					setCurrentScene(activeSceneForChild);
					trace("Entered existing scene from start");
				}
				
				if (activeSceneForChild == null && isAtCurrentScene == false && isNextFrameInCurrentScene == false) {
					exitCurrentScene(selectedChild);
					if (EditorState.isEditor.value == true) {
						setCurrentScene(addNewScene(selectedChild));
						trace("Created new scene at a natural starting point, frame: " + currentFrame + ", total scenes: " + ScenesState.scenes.value.length);
					}
				}
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
				setCurrentScene(addNewScene(_child));
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
				nextExpectedFrame = currentFrame + 1;
			} else {
				currentScene.stop(selectedChild);
				nextExpectedFrame = currentFrame;
			}
			
			scenesState._isForceStopped.setValue(!wasForceStopped);
		}
		
		private function onGotoStartShortcut() : void {
			if (currentScene != null) {
				var selectedChild : MovieClip = ScenesState.selectedChild.value;
				var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
				
				currentScene.stopAtStart();
				nextExpectedFrame = currentFrame;
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
			var targetFrame : Number = MathUtil.clamp(currentFrame + _direction, currentScene.getFirstFrame(), currentScene.getLastFrame());
			
			currentScene.gotoAndStop(selectedChild, targetFrame);
			nextExpectedFrame = targetFrame;
		}
		
		private function addNewScene(_selectedChild : MovieClip) : Scene {
			var scene : Scene = new Scene(animation);
			scene.init(_selectedChild);
			
			var scenes : Array = ScenesState.scenes.value;
			
			scenes.push(scene);
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
			
			scenesState._scenes.setValue(scenes);
			return scene;
		}
		
		private function mergeWithOtherScenes(_scene : Scene) : void {
			if (EditorState.isEditor.value == false) {
				return;
			}
			
			var scenes : Array = ScenesState.scenes.value;
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				if (scene == _scene) {
					continue;
				}
				if (scene.intersects(_scene) == true) {
					_scene.merge(scene);
					scenes.splice(i, 1);
					scenesState._scenes.setValue(scenes);
					i--;
					GlobalEvents.scenesMerged.emit(scene, _scene);
					trace("Found scene to merge with");
				}
			}
		}
	}
}