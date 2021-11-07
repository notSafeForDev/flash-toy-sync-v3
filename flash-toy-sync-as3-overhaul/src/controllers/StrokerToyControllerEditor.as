package controllers {
	
	import models.SceneModel;
	import models.SceneScriptModel;
	import states.AnimationSceneStates;
	import states.ScriptRecordingStates;
	import states.ScriptTrackerStates;
	import states.ToyStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StrokerToyControllerEditor extends StrokerToyController {
		
		public function StrokerToyControllerEditor(_toyStates : ToyStates) {
			super(_toyStates);
			
			ScriptRecordingStates.listen(this, onIsRecordingScriptStateChange, [ScriptRecordingStates.isRecording]);
			ScriptRecordingStates.listen(this, onScriptRecordingDoneStateChange, [ScriptRecordingStates.isDoneRecording]);
			AnimationSceneStates.listen(this, onIsForceStoppedStateChange, [AnimationSceneStates.isForceStopped]);
			ScriptTrackerStates.listen(this, onIsDraggingTrackerMarkerStateChange, [ScriptTrackerStates.isDraggingTrackerMarker]);
		}
		
		private function onIsRecordingScriptStateChange() : void {
			if (ScriptRecordingStates.isRecording.value == true) {
				clearPreparedScript();
			}
		}
		
		private function onScriptRecordingDoneStateChange() : void {
			if (ScriptRecordingStates.isDoneRecording.value == false || toyApi.canConnect() == false) {
				return;
			}
			
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			var script : SceneScriptModel = currentScene.getPlugins().getScript();
			
			if (script.isComplete() == false) {
				return;
			}
		
			var scripts : Vector.<SceneScriptModel> = new Vector.<SceneScriptModel>();
			scripts.push(script);
			prepareScriptForScenes(scripts);
		}
		
		private function onIsForceStoppedStateChange() : void {
			var currentSceneIndex : Number = getCurrentSceneIndex();
			
			if (canPlayCurrentScene() == true && AnimationSceneStates.isForceStopped.value == false) {
				playCurrentScene();
			} else if (toyApi.isPlayingScript() == true) {
				stopCurrentScene();
			}
		}
		
		protected override function onCurrentSceneStateChange() : void {
			clearPreparedScript();
		}
		
		private function onIsDraggingTrackerMarkerStateChange() : void {
			if (ScriptTrackerStates.isDraggingTrackerMarker.value == true) {
				clearPreparedScript();
			}
		}
	}
}