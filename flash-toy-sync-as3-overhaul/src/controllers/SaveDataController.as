package controllers {
	
	import components.KeyboardInput;
	import core.JSONLoader;
	import core.TPMovieClip;
	import flash.net.SharedObject;
	import flash.system.System;
	import models.SceneModel;
	import states.AnimationInfoStates;
	import states.AnimationSceneStates;
	import states.AnimationSizeStates;
	import states.EditorStates;
	import states.SaveDataStates;
	import states.ToyStates;
	import ui.Shortcuts;
	import utils.ArrayUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SaveDataController {
		
		private var saveDataStates : SaveDataStates;
		private var animationSizeStates : AnimationSizeStates;
		private var animationSceneStates : AnimationSceneStates;
		
		private var animationSharedObject : SharedObject;
		private var settingsSharedData : SharedObject;
		
		public function SaveDataController(_saveDataStates : SaveDataStates, _animationSizeStates : AnimationSizeStates, _animationSceneStates : AnimationSceneStates, _toyStates : ToyStates) {
			saveDataStates = _saveDataStates;
			animationSizeStates = _animationSizeStates;
			animationSceneStates = _animationSceneStates;
			
			var isActionScript3 : Boolean = VersionConfig.actionScriptVersion == 3;
			
			// Different setting save files are used for both versions as the AS3 version can't read data that have been modified by the AS2 version
			settingsSharedData = SharedObject.getLocal("flash-toy-sync-settings-" + (isActionScript3 ? "as3" : "as2"), "/");
			_toyStates._theHandyConnectionKey.setValue(settingsSharedData.data.theHandyConnectionKey || "");
			
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.save, this, onSaveShortcut, []);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.copyJSONSaveData, this, onCopyJSONSaveDataShortcut, []);
			
			AnimationInfoStates.isLoaded.listen(this, onAnimationLoadedStateChange);
			ToyStates.listen(this, onTheHandyConnectionKeyStateChange, [ToyStates.theHandyConnectionKey]);
		}
		
		private function onAnimationLoadedStateChange() : void {
			if (AnimationInfoStates.isLoaded.value == false) {
				animationSharedObject = null;
				return;
			}
			
			animationSharedObject = getAnimationSharedObject();
			
			var isLoaded : Boolean = load(animationSharedObject.data);
			if (isLoaded == true) {
				return;
			}
			
			var animationName : String = AnimationInfoStates.name.value;
			
			var saveDataPath : String;
			if (AnimationInfoStates.isStandalone.value == true) {
				saveDataPath = animationName.split(".swf")[0] + ".json";
			} else {
				saveDataPath = "animations/" + animationName.split(".swf")[0] + ".json";
			}
			
			JSONLoader.load(saveDataPath, this, onJSONLoaded);
		}
		
		private function onTheHandyConnectionKeyStateChange() : void {
			// We don't call settingsSharedData.flush here as that would slow down the application while the user is typing the key
			settingsSharedData.data.theHandyConnectionKey = ToyStates.theHandyConnectionKey.value;
		}
		
		private function onJSONLoaded(_json : Object) : void {
			if (_json.error == undefined) {
				load(_json);
			}
		}
		
		private function onSaveShortcut() : void {
			if (AnimationInfoStates.isLoaded.value == true) {
				save();
			}
		}
		
		private function onCopyJSONSaveDataShortcut() : void {
			var saveData : Object = {};
			updateSaveDataFromState(saveData);
			var jsonString : String = JSON.stringify(saveData);
			
			System.setClipboard(jsonString);
			saveDataStates._copiedJSON.setValue(jsonString);
		}
		
		private function getAnimationSharedObject() : SharedObject {
			// Taken from the documentation: https://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/SharedObject.html#getLocal()
			var invalidCharacters : Array = [" ", "~", "%", "&", "\\", ";", ":", '"', "'", ",", "<", ">", "?", "#"];
			
			var animation : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var animationName : String = AnimationInfoStates.name.value.split(".")[0];
			var isActionScript3 : Boolean = VersionConfig.actionScriptVersion == 3;
			
			var sharedObjectName : String = animationName.split(".swf")[0];
			
			for (var i : Number = 0; i < invalidCharacters.length; i++) {
				sharedObjectName = sharedObjectName.split(invalidCharacters[i]).join("-");
			}
			
			sharedObjectName += (isActionScript3 ? "-as3" : "-as2");
			return SharedObject.getLocal(sharedObjectName, "/");
		}
		
		private function save() : void {
			if (animationSharedObject == null) {
				animationSharedObject = getAnimationSharedObject();
			}
			
			// data is read only, so we can't assign it directly
			updateSaveDataFromState(animationSharedObject.data);
			
			var saveDataList : Array = SaveDataStates.saveDataList.value;
			saveDataList.push(animationSharedObject.data);
			saveDataStates._saveDataList.setValue(saveDataList);
			
			animationSharedObject.flush();
		}
		
		private function load(_saveData : Object) : Boolean {
			var dependencies : Array = [_saveData.formatVersion, _saveData.animationWidth, _saveData.animationHeight, _saveData.scenes];
			if (ArrayUtil.includes(dependencies, undefined) == true) {
				return false;
			}
			
			var scenes : Array = [];
			for (var i : Number = 0; i < _saveData.scenes.length; i++) {
				scenes.push(SceneModel.fromSaveData(_saveData.scenes[i]));
			}
			
			animationSizeStates._width.setValue(_saveData.animationWidth);
			animationSizeStates._height.setValue(_saveData.animationHeight);
			animationSceneStates._scenes.setValue(scenes);
			
			return true;
		}
		
		private function updateSaveDataFromState(_target : Object) : void {
			// formatVersion will be used later to be able to migrate old data, incase of changes to the save data format
			// Each time changes are made to the save data format, a new function will have to be added to a list of migrator functions
			// Where each function in the list will migrate the version by 1, and then pass on the migrated data to the next migrator function
			// Example, function[0]: v1 -> v2, function[1]: v2 -> v3, function[2]: v3 -> v4 and so on
			// This should ensure that save data can always be made up to date, no matter the version,
			// and that we don't have to write (and rewrite) one massive function just to handle any number of possible formats
			// There should also be some kind of validation, to ensure that we don't override valid data with invalid data
			
			_target.formatVersion = 1;
			_target.animationWidth = AnimationSizeStates.width.value;
			_target.animationHeight = AnimationSizeStates.height.value;
			_target.scenes = [];
			
			var i : Number;
			var scenes : Array = AnimationSceneStates.scenes.value;
			for (i = 0; i < scenes.length; i++) {
				var scene : SceneModel = scenes[i];
				_target.scenes.push(scene.toSaveData());
			}
		}
	}
}