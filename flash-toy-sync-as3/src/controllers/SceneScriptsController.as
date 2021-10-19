package controllers {
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	import components.Scene;
	import components.SceneScript;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptsController {
		
		private var globalState : GlobalState;
		
		public function SceneScriptsController(_globalState : GlobalState) {
			globalState = _globalState;
			
			GlobalEvents.sceneChanged.listen(this, onSceneChanged);
			GlobalEvents.scenesMerged.listen(this, onScenesMerged);
		}
		
		private function onSceneChanged() : void {
			globalState._currentSceneScript.setState(getSceneScriptForCurrentScene());
		}
		
		private function onScenesMerged(_previousScene : Scene, _combinedScene : Scene) : void {
			var sceneScripts : Array = GlobalState.sceneScripts.state;
			for (var i : Number = 0; i < sceneScripts.length; i++) {
				var sceneScript : SceneScript = sceneScripts[i];
				if (sceneScript.scene == _previousScene) {
					sceneScript.scene = _combinedScene;
				}
			}
		}
		
		protected function getSceneScriptForCurrentScene() : SceneScript {
			if (GlobalState.currentScene.state == null) {
				return null;
			}
			
			var sceneScripts : Array = GlobalState.sceneScripts.state;
			for (var i : Number = 0; i < sceneScripts.length; i++) {
				var existingSceneScript : SceneScript = sceneScripts[i];
				if (existingSceneScript.getScene() == GlobalState.currentScene.state) {
					return existingSceneScript;
				}
			}
			
			return null;
		}
	}
}