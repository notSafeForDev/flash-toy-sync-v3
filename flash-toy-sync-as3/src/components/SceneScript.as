package components {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import core.MovieClipUtil;
	
	import global.GlobalState;
	
	import components.Scene;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScript {
		
		public static var sceneScriptType : String = "SCENE_SCRIPT";
		
		public var scene : Scene;
		
		private var depthsAtFrames : Array = null;
		private var startRootFrame : Number = -1;
		
		public function SceneScript(_scene : Scene) {
			scene = _scene;
			depthsAtFrames = [];
		}
		
		public function getType() : String {
			return sceneScriptType;
		}
		
		public function startRecording(_topParent : MovieClip, _depth : Number) : void {
			updateRecording(_topParent, _depth);
		}
		
		public function updateRecording(_topParent : MovieClip, _depth : Number) : void {
			var animationRoot : MovieClip = GlobalState.selectedChild.state;
			var currentRootFrame : Number = MovieClipUtil.getCurrentFrame(animationRoot);
			
			if (startRootFrame < 0) {
				startRootFrame = currentRootFrame;
			}
			
			if (currentRootFrame < startRootFrame) {
				for (var i : Number = 0; i < startRootFrame - currentRootFrame; i++) {
					depthsAtFrames.unshift(0);
				}
				startRootFrame = currentRootFrame;
			}
			
			var frameIndex : Number = currentRootFrame - startRootFrame;
			
			if (frameIndex >= depthsAtFrames.length) {
				depthsAtFrames.push(_depth);
			} else {
				depthsAtFrames[frameIndex] = _depth;
			}
		}
		
		public function isAtScene(_topParent : MovieClip) : Boolean {
			return scene.isAtSceneCurrently(_topParent);
		}
		
		public function canRecord() : Boolean {
			return true;
		}
		
		public function getScene() : Scene {
			return scene;
		}
		
		public function getDepths() : Array {
			return depthsAtFrames.slice();
		}
		
		public function getStartFrame() : Number {
			return startRootFrame;
		}
		
		public function playFromStart() : void {
			scene.playFromStart();
		}
		
		public function stopAtStart() : void {
			scene.stopAtStart();
		}
	}
}