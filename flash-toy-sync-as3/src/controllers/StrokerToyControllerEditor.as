package controllers {
	
	import components.KeyboardInput;
	import components.KeyboardShortcut;
	import models.SceneModel;
	import models.SceneScriptModel;
	import states.AnimationSceneStates;
	import states.EditorStates;
	import states.ScriptRecordingStates;
	import states.ScriptTrackerStates;
	import states.ToyStates;
	import ui.Shortcuts;
	
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
			ScriptRecordingStates.listen(this, onIsDraggingSampleMarkerStateChange, [ScriptRecordingStates.isDraggingSampleMarker]);
			
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.prepareScript, this, onPrepareScriptShortcut, []);
		}
		
		private function onIsRecordingScriptStateChange() : void {
			if (ScriptRecordingStates.isRecording.value == true) {
				clearPreparedScript();
			}
		}
		
		private function onScriptRecordingDoneStateChange() : void {
			if (ScriptRecordingStates.isDoneRecording.value == false || toyApi.canConnect() == false || ToyStates.error.value != "") {
				return;
			}
			
			// When recording a scene which doesn't loop, it ends by changing scenes, which causes the prepared script to get cleared
			// So to make sure that the behaviour is consistent, automatically preparing the script is disabled
			// TODO: See if there's a good solution to this problem
			// prepareScriptForCurrentScene();	
		}
		
		private function onIsForceStoppedStateChange() : void {
			if (EditorStates.isEditor.value == false) {
				return;
			}
			
			var currentSceneIndex : Number = getCurrentSceneIndex();
			
			if (canPlayCurrentScene() == true && AnimationSceneStates.isForceStopped.value == false) {
				playCurrentScene();
			} else if (toyApi.isPlayingScript() == true) {
				stopCurrentScene();
			}
		}
		
		protected override function onCurrentSceneStateChange() : void {
			if (EditorStates.isEditor.value == false) {
				super.onCurrentSceneStateChange();
				return;
			}
			
			clearPreparedScript();
		}
		
		private function onIsDraggingTrackerMarkerStateChange() : void {
			if (ScriptTrackerStates.isDraggingTrackerMarker.value == true) {
				clearPreparedScript();
			}
		}
		
		private function onIsDraggingSampleMarkerStateChange() : void {
			if (ScriptRecordingStates.isDraggingSampleMarker.value == true) {
				clearPreparedScript();
			}
		}
		
		private function onPrepareScriptShortcut() : void {
			if (toyApi.canConnect() == false) {
				return;
			}
			
			prepareScriptForCurrentScene();
		}
		
		protected override function canPlayCurrentScene() : Boolean {
			return super.canPlayCurrentScene() && AnimationSceneStates.isForceStopped.value == false;
		}
		
		private function prepareScriptForCurrentScene() : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			var script : SceneScriptModel = currentScene.getPlugins().getScript();
			
			if (script.isComplete() == false) {
				return;
			}
			
			var scripts : Vector.<SceneScriptModel> = new Vector.<SceneScriptModel>();
			scripts.push(script);
			prepareScriptForScenes(scripts);
		}
	}
}