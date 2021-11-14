package controllers {
	
	import api.StrokerToyApi;
	import api.StrokerToyResponse;
	import api.StrokerToyScriptPosition;
	import api.TheHandyApi;
	import core.TPMovieClip;
	import core.TPStage;
	import models.SceneModel;
	import models.SceneScriptModel;
	import states.AnimationInfoStates;
	import states.AnimationSceneStates;
	import states.EditorStates;
	import states.ToyStates;
	import utils.ArrayUtil;
	import utils.StrokerToyUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StrokerToyController {
		
		protected static var ID_THE_HANDY : String = "ID_THE_HANDY";
		
		protected var toyApi : StrokerToyApi;
		
		private var toyStates : ToyStates
		
		private var toyID : String;
		
		private var sceneLoopCounts : Vector.<Number>;
		private var sceneStartTimes : Vector.<Number>;
		
		private var currentSceneLoopCount : Number = -1;
		
		public function StrokerToyController(_toyStates : ToyStates) {
			toyStates = _toyStates;
			
			toyID = ID_THE_HANDY;
			
			if (toyID == ID_THE_HANDY) {
				toyApi = new TheHandyApi();
			}
			
			AnimationSceneStates.listen(this, onCurrentSceneStateChange, [AnimationSceneStates.currentScene]);
			AnimationSceneStates.listen(this, onSceneLoopCountStateChange, [AnimationSceneStates.currentSceneLoopCount]);
			AnimationInfoStates.listen(this, onAnimationLoadedStateChange, [AnimationInfoStates.isLoaded]);
		}
		
		private function onAnimationLoadedStateChange() : void {
			if (AnimationInfoStates.isLoaded.value == false || EditorStates.isEditor.value == true) {
				return;
			}
			
			if (toyApi.canConnect() == false) {
				return;
			}
			
			var scenes : Array = AnimationSceneStates.scenes.value;
			var scripts : Vector.<SceneScriptModel> = new Vector.<SceneScriptModel>();
			
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : SceneModel = scenes[i];
				var script : SceneScriptModel = scene.getPlugins().getScript();
				if (script.isComplete() == true) {
					scripts.push(script);
				}
			}
			
			prepareScriptForScenes(scripts);
		}
		
		protected function prepareScriptForScenes(_scripts : Vector.<SceneScriptModel>) : void {
			toyStates._isScriptPrepared.setValue(false);
			toyStates._isPreparingScript.setValue(true);
			toyStates._error.setValue("");
			
			var scenes : Array = AnimationSceneStates.scenes.value;
			var combinedPositions : Vector.<StrokerToyScriptPosition> = new Vector.<StrokerToyScriptPosition>();
			var startTime : Number = 0;
			var minSceneDuration : Number = 3000;
			var scenePadding : Number = 1000;
			
			sceneLoopCounts = new Vector.<Number>();
			sceneStartTimes = new Vector.<Number>();
			
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : SceneModel = scenes[i];
				var script : SceneScriptModel = scene.getPlugins().getScript();
				
				if (ArrayUtil.includes(_scripts, script) == false) {
					sceneLoopCounts.push(-1);
					sceneStartTimes.push(-1);
					continue;
				}
				
				var loopDuration : Number = StrokerToyUtil.getMilisecondsAtFrame(scene.getTotalInnerFrames());
				var loopCount : Number = Math.ceil(minSceneDuration / loopDuration);
				var depths : Vector.<Number> = script.calculateDepths();
				var positions : Vector.<StrokerToyScriptPosition> = StrokerToyUtil.depthsToPositions(depths, startTime);
				var timeStretch : Number = loopDuration < 5000 ? 1.03 : 1;
				
				positions = StrokerToyUtil.reducePositions(positions);
				positions = StrokerToyUtil.getRepeatedPositions(positions, loopCount);
				positions = StrokerToyUtil.timeStretchPositions(positions, timeStretch); // To account for a slight bit of lag when it loops
				
				var frameDuration : Number = StrokerToyUtil.getMilisecondsAtFrame(1);
				var lastPosition : StrokerToyScriptPosition = positions[positions.length - 1];
				var duration : Number = lastPosition.time - startTime;
				
				sceneLoopCounts.push(loopCount);
				sceneStartTimes.push(startTime);
				
				combinedPositions = combinedPositions.concat(positions);
				startTime += duration + scenePadding;
			}
			
			toyApi.prepareScript(combinedPositions, this, onPrepareScriptResponse);
		}
		
		protected function clearPreparedScript() : void {
			toyStates._isScriptPrepared.setValue(false);
			toyStates._isPreparingScript.setValue(false);
			
			toyApi.clearPreparedScript();
			sceneLoopCounts = null;
			sceneStartTimes = null;
			currentSceneLoopCount = -1;
		}
		
		protected function getCurrentSceneIndex() : Number {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			var scenes : Array = AnimationSceneStates.scenes.value;
			var sceneIndex : Number = ArrayUtil.indexOf(scenes, currentScene);
			
			return sceneIndex;
		}
		
		protected function canPlayCurrentScene() : Boolean {
			var sceneIndex : Number = getCurrentSceneIndex();
			return sceneStartTimes != null && sceneIndex >= 0 && sceneIndex < sceneStartTimes.length && sceneStartTimes[sceneIndex] >= 0;
		}
		
		protected function playCurrentScene() : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			var activeChild : TPMovieClip = AnimationSceneStates.activeChild.value;
			var currentFrame : Number = activeChild.currentFrame;
			var currentSceneIndex : Number = getCurrentSceneIndex();
			var startTime : Number = sceneStartTimes[currentSceneIndex];
			var elapsedTime : Number = StrokerToyUtil.getMilisecondsAtFrame(currentFrame - currentScene.getInnerStartFrame());
			
			toyApi.playScript(startTime + elapsedTime, this, onPlayScriptResponse);
		}
		
		protected function stopCurrentScene() : void {
			toyApi.stopScript(this, onStopScriptResponse);
		}
		
		private function onPrepareScriptResponse(_response : StrokerToyResponse) : void {
			toyStates._isScriptPrepared.setValue(_response.success);
			toyStates._isPreparingScript.setValue(false);
			toyStates._error.setValue(_response.error);
			
			if (_response.success && canPlayCurrentScene()) {
				playCurrentScene();
			}
		}
		
		private function onPlayScriptResponse(_response : StrokerToyResponse) : void {
			currentSceneLoopCount = 0;
			
			if (_response.error != "") {
				clearPreparedScript();
				toyStates._error.setValue(_response.error);
			}
		}
		
		private function onStopScriptResponse(_response : StrokerToyResponse) : void {
			if (_response.error != "") {
				clearPreparedScript();
				toyStates._error.setValue(_response.error);
			}
		}
		
		protected function onCurrentSceneStateChange() : void {
			if (toyApi.isScriptPrepared() == false || EditorStates.isEditor.value == true) {
				return;
			}
			
			var currentSceneIndex : Number = getCurrentSceneIndex();
			if (canPlayCurrentScene() == true) {
				playCurrentScene();
			} else if (toyApi.isPlayingScript() == true) {
				stopCurrentScene();
			}
		}
		
		private function onSceneLoopCountStateChange() : void {
			if (AnimationSceneStates.currentSceneLoopCount.value <= 0 || toyApi.isScriptPrepared() == false) {
				return;
			}
			
			var currentSceneIndex : Number = getCurrentSceneIndex();
			var targetLoopCount : Number = sceneLoopCounts[currentSceneIndex];
			
			currentSceneLoopCount++;
			if (currentSceneLoopCount == targetLoopCount) {
				playCurrentScene();
				currentSceneLoopCount = 0;
			}
		}
	}
}