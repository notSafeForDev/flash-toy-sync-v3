package controllers {
	
	import api.TheHandyAPI;
	import components.Scene;
	import components.SceneScript;
	import core.DisplayObjectUtil;
	import ui.UIButton;
	import ui.ToyPanel;
	import core.ArrayUtil;
	import core.MovieClipUtil;
	import core.StageUtil;
	import flash.display.MovieClip;
	import global.GlobalEvents;
	import global.GlobalState;
	import utils.ScriptUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TheHandyController {
		
		protected var globalState : GlobalState;
		
		protected var theHandyAPI : TheHandyAPI;
		
		protected var isScriptPrepared : Boolean = false;
		protected var isPlaying : Boolean = false;
		protected var currentLoopCount : Number = 0;
		protected var serverTimeDelta : Number = -1;
		protected var sceneStartTimes : Array = null;
		protected var sceneLoopCounts : Array = null;
		
		protected var currentSceneIndex : Number = -1;
		
		private var prepareScriptButton : UIButton;
		
		public function TheHandyController(_globalState : GlobalState, _prepareScriptButton : UIButton) {
			globalState = _globalState;
			prepareScriptButton = _prepareScriptButton;
			prepareScriptButton.onMouseClick.listen(this, onPrepareScriptButtonClick);
			
			theHandyAPI = new TheHandyAPI();
			theHandyAPI.connectionKey = GlobalState.theHandyConnectionKey.state;
			
			GlobalEvents.sceneLooped.listen(this, onSceneLooped);
			
			GlobalState.listen(this, onCurrentSceneStateChange, [GlobalState.currentScene]);
			GlobalState.listen(this, onConnectionKeyStateChange, [GlobalState.theHandyConnectionKey]);
			GlobalState.listen(this, onToyErrorStateChange, [GlobalState.toyError]);
			
			if (GlobalState.isEditor.state == false) {
				prepareScriptForAllScenes();
			}
		}
		
		private function onPrepareScriptButtonClick() : void {
			prepareScriptForAllScenes();
		}
		
		private function onConnectionKeyStateChange(_key : String) : void {
			theHandyAPI.connectionKey = _key;
		}
		
		protected function onToyErrorStateChange() : void {
			DisplayObjectUtil.setVisible(prepareScriptButton.element, GlobalState.toyError.state != "");
		}
		
		private function onSyncPrepareResponse(_response : Object) : void {
			// trace(JSON.stringify(_response));
			
			if (_response.error != undefined) {
				globalState._toyStatus.setState("");
				globalState._toyError.setState(_response.error);
				isScriptPrepared = false;
			} else {
				globalState._toyStatus.setState("Script prepared");
				globalState._toyError.setState("");
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
				globalState._toyStatus.setState("");
				globalState._toyError.setState(_response.error);
			} else {
				globalState._toyStatus.setState("Playing");
				globalState._toyError.setState("");
				isPlaying = true;
				if (serverTimeDelta < 0) {
					serverTimeDelta = _response.serverTimeDelta;
				}
			}
		}
		
		protected function onSyncStopResponse(_response : Object) : void {
			isPlaying = false;
			
			if (_response.error != undefined) {
				globalState._toyStatus.setState("");
				globalState._toyError.setState(_response.error);
			} else {
				globalState._toyStatus.setState("Stopped");
				globalState._toyError.setState("");
			}
		}
		
		protected function onCurrentSceneStateChange() : void {
			currentSceneIndex = ArrayUtil.indexOf(GlobalState.sceneScripts.state, GlobalState.currentSceneScript.state);
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
			return theHandyAPI.connectionKey != "" && isScriptPrepared == true && currentSceneIndex >= 0 && GlobalState.toyError.state == "";
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
		
		protected function prepareScript(_csvUrl : String) : void {			
			theHandyAPI.syncPrepare(_csvUrl, this, onSyncPrepareResponse);
			globalState._toyStatus.setState("Preparing script...");
			globalState._toyError.setState("");
			isScriptPrepared = false;
			isPlaying = false;
		}
		
		private function prepareScriptForAllScenes() : void {
			var sceneScripts : Array = GlobalState.sceneScripts.state;
			var startTime : Number = 0;
			var combinedScript : Array = [];
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
			
			// TEMP: We should upload a file to a server instead
			var csvUrl : String = "https://hump-feed.herokuapp.com/generateCSV/";
			for (i = 0; i < combinedScript.length; i++) {
				csvUrl += combinedScript[i].time + "," + combinedScript[i].position + ",";
			}
			
			// The url loader caches responses from urls, and sends those back on repeated requests, 
			// so we alter the url in order to make it seem like a different request
			var date : Date = new Date();
			csvUrl += date.getTime() + ",0";
			
			prepareScript(csvUrl);
		}
		
		protected function playScript() : void {
			if (canPlay() == false) {
				return;
			}
			
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			var sceneScript : SceneScript = GlobalState.currentSceneScript.state;
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