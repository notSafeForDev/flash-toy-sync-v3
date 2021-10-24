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
	import global.EditorState;
	import global.ScenesState;
	
	import components.Scene;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenesController {
		
		protected var scenesState : ScenesState;
		
		protected var animation : MovieClip;
		
		protected var currentScene : Scene;
		
		protected var selectedChildPath : Array;
		protected var selectedChildParentChainLength : Number = -1;
		protected var previousFrame : Number = -1;
		protected var nextExpectedFrame : Number = -1;
		
		public function ScenesController(_scenesState : ScenesState, _animation : MovieClip) {
			scenesState = _scenesState;
			animation = _animation;
			
			selectedChildPath = null;
			
			GlobalEvents.childSelected.listen(this, onChildSelected);
			GlobalEvents.stopAtSceneFrames.listen(this, onStopAtSceneFrames);
			GlobalEvents.playFromSceneFrames.listen(this, onPlayFromSceneFrames);
		}
		
		public function onEnterFrame() : void {	
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
		
		protected function onChildSelected(_child : MovieClip) : void {
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
			}
		}
		
		private function onStopAtSceneFrames(_scene : Scene, _frames : Array) : void {
			gotoSceneFrames(_scene, _frames, false);
		}
		
		private function onPlayFromSceneFrames(_scene : Scene, _frames : Array) : void {
			gotoSceneFrames(_scene, _frames, true);
		}
		
		protected function gotoSceneFrames(_scene : Scene, _frames : Array, _shouldPlay : Boolean) : void {
			var isSameSceneAsCurrent : Boolean = _scene == currentScene;
			
			if (currentScene != null && isSameSceneAsCurrent == false) {
				exitCurrentScene(ScenesState.selectedChild.value);
				clearSelectedChild();
			}
			
			setCurrentScene(_scene);
			
			if (_shouldPlay == true) {
				_scene.playFromFrames(_frames);
			} else {
				_scene.stopAtFrames(_frames);
			}
			
			if (isSameSceneAsCurrent == false) {
				var childFromScene : DisplayObject = DisplayObjectUtil.getChildFromPath(animation, _scene.getPath());
				var selectedChild : MovieClip = MovieClipUtil.objectAsMovieClip(childFromScene);
				setSelectedChild(selectedChild);
			}
			
			trace("went to scene start, frame: " + MovieClipUtil.getCurrentFrame(ScenesState.selectedChild.value));
			
			if (_shouldPlay == true) {
				nextExpectedFrame = MovieClipUtil.getCurrentFrame(ScenesState.selectedChild.value) + 1;
			} else {
				nextExpectedFrame = MovieClipUtil.getCurrentFrame(ScenesState.selectedChild.value);
			}
		}
		
		protected function exitCurrentScene(_selectedChild : MovieClip) : void {
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
		
		protected function setSelectedChild(_child : MovieClip) : void {
			nextExpectedFrame = -1;
			selectedChildPath = DisplayObjectUtil.getChildPath(animation, _child);
			selectedChildParentChainLength = DisplayObjectUtil.getParents(_child).length;
			
			scenesState._selectedChild.setValue(_child);
			scenesState._selectedChildPath.setValue(selectedChildPath);
		}
		
		protected function setCurrentScene(_scene : Scene) : void {
			currentScene = _scene;
			scenesState._currentScene.setValue(_scene);
			
			GlobalEvents.sceneChanged.emit();
		}
		
		protected function clearSelectedChild() : void {
			scenesState._selectedChild.setValue(null);
			scenesState._selectedChildPath.setValue(null);
			
			// We don't clear the child path, as it is needed in order to reaquire the selected child
			nextExpectedFrame = -1;
		}
		
		protected function getNextPlayingFrame(_movieClip : MovieClip) : Number {
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(_movieClip);
			var totalFrames : Number = MovieClipUtil.getTotalFrames(_movieClip);
			return currentFrame == totalFrames ? 1 : currentFrame + 1;
		}
		
		protected function getActiveSceneForChild(_child : MovieClip) : Scene {
			var scenes : Array = ScenesState.scenes.value;
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				if (scene.isAtScene(_child, 0) == true) {
					return scene;
				}
			}
			
			return null;
		}
		
		protected function getActiveScene() : Scene {
			var scenes : Array = ScenesState.scenes.value;
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				if (scene.isActive() == true) {
					return scene;
				}
			}
			
			return null;
		}
	}
}