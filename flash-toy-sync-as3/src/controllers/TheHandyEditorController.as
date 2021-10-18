package controllers {
	
	import components.SceneScript;
	import core.StageUtil;
	import global.GlobalEvents;
	import global.GlobalState;
	import ui.ToyPanel;
	import utils.ScriptUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TheHandyEditorController extends TheHandyController {
		
		public function TheHandyEditorController(_globalState : GlobalState, _toyPanel : ToyPanel) {
			super(_globalState);
			
			_toyPanel.onConnectionKeyChange.listen(this, onToyPanelConnectionKeyChange);
			_toyPanel.onPrepareScript.listen(this, onToyPanelPrepareScript);
			
			GlobalEvents.finishedRecordingScript.listen(this, onFinishedRecordingScript);
			
			GlobalState.listen(this, onIsForceStoppedStateChange, [GlobalState.isForceStopped]);
		}
		
		private function onToyPanelConnectionKeyChange(_key : String) : void {
			globalState._theHandyConnectionKey.setState(_key);
			theHandyAPI.connectionKey = _key;
		}
		
		private function onToyPanelPrepareScript() : void {
			prepareScriptForCurrentScene();
		}
		
		private function onFinishedRecordingScript() : void {
			prepareScriptForCurrentScene();
		}
		
		private function onIsForceStoppedStateChange() : void {
			if (GlobalState.currentSceneScript.state == null) {
				return;
			}
			
			if (GlobalState.isForceStopped.state == false && isScriptPrepared == true) {
				currentLoopCount = 0;
				playScript();
				trace("Play on force stop change");
			}
			
			if (GlobalState.isForceStopped.state == true && isPlaying == true) {
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
			return super.canPlay() == true && GlobalState.isForceStopped.state == false;
		}
		
		private function prepareScriptForCurrentScene() : void {
			var sceneScript : SceneScript = GlobalState.currentSceneScript.state;
			if (sceneScript == null || theHandyAPI.connectionKey == "") {
				return;
			}
			
			var i : Number;
			var depths : Array = sceneScript.getDepths();
			var script : Array = ScriptUtil.depthsToScriptFormat(depths);
			script = ScriptUtil.reduceKeyframes(script);
			script = ScriptUtil.getLoopedScript(script, loopCount + 2);
			
			var csvUrl : String = "https://hump-feed.herokuapp.com/generateCSV/";
			for (i = 0; i < script.length; i++) {
				csvUrl += script[i].time + "," + script[i].position + ",";
			}
			
			// The url loader caches responses from urls, and sends those back on repeated requests, 
			// so we add to the url in order to make it seem like a different request
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