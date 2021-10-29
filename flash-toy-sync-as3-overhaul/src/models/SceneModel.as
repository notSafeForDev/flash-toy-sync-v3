package models {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneModel {
		
		private var path : Vector.<String>;
		
		private var startFrames : Vector.<Number>;
		private var endFrames : Vector.<Number>;
		
		private var script : SceneScriptModel;
		
		private var isForceStopped : Boolean;
		
		public function SceneModel(_path : Vector.<String>) {
			path = _path;
		}
		
		public  function fromSaveData(_saveData : Object) : void {
			path = _saveData.path;
			startFrames = _saveData.startFrames;
			endFrames = _saveData.endFrames;
		}
		
		public function toSaveData() : Object {
			return {};
		}
		
		public function update() : void {
			
		}
		
		public function canEnter() : Boolean {
			return true;
		}
		
		public function enter() : void {
			
		}
		
		public function exit() : void {
			
		}
		
		public function play() : void {
			
		}
		
		public function stop() : void {
			
		}
		
		public function stepFrames() : void {
			
		}
		
		public function gotoFrame() : void {
			
		}
	}
}