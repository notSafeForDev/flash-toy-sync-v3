package models {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenePluginsModel {
		
		protected var script : SceneScriptModel;
		
		public function ScenePluginsModel(_scene : SceneModel, _shouldInitializePlugins : Boolean) {
			if (_shouldInitializePlugins == true) {
				initializePlugins(_scene);
			}
		}
	
		protected function initializePlugins(_scene : SceneModel) : void {
			script = new SceneScriptModel(_scene);
		}
		
		public function clone(_clonedScene : SceneModel) : ScenePluginsModel {
			var clonedPlugins : ScenePluginsModel = new ScenePluginsModel(_clonedScene, false);
			
			clonedPlugins.script = script.clone(_clonedScene);
			
			return clonedPlugins;
		}
		
		public function getScript() : SceneScriptModel {
			return script;
		}
		
		public function toSaveData() : Object {
			return {script: script.toSaveData()};
		}
		
		public static function fromSaveData(_saveData : Object, _scene : SceneModel) : ScenePluginsModel {
			var plugins : ScenePluginsModel = new ScenePluginsModel(_scene, false);
			plugins.script = SceneScriptModel.fromSaveData(_saveData.script, _scene);
			
			return plugins;
		}
	}
}