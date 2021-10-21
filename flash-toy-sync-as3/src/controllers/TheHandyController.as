package controllers {
	
	import api.TheHandyAPI;
	import components.Scene;
	import components.SceneScript;
	import core.DisplayObjectUtil;
	import core.HTTPRequest;
	import global.EditorState;
	import global.SceneScriptsState;
	import global.ScenesState;
	import global.ToyState;
	import ui.UIButton;
	import ui.ToyPanel;
	import core.ArrayUtil;
	import core.MovieClipUtil;
	import core.StageUtil;
	import flash.display.MovieClip;
	import global.GlobalEvents;
	import utils.ScriptUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TheHandyController {
		
		protected var toyState : ToyState;
		
		protected var theHandyAPI : TheHandyAPI;
		
		protected var isScriptPrepared : Boolean = false;
		protected var isPlaying : Boolean = false;
		protected var currentLoopCount : Number = 0;
		protected var serverTimeDelta : Number = -1;
		protected var sceneStartTimes : Array = null;
		protected var sceneLoopCounts : Array = null;
		
		protected var currentSceneIndex : Number = -1;
		
		private var prepareScriptButton : UIButton;
		
		public function TheHandyController(_toyState : ToyState, _prepareScriptButton : UIButton) {
			toyState = _toyState;
			prepareScriptButton = _prepareScriptButton;
			prepareScriptButton.onMouseClick.listen(this, onPrepareScriptButtonClick);
			
			theHandyAPI = new TheHandyAPI();
			theHandyAPI.connectionKey = ToyState.theHandyConnectionKey.value;
			
			GlobalEvents.sceneLooped.listen(this, onSceneLooped);
			
			ScenesState.listen(this, onCurrentSceneStateChange, [ScenesState.currentScene]);
			ToyState.listen(this, onConnectionKeyStateChange, [ToyState.theHandyConnectionKey]);
			ToyState.listen(this, onToyErrorStateChange, [ToyState.error]);
			
			if (EditorState.isEditor.value == false) {
				prepareScriptForAllScenes();
			}
		}
		
		private function onPrepareScriptButtonClick() : void {
			prepareScriptForAllScenes();
		}
		
		private function onConnectionKeyStateChange() : void {
			theHandyAPI.connectionKey = ToyState.theHandyConnectionKey.value;
		}
		
		protected function onToyErrorStateChange() : void {
			DisplayObjectUtil.setVisible(prepareScriptButton.element, ToyState.error.value != "");
		}
		
		private function onSyncPrepareResponse(_response : *) : void {
			isScriptPrepared = false;
			
			if (typeof _response == "string") {
				toyState._status.setValue("");
				toyState._error.setValue("Unable to download the script");
			} else if (_response.downloaded == false) {
				toyState._status.setValue("");
				toyState._error.setValue("Unable to download the script");
			} else if (_response.success == false) {
				toyState._status.setValue("");
				toyState._error.setValue(_response.error);
			} else {
				toyState._status.setValue("Script prepared");
				toyState._error.setValue("");
				isScriptPrepared = true;
			}
			
			if (canPlay() == true) {
				currentLoopCount = 0;
				playScript();
				trace("Play on sync prepare");
			}
		}
		private function onSyncPlayResponse(_response : Object) : void {
			if (_response.error != undefined) {
				toyState._status.setValue("");
				toyState._error.setValue(_response.error);
			} else {
				toyState._status.setValue("Playing");
				toyState._error.setValue("");
				isPlaying = true;
				if (serverTimeDelta < 0) {
					serverTimeDelta = _response.serverTimeDelta;
				}
			}
		}
		
		protected function onSyncStopResponse(_response : Object) : void {
			isPlaying = false;
			
			if (_response.error != undefined) {
				toyState._status.setValue("");
				toyState._error.setValue(_response.error);
			} else {
				toyState._status.setValue("Stopped");
				toyState._error.setValue("");
			}
		}
		
		protected function onCurrentSceneStateChange() : void {
			currentSceneIndex = ArrayUtil.indexOf(SceneScriptsState.scripts.value, SceneScriptsState.currentScript.value);
			currentLoopCount = 0;
			
			if (currentSceneIndex >= 0) {
				playScript();
			} else if (isPlaying == true) {
				stopScript();
			}
		}
		
		private function onSceneLooped() : void {
			if (canPlay() == false) {
				currentLoopCount = 0;
				return;
			}
			
			currentLoopCount++;
			
			if (currentLoopCount >= sceneLoopCounts[currentSceneIndex]) {
				currentLoopCount = 0;
				playScript();
				trace("Play on loop");
			}
		}
		
		protected function canPlay() : Boolean {
			return theHandyAPI.connectionKey != "" && isScriptPrepared == true && currentSceneIndex >= 0 && ToyState.error.value == "";
		}
		
		protected function getMinLoopCountForScene(_sceneScript : SceneScript) : Number {
			var depths : Array = _sceneScript.getDepths();
			var duration : Number = Math.floor(depths.length * 1000 / StageUtil.getFrameRate());
			return Math.ceil(3000 / duration);
		}
		
		protected function generateScriptDataForScene(_sceneScript : SceneScript, _loopCount : Number, _startTime : Number) : Array {
			var script : Array = ScriptUtil.depthsToScriptFormat(_sceneScript.getDepths(), _startTime);
			script = ScriptUtil.reduceKeyframes(script);
			script = ScriptUtil.getLoopedScript(script, _loopCount);
			
			return script;
		}
		
		protected function prepareScript(_csv : String) : void {			
			toyState._status.setValue("Preparing script...");
			toyState._error.setValue("");
			isScriptPrepared = false;
			isPlaying = false;
			
			theHandyAPI.syncPrepareFromCSV(_csv, this, onSyncPrepareResponse);
		}
		
		private function prepareScriptForAllScenes() : void {
			var sceneScripts : Array = SceneScriptsState.scripts.value;
			if (sceneScripts.length == 0) {
				return;
			}
			
			// We add an extra position at the start, to make the first loop in the script loop smoothly
			var startTime : Number = 1000;
			var combinedScript : Array = [{time: 0, position: 0}];
			var i : Number;
			
			sceneStartTimes = [];
			sceneLoopCounts = [];
			
			for (i = 0; i < sceneScripts.length; i++) {
				var sceneScript : SceneScript = sceneScripts[i];
				var loopCount : Number = getMinLoopCountForScene(sceneScript);
				var script : Array = generateScriptDataForScene(sceneScript, loopCount, startTime);
				
				sceneStartTimes.push(startTime);
				sceneLoopCounts.push(loopCount);
				startTime = script[script.length - 1].time + 1000;
				combinedScript = combinedScript.concat(script);
			}
			
			var csv : String = "\n";
			for (i = 0; i < combinedScript.length; i++) {
				csv += combinedScript[i].time + "," + combinedScript[i].position + "\n";
			}
			
			prepareScript(csv);
		}
		
		protected function playScript() : void {
			if (canPlay() == false) {
				return;
			}
			
			var selectedChild : MovieClip = ScenesState.selectedChild.value;
			var sceneScript : SceneScript = SceneScriptsState.currentScript.value;
			var startFrame : Number = sceneScript.getStartFrame();
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			
			var startTime : Number = sceneStartTimes[currentSceneIndex];
			var elapsedTime : Number = ScriptUtil.getMilisecondsAtFrame(currentFrame - startFrame);
			var time : Number = startTime + elapsedTime;
			
			var shouldAdjustOffset : Boolean = true;
			
			theHandyAPI.syncPlay(time, shouldAdjustOffset, this, onSyncPlayResponse);
		}
		
		protected function stopScript() : void {
			theHandyAPI.syncStop(this, onSyncStopResponse);
		}
	}
}