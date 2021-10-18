package controllers {
	
	import api.TheHandyAPI;
	import components.Scene;
	import components.SceneScript;
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
		
		private var globalState : GlobalState;
		
		private var theHandyAPI : TheHandyAPI;
		
		private var isScriptPrepared : Boolean = false;
		private var isPlaying : Boolean = false;
		private var loopCount : Number = 3;
		private var currentLoopCount : Number = 0;
		private var serverTimeDelta : Number = -1;
		
		public function TheHandyController(_globalState : GlobalState, _toyPanel : ToyPanel) {
			globalState = _globalState;
			
			theHandyAPI = new TheHandyAPI();
			theHandyAPI.connectionKey = GlobalState.theHandyConnectionKey.state;
			
			_toyPanel.onConnectionKeyChange.listen(this, onToyPanelConnectionKeyChange);
			_toyPanel.onPrepareScript.listen(this, onToyPanelPrepareScript);
			
			GlobalEvents.finishedRecordingScript.listen(this, onFinishedRecordingScript);
			GlobalEvents.sceneLooped.listen(this, onSceneLooped);
			
			GlobalState.listen(this, onIsForceStoppedStateChanged, [GlobalState.isForceStopped]);
			GlobalState.listen(this, onCurrentSceneScriptChanged, [GlobalState.currentSceneScript]);
		}
		
		private function onToyPanelConnectionKeyChange(_key : String) : void {
			globalState._theHandyConnectionKey.setState(_key);
			theHandyAPI.connectionKey = _key;
		}
		
		private function onToyPanelPrepareScript() : void {
			prepareScript();
		}
		
		private function onFinishedRecordingScript() : void {
			prepareScript();
		}
		
		private function onTheHandySyncPrepare(_response : Object) : void {
			trace(JSON.stringify(_response));
			
			if (_response.error != undefined) {
				globalState._toyStatus.setState("");
				globalState._toyError.setState(_response.error);
				isScriptPrepared = false;
			} else {
				globalState._toyStatus.setState("Script prepared");
				globalState._toyError.setState("");
				isScriptPrepared = true;
			}
			
			if (isScriptPrepared == true && GlobalState.isForceStopped.state == false) {
				currentLoopCount = 0;
				playScript();
				trace("Play on sync prepare");
			}
		}
		
		private function onIsForceStoppedStateChanged() : void {
			if (GlobalState.currentSceneScript.state == null) {
				return;
			}
			
			if (GlobalState.isForceStopped.state == false && isScriptPrepared == true) {
				currentLoopCount = 0;
				playScript();
				trace("Play on force stop change");
			}
			
			if (GlobalState.isForceStopped.state == true && isPlaying == true) {
				theHandyAPI.syncStop(this, onTheHandySyncStop);
				trace("Stop on force stop change");
			}
		}
		
		private function onTheHandySyncPlay(_response : Object) : void {
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
		
		private function onTheHandySyncStop(_response : Object) : void {
			isPlaying = false;
			
			if (_response.error != undefined) {
				globalState._toyStatus.setState("");
				globalState._toyError.setState(_response.error);
			} else {
				globalState._toyStatus.setState("Stopped");
				globalState._toyError.setState("");
			}
		}
		
		private function onCurrentSceneScriptChanged() : void {
			isScriptPrepared = false;
			if (isPlaying == true) {
				theHandyAPI.syncStop(this, onTheHandySyncStop);
			}
			
			if (isScriptPrepared == false || GlobalState.currentSceneScript.state == null) {
				return;
			}
			
			currentLoopCount = 0;
			playScript();
		}
		
		private function onSceneLooped() : void {
			if (isScriptPrepared == false || GlobalState.currentSceneScript.state == null) {
				return;
			}
			
			currentLoopCount++;
			
			if (currentLoopCount >= loopCount) {
				currentLoopCount = 0;
				playScript();
				trace("Play on loop");
			}
		}
		
		private function prepareScript() : void {
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
			
			theHandyAPI.syncPrepare(csvUrl, this, onTheHandySyncPrepare);
			globalState._toyStatus.setState("Preparing script...");
			globalState._toyError.setState("");
			isScriptPrepared = false;
			isPlaying = false;
		}
		
		private function playScript() : void {
			if (theHandyAPI.connectionKey == "") {
				return;
			}
			
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			var sceneScript : SceneScript = GlobalState.currentSceneScript.state;
			var startFrame : Number = sceneScript.getStartFrame();
			var totalFrames : Number = sceneScript.getDepths().length;
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			var time : Number = Math.floor((currentFrame + totalFrames - startFrame) * 1000 / StageUtil.getFrameRate());
			var duration : Number = totalFrames * 1000 / StageUtil.getFrameRate();
			var shouldAdjustOffset : Boolean = true;
			
			theHandyAPI.syncPlay(time, shouldAdjustOffset, this, onTheHandySyncPlay);
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