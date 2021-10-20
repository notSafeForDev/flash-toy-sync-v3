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
			theHandyAPI.connectionKey = _key;
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
			if (sceneScript == null || theHandyAPI.connectionKey == "") {
				return;
			}
			
			var i : Number;
			var loopCount : Number = getMinLoopCountForScene(sceneScript);
			var sceneScripts : Array = SceneScriptsState.scripts.value;
			
			currentSceneIndex = ArrayUtil.indexOf(sceneScripts, sceneScript);
			sceneStartTimes = [];
			sceneLoopCounts = [];
			
			for (i = 0; i < sceneScripts.length; i++) {
				if (i == currentSceneIndex) {
					sceneStartTimes.push(0);
					sceneLoopCounts.push(loopCount);
				} else {
					sceneStartTimes.push(-1);
					sceneLoopCounts.push(-1);
				}
			}
			
			var scriptData : Array = generateScriptDataForScene(sceneScript, loopCount, 0);
			
			var csvUrl : String = "https://hump-feed.herokuapp.com/generateCSV/";
			for (i = 0; i < scriptData.length; i++) {
				csvUrl += scriptData[i].time + "," + scriptData[i].position + ",";
			}
			
			// The url loader caches responses from urls, and sends those back on repeated requests, 
			// so we alter the url in order to make it seem like a different request
			var date : Date = new Date();
			csvUrl += date.getTime() + ",0";
			
			prepareScript(csvUrl);
		}
		
		private function generateCompactCSVData(_indexAndDepths : Array) : Array {
			var data : Array = [];
			var previousTime : Number = 0;
			var frameRate : Number = StageUtil.getFrameRate();
			
			// The index of each character, multiplied by 2, represents the depth, 0 -> 100
			var depthCharacters : String = "-aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVxXyYzZ";
			
			for (var i : Number = 0; i < _indexAndDepths.length; i++) {
				var index : Number = _indexAndDepths[i].i;
				var depth : Number = _indexAndDepths[i].depth;
				var depthInt : Number = 100 - Math.floor(depth * 100);
				
				var time : Number = Math.floor(index * 1000 / frameRate);
				var duration : Number = time - previousTime;
				var depthCharacter : String = depthCharacters.charAt(Math.floor(depthInt / 2));
				
				data.push(duration.toString(36));
				data.push(depthCharacter);
				
				previousTime = time;
			}
			
			return data;
		}
	}
}