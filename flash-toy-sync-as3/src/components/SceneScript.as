package components {
	
	import flash.display.MovieClip;
	
	import global.ScenesState;
	
	import core.DisplayObjectUtil;
	import core.MovieClipUtil;
	
	import components.Scene;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScript {
		
		public static var sceneScriptType : String = "SCENE_SCRIPT";
		
		public var scene : Scene;
		
		protected var depthsAtFrames : Array = null;
		protected var startRootFrame : Number = -1;
		
		public function SceneScript(_scene : Scene) {
			scene = _scene;
			depthsAtFrames = [];
		}
		
		public function toSaveData() : Object {
			return {
				type: getType(),
				depthsAtFrames: depthsAtFrames.slice(),
				startRootFrame: startRootFrame,
				scenePath: scene.getPath(),
				sceneFirstFrames: scene.getFirstFrames()
			}
		}
		
		public static function fromSaveData(_saveData : Object) : SceneScript {
			var scenes : Array = ScenesState.scenes.value;
			var scene : Scene;
			for (var i : Number = 0; i < scenes.length; i++) {
				scene = scenes[i];
				if (scene.isFrameInScene(_saveData.scenePath, _saveData.sceneFirstFrames) == true) {
					break;
				}
			}
			
			var sceneScript : SceneScript = new SceneScript(scene);
			sceneScript.depthsAtFrames = _saveData.depthsAtFrames.slice();
			sceneScript.startRootFrame = _saveData.startRootFrame.slice();
			
			return sceneScript;
		}
		
		public function clone() : SceneScript {
			var cloned : SceneScript = new SceneScript(scene);
			cloned.depthsAtFrames = depthsAtFrames.slice();
			cloned.startRootFrame = startRootFrame;
			
			return cloned;
		}
		
		public function setStartFrame(_frame : Number) : void {
			if (_frame < startRootFrame) {
				var amountToAdd : Number = startRootFrame - _frame;
				for (var i : Number = 0; i < amountToAdd; i++) {
					addBlankDataToBeginning();
				}
			} else if (_frame > startRootFrame + depthsAtFrames.length) {
				removeDataFromBeginning(_frame - startRootFrame);
			}
			startRootFrame = _frame;
		}
		
		public function setEndFrame(_frame : Number) : void {
			var current : Number = startRootFrame + depthsAtFrames.length;
			if (_frame < current) {
				var amountToRemove : Number = current - _frame;
				removeDataFromEnd(amountToRemove);
			} else if (_frame > current) {
				for (var i : Number = 0; i < _frame - current; i++) {
					addBlankDataToEnd();
				}
			}
		}
		
		public function getType() : String {
			return sceneScriptType;
		}
		
		public function startRecording(_topParent : MovieClip, _depth : Number) : void {
			updateRecording(_topParent, _depth);
		}
		
		public function updateRecording(_topParent : MovieClip, _depth : Number) : void {
			var animationRoot : MovieClip = ScenesState.selectedChild.value;
			var currentRootFrame : Number = MovieClipUtil.getCurrentFrame(animationRoot);
			
			if (startRootFrame < 0) {
				startRootFrame = currentRootFrame;
			}
			
			if (currentRootFrame < startRootFrame) {
				for (var i : Number = 0; i < startRootFrame - currentRootFrame; i++) {
					addBlankDataToBeginning();
				}
				startRootFrame = currentRootFrame;
			}
			
			var frameIndex : Number = currentRootFrame - startRootFrame;
			
			if (frameIndex < 0) {
				return;
			}
			
			while (frameIndex >= depthsAtFrames.length) {
				addBlankDataToEnd();
			}
			
			addDataForCurrentFrame(frameIndex, _depth);
		}
		
		public function isAtScene(_topParent : MovieClip, _nestedChild : MovieClip) : Boolean {
			return scene.isAtScene(_topParent, _nestedChild, 0);
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
		
		protected function addBlankDataToBeginning() : void {
			depthsAtFrames.unshift(-1);
		}
		
		protected function addBlankDataToEnd() : void {
			depthsAtFrames.push(-1);
		}
		
		protected function removeDataFromBeginning(_amount : Number) : void {
			depthsAtFrames = depthsAtFrames.slice(_amount);
		}
		
		protected function removeDataFromEnd(_amount : Number) : void {
			depthsAtFrames.length = depthsAtFrames.length - _amount;
		}
		
		protected function addDataForCurrentFrame(_index : Number, _depth : Number) : void {			
			if (_index >= depthsAtFrames.length) {
				depthsAtFrames.push(_depth);
			} else {
				depthsAtFrames[_index] = _depth;
			}
		}
	}
}