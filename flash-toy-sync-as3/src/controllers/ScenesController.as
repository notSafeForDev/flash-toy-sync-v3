package controllers {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import global.EditorState;
	import global.ScenesState;
	
	import core.ArrayUtil;
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
	public class ScenesController {
		
		private var scenesState : ScenesState;
		
		private var animation : MovieClip;
		
		private var currentScene : Scene;
		
		private var selectedChildPath : Array;
		private var selectedChildParentChainLength : Number = -1;
		private var previousFrame : Number = -1;
		private var nextExpectedFrame : Number = -1;
		private var shouldAutoDetectActiveScene : Boolean;
		
		public function ScenesController(_scenesState : ScenesState, _animation : MovieClip) {
			scenesState = _scenesState;
			animation = _animation;
			
			selectedChildPath = null;
			
			// This could also be utilized for the editor, as a way to check how it will work when played regularly
			shouldAutoDetectActiveScene = EditorState.isEditor.value == false;
			
			var keyboardManager : KeyboardManager = new KeyboardManager(animation);
			
			if (EditorState.isEditor.value == true) {
				keyboardManager.addShortcut(this, [Keyboard.ENTER], onForceStopShortcut);
				keyboardManager.addShortcut(this, [Keyboard.SPACE], onForceStopShortcut);
				keyboardManager.addShortcut(this, [Keyboard.SHIFT, Keyboard.LEFT], onGotoStartShortcut);
				keyboardManager.addShortcut(this, [Keyboard.LEFT], onStepBackwardsShortcut);
				keyboardManager.addShortcut(this, [Keyboard.RIGHT], onStepForwardsShortcut);
			}
			
			GlobalEvents.childSelected.listen(this, onChildSelected);
			GlobalEvents.stopAtSceneStart.listen(this, onStopAtSceneStart);
			GlobalEvents.playFromSceneStart.listen(this, onPlayFromSceneStart);
		}
		
		public function onEnterFrame() : void {
			if (shouldAutoDetectActiveScene == true) {
				enterFrameAutoDetectActiveScene();
			} else {
				enterFrame();
			}
		}
		
		private function enterFrame() : void {
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
		
		private function enterFrameAutoDetectActiveScene() : void {
			var activeScene : Scene = getActiveScene();
			var selectedChild : MovieClip = ScenesState.selectedChild.value;
			var currentFrame : Number = selectedChild != null ? MovieClipUtil.getCurrentFrame(selectedChild) : -1;
			var isStopped : Boolean = currentScene != null && currentScene.isStopped(selectedChild);
			
			if (selectedChild != null && currentScene != null && activeScene == currentScene) {
				var lastFrameInChild : Number = MovieClipUtil.getTotalFrames(selectedChild);
				var notAtExpectedFrame : Boolean = nextExpectedFrame >= 0 && currentFrame != nextExpectedFrame;
				var didLoopNaturally : Boolean = currentFrame == 1 && previousFrame == lastFrameInChild && isStopped == false;
				
				if (didLoopNaturally == true || notAtExpectedFrame == true) {
					GlobalEvents.sceneLooped.emit();
				}
			}
			
			if (currentScene != activeScene) {
				if (currentScene != null) {
					exitCurrentScene(selectedChild);
					clearSelectedChild();
					selectedChild = null;
				}
				
				if (activeScene != null) {
					var childFromPath : DisplayObject = DisplayObjectUtil.getChildFromPath(animation, activeScene.getPath());
					selectedChild = MovieClipUtil.objectAsMovieClip(childFromPath);
					isStopped = activeScene.isStopped(selectedChild);
					setCurrentScene(activeScene);
					setSelectedChild(selectedChild);
				}
			}
			
			if (selectedChild != null) {
				currentFrame = MovieClipUtil.getCurrentFrame(selectedChild);
				nextExpectedFrame = isStopped ? currentFrame : getNextPlayingFrame(selectedChild);
				previousFrame = MovieClipUtil.getCurrentFrame(selectedChild);
			} else {
				nextExpectedFrame = -1;
				previousFrame = -1;
			}
		}
		
		private function onChildSelected(_child : MovieClip) : void {
			var previousChild : MovieClip = ScenesState.selectedChild.value;
			
			if (_child == null && previousChild != null) {
				exitCurrentScene(previousChild);
				clearSelectedChild();
				return;
			}
			
			var activeSceneForChild : Scene = getActiveSceneForChild(_child);
			
			if (activeSceneForChild != currentScene) {
				exitCurrentScene(previousChild);
			}
			
			setSelectedChild(_child);
			
			if (activeSceneForChild != null) {
				setCurrentScene(activeSceneForChild);
			} else if (EditorState.isEditor.value == true) {
				trace("Created new scene at a potentially invalid starting point, total scenes: " + ScenesState.scenes.value.length);
				setCurrentScene(addNewScene(_child));
			}
		}
		
		private function onStopAtSceneStart(_scene : Scene) : void {
			gotoSceneStart(_scene, false);
		}
		
		private function onPlayFromSceneStart(_scene : Scene) : void {
			gotoSceneStart(_scene, true);
		}
		
		private function gotoSceneStart(_scene : Scene, _shouldPlay : Boolean) : void {
			var isSameSceneAsCurrent : Boolean = _scene == currentScene;
			
			if (currentScene != null && isSameSceneAsCurrent == false) {
				exitCurrentScene(ScenesState.selectedChild.value);
				clearSelectedChild();
			}
			
			setCurrentScene(_scene);
			
			if (_shouldPlay == true) {
				_scene.playFromStart();
			} else {
				_scene.stopAtStart();
			}
			
			if (isSameSceneAsCurrent == false) {
				var childFromScene : DisplayObject = DisplayObjectUtil.getChildFromPath(animation, _scene.getPath());
				var selectedChild : MovieClip = MovieClipUtil.objectAsMovieClip(childFromScene);
				setSelectedChild(selectedChild);
			}
			
			if (_shouldPlay == true) {
				nextExpectedFrame = MovieClipUtil.getCurrentFrame(ScenesState.selectedChild.value) + 1;
			} else {
				nextExpectedFrame = MovieClipUtil.getCurrentFrame(ScenesState.selectedChild.value);
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
		
		private function exitCurrentScene(_selectedChild : MovieClip) : void {
			if (currentScene != null) {
				if (currentScene.getFirstFrame() == currentScene.getLastFrame()) {
					var scenes : Array = ScenesState.scenes.value;
					ArrayUtil.remove(scenes, currentScene);
					scenesState._scenes.setValue(scenes);
				}
				
				currentScene.exitScene(_selectedChild);
				currentScene = null;
				scenesState._currentScene.setValue(null);
				scenesState._isForceStopped.setValue(false);
				
				GlobalEvents.sceneChanged.emit();
			}
		}
		
		private function setSelectedChild(_child : MovieClip) : void {
			nextExpectedFrame = -1;
			selectedChildParentChainLength = DisplayObjectUtil.getParents(_child).length;
			selectedChildPath = DisplayObjectUtil.getChildPath(animation, _child);
			
			scenesState._selectedChild.setValue(_child);
			scenesState._selectedChildPath.setValue(selectedChildPath);
		}
		
		private function setCurrentScene(_scene : Scene) : void {
			currentScene = _scene;
			scenesState._currentScene.setValue(_scene);
			
			GlobalEvents.sceneChanged.emit();
		}
		
		private function clearSelectedChild() : void {
			scenesState._selectedChild.setValue(null);
			scenesState._selectedChildPath.setValue(null);
			
			// We don't clear the child path or parent chain length, as those are needed in order to reaquire the selected child
			nextExpectedFrame = -1;
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
		
		private function getNextPlayingFrame(_movieClip : MovieClip) : Number {
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(_movieClip);
			var totalFrames : Number = MovieClipUtil.getTotalFrames(_movieClip);
			return currentFrame == totalFrames ? 1 : currentFrame + 1;
		}
		
		private function getActiveSceneForChild(_child : MovieClip) : Scene {
			var scenes : Array = ScenesState.scenes.value;
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				if (scene.isAtScene(animation, _child, 0) == true) {
					return scene;
				}
			}
			
			return null;
		}
		
		private function getActiveScene() : Scene {
			var scenes : Array = ScenesState.scenes.value;
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				if (scene.isActive(animation) == true) {
					return scene;
				}
			}
			
			return null;
		}
	}
}