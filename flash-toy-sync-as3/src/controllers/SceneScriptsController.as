package controllers {
	
	import global.GlobalEvents;
	import global.SceneScriptsState;
	import global.ScenesState;
	
	import components.Scene;
	import components.SceneScript;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptsController {
		
		private var sceneScriptsState : SceneScriptsState;
		
		public function SceneScriptsController(_sceneScriptsState : SceneScriptsState) {
			sceneScriptsState = _sceneScriptsState;
			
			GlobalEvents.sceneChanged.listen(this, onSceneChanged);
			GlobalEvents.splitScene.listen(this, onSplitScene);
			GlobalEvents.scenesMerged.listen(this, onScenesMerged);
			GlobalEvents.sceneDeleted.listen(this, onSceneDeleted);
		}
		
		private function onSceneChanged() : void {
			sceneScriptsState._currentScript.setValue(getSceneScriptForCurrentScene());
		}
		
		private function onSplitScene(_existingScene : Scene, _newScene : Scene) : void {
			var sceneScript : SceneScript = getSceneScriptForScene(_existingScene);
			if (sceneScript == null) {
				return;
			}
			
			var newSceneScript : SceneScript = sceneScript.clone();
			
			sceneScript.setStartFrame(_existingScene.getFirstFrame());
			sceneScript.setEndFrame(_existingScene.getLastFrame());
			
			newSceneScript.scene = _newScene;
			newSceneScript.setStartFrame(_newScene.getFirstFrame());
			newSceneScript.setEndFrame(_newScene.getLastFrame());
			
			var sceneScripts : Array = SceneScriptsState.scripts.value;
			sceneScripts.push(newSceneScript);
			sceneScriptsState._scripts.setValue(sceneScripts);
		}
		
		private function onScenesMerged(_previousScene : Scene, _combinedScene : Scene) : void {
			var sceneScripts : Array = SceneScriptsState.scripts.value;
			for (var i : Number = 0; i < sceneScripts.length; i++) {
				var sceneScript : SceneScript = sceneScripts[i];
				if (sceneScript.scene == _previousScene) {
					sceneScript.scene = _combinedScene;
				}
			}
		}
		
		private function onSceneDeleted(_scene : Scene) : void {
			var sceneScripts : Array = SceneScriptsState.scripts.value;
			for (var i : Number = 0; i < sceneScripts.length; i++) {
				var sceneScript : SceneScript = sceneScripts[i];
				if (sceneScript.scene == _scene) {
					sceneScripts.splice(i, 1);
					sceneScriptsState._scripts.setValue(sceneScripts);
					if (SceneScriptsState.currentScript.value == sceneScript) {
						sceneScriptsState._currentScript.setValue(null);
					}
					break;
				}
			}
		}
		
		protected function getSceneScriptForCurrentScene() : SceneScript {
			return getSceneScriptForScene(ScenesState.currentScene.value);
		}
		
		protected function getSceneScriptForScene(_scene : Scene) : SceneScript {
			var sceneScripts : Array = SceneScriptsState.scripts.value;
			for (var i : Number = 0; i < sceneScripts.length; i++) {
				var sceneScript : SceneScript = sceneScripts[i];
				if (sceneScript.getScene() == _scene) {
					return sceneScript;
				}
			}
			
			return null;
		}
	}
}