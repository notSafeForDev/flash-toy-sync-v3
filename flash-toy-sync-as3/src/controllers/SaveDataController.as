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
		
		private var animationInfoState : AnimationInfoState;
		private var scenesState : ScenesState;
		private var sceneScriptsState : SceneScriptsState;
		
		private var animation : MovieClip;
		
		private var saveDataPanel : SaveDataPanel;
		
		private var sharedObject : SharedObject;
		
		public function SaveDataController(_animationInfoState : AnimationInfoState, _scenesState : ScenesState, _sceneScriptsState : SceneScriptsState, _saveDataPanel : SaveDataPanel, _animation : MovieClip) {
			animationInfoState = _animationInfoState;
			scenesState = _scenesState;
			sceneScriptsState = _sceneScriptsState;
			
			animation = _animation;
			saveDataPanel = _saveDataPanel;
			
			var animationName : String = AnimationInfoState.name.value;
			var sharedObjectName : String = VersionUtil.isActionscript3() ? animationName + "-as3" : animationName + "-as2";
			
			sharedObject = SharedObject.getLocal(sharedObjectName, "/");
			
			var haveLoaded : Boolean = load(sharedObject.data);
			
			if (haveLoaded == false) {
				JSONLoader.load("animations/" + animationName.split(".swf")[0] + ".json", this, onJSONLoaded);
			}
			
			_saveDataPanel.onSave.listen(this, onSaveDataPanelSave);
		}
		
		private function onJSONLoaded(_json : Object) : void {
			if (_json.error != undefined) {
				return;
			}
			
			load(_json);
		}
		
		private function onSaveDataPanelSave() : void {
			save();
		}
		
		private function save() : void {
			// data is read only, so we can't assign it directly
			updateSaveData(sharedObject.data);
		}
		
		private function load(_data : Object) : Boolean {
			var haveLoadedAnyData : Boolean = false;
			if (_data.scenes != undefined) {
				loadScenes(_data.scenes);
				haveLoadedAnyData = true;
			}
			if (_data.sceneScripts != undefined) {
				loadSceneScripts(_data.sceneScripts);
				haveLoadedAnyData = true;
			}
			if (_data.animationWidth != undefined && _data.animationHeight != undefined) {
				animationInfoState._width.setValue(_data.animationWidth);
				animationInfoState._height.setValue(_data.animationHeight);
				haveLoadedAnyData = true;
			}
			
			if (haveLoadedAnyData == true) {
				saveDataPanel.setSaveData(JSON.stringify(_data, null));
			}
			
			return haveLoadedAnyData;
		}
		
		private function updateSaveData(_target : Object) : void {
			// formatVersion will be used later to be able to migrate old data, incase of changes to the save data format
			// Each time changes are made to the save data format, a new function will have to be added to a list of migrator functions
			// Where each function in the list will migrate the version by 1, and then pass on the migrated data to the next migrator function
			// Example, function[0]: v1 -> v2, function[1]: v2 -> v3, function[2]: v3 -> v4 and so on
			// This should ensure that save data can always be made up to date, no matter the version,
			// and that we don't have to write (and rewrite) one massive function just to handle any number of possible formats
			// There also should be some kind of validation, to ensure that we don't override valid data with invalid data
			
			_target.formatVersion = 1;
			_target.animationWidth = AnimationInfoState.width;
			_target.animationHeight =  AnimationInfoState.height;
			_target.scenes = [];
			_target.sceneScripts = [];
			
			var i : Number;
			var scenes : Array = ScenesState.scenes.value;
			for (i = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				_target.scenes.push(scene.toSaveData());
			}
			
			var sceneScripts : Array = SceneScriptsState.scripts.value;
			for (i = 0; i < sceneScripts.length; i++) {
				var sceneScript : SceneScript = sceneScripts[i];
				_target.sceneScripts.push(sceneScript.toSaveData());
			}
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