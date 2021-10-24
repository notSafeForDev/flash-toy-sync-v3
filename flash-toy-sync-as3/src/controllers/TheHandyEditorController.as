package controllers {
	
	import core.ArrayUtil;
	import core.StageUtil;
	import global.SceneScriptsState;
	
	import global.ToyState;
	import global.ScenesState;
	import global.GlobalEvents;
	
	import components.SceneScript;
	
	import utils.ScriptUtil;
	
	import ui.UIButton;
	import ui.ToyPanel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TheHandyEditorController extends TheHandyController {
		
		public function TheHandyEditorController(_toyState : ToyState, _prepareScriptButton : UIButton, _toyPanel : ToyPanel) {
			super(_toyState, _prepareScriptButton);
			
			_toyPanel.onConnectionKeyChange.listen(this, onToyPanelConnectionKeyChange);
			_toyPanel.onPrepareScript.listen(this, onToyPanelPrepareScript);
			
			GlobalEvents.finishedRecordingScript.listen(this, onFinishedRecordingScript);
			
			ScenesState.listen(this, onIsForceStoppedStateChange, [ScenesState.isForceStopped]);
		}
		
		private function onToyPanelConnectionKeyChange(_key : String) : void {
			toyState._theHandyConnectionKey.setValue(_key);
			theHandyAPI.setConnectionKey(_key);
		}
		
		protected override function onToyErrorStateChange() : void {
			// Do nothing
		}
		
		private function onToyPanelPrepareScript() : void {
			prepareScriptForCurrentScene();
		}
		
		private function onFinishedRecordingScript() : void {
			prepareScriptForCurrentScene();
		}
		
		private function onIsForceStoppedStateChange() : void {
			if (SceneScriptsState.currentScript.value == null) {
				return;
			}
			
			if (ScenesState.isForceStopped.value == false && isScriptPrepared == true) {
				currentLoopCount = 0;
				playScript();
				trace("Play on force stop change");
			}
			
			if (ScenesState.isForceStopped.value == true && isPlaying == true) {
				stopScript();
				trace("Stop on force stop change");
			}
		}
		
		protected override function onCurrentSceneStateChange() : void {
			currentSceneIndex = ArrayUtil.indexOf(SceneScriptsState.scripts.value, SceneScriptsState.currentScript.value);
			isScriptPrepared = false;
			currentLoopCount = 0;
			
			if (isPlaying == true) {
				stopScript();
			}
		}
		
		protected override function canPlay() : Boolean {
			return super.canPlay() == true && ScenesState.isForceStopped.value == false && sceneStartTimes[currentSceneIndex] >= 0;
		}
		
		private function prepareScriptForCurrentScene() : void {
			var sceneScript : SceneScript = SceneScriptsState.currentScript.value;
			if (sceneScript == null || theHandyAPI.getConnectionKey() == "") {
				return;
			}
			
			prepareScript([sceneScript]);
		}
	}
}