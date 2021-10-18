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
		
		protected var globalState : GlobalState;
		
		protected var theHandyAPI : TheHandyAPI;
		
		protected var isScriptPrepared : Boolean = false;
		protected var isPlaying : Boolean = false;
		protected var loopCount : Number = 3;
		protected var currentLoopCount : Number = 0;
		protected var serverTimeDelta : Number = -1;
		
		public function TheHandyController(_globalState : GlobalState) {
			globalState = _globalState;
			
			theHandyAPI = new TheHandyAPI();
			theHandyAPI.connectionKey = GlobalState.theHandyConnectionKey.state;
			
			GlobalEvents.sceneLooped.listen(this, onSceneLooped);
			
			GlobalState.listen(this, onCurrentSceneStateChange, [GlobalState.currentScene]);
			GlobalState.listen(this, onConnectionKeyStateChange, [GlobalState.theHandyConnectionKey]);
		}
		
		private function onConnectionKeyStateChange(_key : String) : void {
			theHandyAPI.connectionKey = _key;
		}
		
		private function onSyncPrepareResponse(_response : Object) : void {
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
			currentLoopCount = 0;
			playScript();
		}
		
		private function onSceneLooped() : void {
			if (canPlay() == false) {
				currentLoopCount = 0;
				return;
			}
			
			currentLoopCount++;
			
			if (currentLoopCount >= loopCount) {
				currentLoopCount = 0;
				playScript();
				trace("Play on loop");
			}
		}
		
		protected function canPlay() : Boolean {
			return theHandyAPI.connectionKey != "" && isScriptPrepared == true;
		}
		
		protected function prepareScript(_csvUrl : String) : void {			
			theHandyAPI.syncPrepare(_csvUrl, this, onSyncPrepareResponse);
			globalState._toyStatus.setState("Preparing script...");
			globalState._toyError.setState("");
			isScriptPrepared = false;
			isPlaying = false;
		}
		
		protected function getSceneStartTime(_sceneScript : SceneScript) : Number {
			if (isScriptPrepared == false) {
				return -1;
			}
			
			return 0;
		}
		
		protected function playScript() : void {
			if (canPlay() == false) {
				return;
			}
			
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			var sceneScript : SceneScript = GlobalState.currentSceneScript.state;
			var startFrame : Number = sceneScript.getStartFrame();
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			var elapsedTime : Number = Math.floor((currentFrame - startFrame) * 1000 / StageUtil.getFrameRate());
			var time : Number = getSceneStartTime(sceneScript) + elapsedTime;
			var shouldAdjustOffset : Boolean = true;
			
			theHandyAPI.syncPlay(time, shouldAdjustOffset, this, onSyncPlayResponse);
		}
		
		protected function stopScript() : void {
			theHandyAPI.syncStop(this, onSyncStopResponse);
		}
	}
}