package controllers {
	
	import components.MarkerSceneScript;
	import components.Scene;
	import components.SceneScript;
	import core.JSONLoader;
	import core.VersionUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import global.AnimationInfoState;
	import global.GlobalEvents;
	import global.SceneScriptsState;
	import global.ScenesState;
	import ui.SaveDataPanel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SaveDataController {
		
		private var scenesState : ScenesState;
		private var sceneScriptsState : SceneScriptsState;
		
		private var animation : MovieClip;
		
		private var saveDataPanel : SaveDataPanel;
		
		private var sharedObject : SharedObject;
		
		public function SaveDataController(_scenesState : ScenesState, _sceneScriptsState : SceneScriptsState, _animation : MovieClip, _saveDataPanel : SaveDataPanel) {
			scenesState = _scenesState;
			sceneScriptsState = _sceneScriptsState;
			
			animation = _animation;
			saveDataPanel = _saveDataPanel;
			
			var animationName : String = AnimationInfoState.name.value;
			var sharedObjectName : String = VersionUtil.isActionscript3() ? animationName + "-as3" : animationName + "-as2";
			
			sharedObject = SharedObject.getLocal(sharedObjectName, "/");
			
			var hasLoadedAnyData : Boolean = false;
			
			if (sharedObject.data.scenes != undefined) {
				loadScenes(sharedObject.data.scenes);
				hasLoadedAnyData = true;
			}
			if (sharedObject.data.sceneScripts != undefined) {
				loadSceneScripts(sharedObject.data.sceneScripts);
				hasLoadedAnyData = true;
			}
			
			saveDataPanel.setSaveData(JSON.stringify(sharedObject.data, null));
			
			if (hasLoadedAnyData == false) {
				JSONLoader.load("animations/" + animationName.split(".swf")[0] + ".json", this, onJSONLoaded);
			}
			
			_saveDataPanel.onSave.listen(this, onSaveDataPanelSave);
		}
		
		private function onJSONLoaded(_json : Object) : void {
			if (_json.error != undefined) {
				return;
			}
			
			if (_json.scenes != undefined) {
				loadScenes(_json.scenes);
			}
			if (_json.sceneScripts != undefined) {
				loadSceneScripts(_json.sceneScripts);
			}
			
			saveDataPanel.setSaveData(JSON.stringify(_json));
		}
		
		private function onSaveDataPanelSave() : void {
			var i : Number;
			
			sharedObject.data.scenes = [];
			sharedObject.data.sceneScripts = [];
			
			var scenes : Array = ScenesState.scenes.value;
			for (i = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				sharedObject.data.scenes.push(scene.toSaveData());
			}
			
			var sceneScripts : Array = SceneScriptsState.scripts.value;
			for (i = 0; i < sceneScripts.length; i++) {
				var sceneScript : SceneScript = sceneScripts[i];
				sharedObject.data.sceneScripts.push(sceneScript.toSaveData());
			}
			
			saveDataPanel.setSaveData(JSON.stringify(sharedObject.data, null));
		}
		
		private function loadScenes(_scenes : Array) : void {
			var scenes : Array = [];
			for (var i : Number = 0; i < _scenes.length; i++) {
				var scene : Scene = Scene.fromSaveData(animation, _scenes[i]);
				scenes.push(scene);
			}
			
			scenesState._scenes.setValue(scenes);
		}
		
		private function loadSceneScripts(_sceneScripts : Array) : void {
			var sceneScripts : Array = [];
			for (var i : Number = 0; i < _sceneScripts.length; i++) {
				if (_sceneScripts[i].type == MarkerSceneScript.sceneScriptType) {
					sceneScripts.push(MarkerSceneScript.fromSaveData(_sceneScripts[i]));
				} else {
					sceneScripts.push(SceneScript.fromSaveData(_sceneScripts[i]));
				}
			}
			
			sceneScriptsState._scripts.setValue(sceneScripts);
		}
	}
}