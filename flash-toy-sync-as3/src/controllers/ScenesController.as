package controllers {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	
	import core.ArrayUtil;
	import core.DisplayObjectUtil;
	import core.KeyboardManager;
	import core.MathUtil;
	import core.MovieClipUtil;
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	import components.Scene;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenesController {
		
		private var globalState : GlobalState;
		
		private var animation : MovieClip;
		
		private var scenes : Array;
		private var currentScene : Scene;
		
		private var selectedChildPath : Array;
		private var selectedChildParentChainLength : Number = -1;
		private var previousFrame : Number = -1;
		private var nextExpectedFrame : Number = -1;
		
		public function ScenesController(_globalState : GlobalState, _animation : MovieClip) {
			globalState = _globalState;
			animation = _animation;
			
			scenes = [];
			selectedChildPath = null;
			
			var keyboardManager : KeyboardManager = new KeyboardManager(animation);
			
			keyboardManager.addShortcut(this, [Keyboard.ENTER], onForceStopShortcut);
			keyboardManager.addShortcut(this, [Keyboard.SPACE], onForceStopShortcut);
			keyboardManager.addShortcut(this, [Keyboard.SHIFT, Keyboard.LEFT], onGotoStartShortcut);
			keyboardManager.addShortcut(this, [Keyboard.LEFT], onStepBackwardsShortcut);
			keyboardManager.addShortcut(this, [Keyboard.RIGHT], onStepForwardsShortcut);
			
			GlobalEvents.childSelected.listen(this, onChildSelected);
			GlobalEvents.stopAtSceneStart.listen(this, onStopAtSceneStart);
			GlobalEvents.playFromSceneStart.listen(this, onPlayFromSceneStart);
		}
		
		public function onEnterFrame() : void {
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
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
			var sceneAtFrame : Scene = getSceneAtFrame(selectedChild);
			
			if (currentScene != null) {
				mergeWithOtherScenes(currentScene);
			}
			
			if (isSelectedChildUpdated == true || notAtExpectedFrame == true || didLoopNaturally == true) {
				var isAtCurrentScene : Boolean = currentScene != null && currentScene.isAtScene(animation, selectedChild, 0);
				// We check the next frame as well, as the loss could be caused by the scene being created 1 frame after it's intended to,
				// and since a scene can not consist of a single frame, this is a reasonable solution to that problem
				var isNextFrameInCurrentScene : Boolean = currentScene != null && currentScene.isAtScene(animation, selectedChild, 1);
				
				if (sceneAtFrame != null && sceneAtFrame != currentScene) {
					exitCurrentScene(selectedChild);
					currentScene = sceneAtFrame;
					trace("Entered existing scene from start");
					globalState._currentScene.setState(currentScene);
				}
				
				if (sceneAtFrame == null && isAtCurrentScene == false && isNextFrameInCurrentScene == false) {
					exitCurrentScene(selectedChild);
					currentScene = addNewScene(selectedChild);
					trace("Created new scene at a natural starting point, frame: " + currentFrame + ", total scenes: " + scenes.length);
					globalState._currentScene.setState(currentScene);
				}
			}
			
			if (currentScene != null) {
				currentScene.update(selectedChild);
			}
			
			nextExpectedFrame = isStopped ? currentFrame : getNextPlayingFrame(selectedChild);
			previousFrame = currentFrame;
		}
		
		private function onChildSelected(_child : MovieClip) : void {
			var previousChild : MovieClip = GlobalState.selectedChild.state;
			
			if (_child == null && previousChild != null) {
				exitCurrentScene(previousChild);
				clearSelectedChild();
				return;
			}
			
			var sceneAtFrame : Scene = getSceneAtFrame(_child);
			
			if (sceneAtFrame != currentScene) {
				exitCurrentScene(previousChild);
			}
			
			setSelectedChild(_child);
			
			if (sceneAtFrame != null) {
				currentScene = sceneAtFrame;
				globalState._currentScene.setState(currentScene);
			} else {
				currentScene = addNewScene(_child);
				trace("Created new scene at a potentially invalid starting point, total scenes: " + scenes.length);
				globalState._currentScene.setState(currentScene);
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
				exitCurrentScene(GlobalState.selectedChild.state);
				currentScene = null;
				clearSelectedChild();
			}
			
			currentScene = _scene;
			globalState._currentScene.setState(currentScene);
			
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
			
			// We have to assign this after both playFromStart/stopAtStart, and the selectedChild have been updated
			if (_shouldPlay == true) {
				nextExpectedFrame = MovieClipUtil.getCurrentFrame(GlobalState.selectedChild.state) + 1;
			} else {
				nextExpectedFrame = MovieClipUtil.getCurrentFrame(GlobalState.selectedChild.state);
			}
		}
		
		private function onForceStopShortcut() : void {
			if (currentScene == null) {
				return;
			}
			
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			
			if (currentScene.isForceStopped() == true) {
				currentScene.play(selectedChild);
				nextExpectedFrame = currentFrame + 1;
			} else {
				currentScene.stop(selectedChild);
				nextExpectedFrame = currentFrame;
			}
		}
		
		private function onGotoStartShortcut() : void {
			if (currentScene != null) {
				var selectedChild : MovieClip = GlobalState.selectedChild.state;
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
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			if (currentScene == null || GlobalState.selectedChild.state == null) {
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
					ArrayUtil.remove(scenes, currentScene);
					globalState._scenes.setState(scenes.slice());
				}
				
				currentScene.exitScene(_selectedChild);
				currentScene = null;
				globalState._currentScene.setState(null);
			}
		}
		
		private function setSelectedChild(_child : MovieClip) : void {
			nextExpectedFrame = -1;
			selectedChildParentChainLength = DisplayObjectUtil.getParents(_child).length;
			selectedChildPath = DisplayObjectUtil.getChildPath(animation, _child);
			
			globalState._selectedChild.setState(_child);
			globalState._selectedChildPath.setState(selectedChildPath);
		}
		
		private function clearSelectedChild() : void {
			globalState._selectedChild.setState(null);
			globalState._selectedChildPath.setState(null);
			
			// We don't clear the child path or parent chain length, as those are needed in order to reaquire the selected child
			nextExpectedFrame = -1;
		}
		
		private function addNewScene(_selectedChild : MovieClip) : Scene {
			var scene : Scene = new Scene(animation);
			scene.init(_selectedChild);
			
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
			
			globalState._scenes.setState(scenes.slice());
			return scene;
		}
		
		private function mergeWithOtherScenes(_scene : Scene) : void {
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				if (scene == _scene) {
					continue;
				}
				if (scene.intersects(_scene) == true) {
					_scene.merge(scene);
					scenes.splice(i, 1);
					globalState._scenes.setState(scenes.slice());
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
		
		private function getSceneAtFrame(_child : MovieClip) : Scene {			
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				if (scene.isAtScene(animation, _child, 0) == true) {
					return scene;
				}
			}
			
			return null;
		}
	}
}