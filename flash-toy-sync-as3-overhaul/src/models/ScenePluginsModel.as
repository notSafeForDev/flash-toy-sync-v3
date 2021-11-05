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
		
		public function clone(_sourcePlugins : ScenePluginsModel, _clonedScene : SceneModel) : ScenePluginsModel {
			var clonedPlugins : ScenePluginsModel = new ScenePluginsModel(_clonedScene, false);
			
			clonedPlugins.script = _sourcePlugins.script.clone(_clonedScene);
			
			return clonedPlugins;
		}
		
		public function getScript() : SceneScriptModel {
			return script;
		}
	}
}