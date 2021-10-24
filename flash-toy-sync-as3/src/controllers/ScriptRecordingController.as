package controllers {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import global.SceneScriptsState;
	import global.ScenesState;
	import global.ScriptingState;

	import core.ArrayUtil;
	import core.MovieClipUtil;
	import core.DisplayObjectUtil;
	
	import global.GlobalEvents;
	
	import components.MarkerSceneScript;
	import components.SceneScript;
	import components.Scene;
	import components.ScriptMarker;
	
	import ui.ScriptingPanel;
	import ui.ScriptMarkerElement;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptRecordingController {
		
		private var animation : MovieClip;
		
		private var sceneScriptsState : SceneScriptsState;
		
		private var isRecording : Boolean = false;
		private var recordingScene : Scene = null;
		private var nextFrameToRecord : Number = -1;
		private var recordingStartSceneFrames : Array = null;
		
		private var currentSceneScript : SceneScript = null;
		
		private var scriptingPanel : ScriptingPanel;
		
		public function ScriptRecordingController(_sceneScriptsState : SceneScriptsState, _scriptingPanel : ScriptingPanel, _animation : MovieClip, _overlayContainer : MovieClip) {
			sceneScriptsState = _sceneScriptsState;
			scriptingPanel = _scriptingPanel;
			animation = _animation;
			
			scriptingPanel.onStartRecording.listen(this, onScriptingPanelStartRecording);
			scriptingPanel.onRecordFrame.listen(this, onScriptingPanelRecordFrame);
		}
		
		public function onEnterFrame() : void {
			if (isRecording == true) {
				updateRecording();
			}
		}
		
		private function onScriptingPanelStartRecording() : void {
			if (ScenesState.currentScene.value != null) {
				startRecording(false);
			}
		}
		
		private function onScriptingPanelRecordFrame() : void {
			if (ScenesState.currentScene.value != null) {
				startRecording(true);
				finishRecording();
			}
		}
		
		private function startRecording(_recordFromCurrentFrame : Boolean) : void {
			var existingSceneScript : SceneScript = getSceneScriptForCurrentScene();
			
			if (existingSceneScript != null) {
				trace("Start recording existing scene");
				currentSceneScript = existingSceneScript;
				sceneScriptsState._currentScript.setValue(currentSceneScript);
			} 
			else {
				trace("Start recording new scene");
				trace("First frames of current scene: " + ScenesState.currentScene.value.getFirstFrames());
				currentSceneScript = MarkerSceneScript.fromCurrentState(animation);
				var scripts : Array = SceneScriptsState.scripts.value.slice();
				scripts = scripts.concat(currentSceneScript);
				sceneScriptsState._scripts.setValue(scripts);
				sceneScriptsState._currentScript.setValue(currentSceneScript);
			}
			
			recordingScene = ScenesState.currentScene.value;
			isRecording = true;
			
			if (_recordFromCurrentFrame == true) {
				recordingStartSceneFrames = ScenesState.currentScene.value.getCurrentHierarchyFrames(ScenesState.selectedChild.value);
			} 
			else {
				recordingStartSceneFrames = ScenesState.currentScene.value.getFirstFrames();	
			}
			
			GlobalEvents.playFromSceneFrames.emit(recordingScene, recordingStartSceneFrames);
			
			var startFrame : Number = parseInt(scriptingPanel.startFrameInputText.getText());
			var endFrame : Number = parseInt(scriptingPanel.endFrameInputText.getText());
			
			if (startFrame > 0) {
				var sceneStartFrame : Number = currentSceneScript.scene.getFirstFrame();
				var sceneEndFrame : Number = currentSceneScript.scene.getLastFrame();
				var selectedChild : MovieClip = ScenesState.selectedChild.value;
				
				if (startFrame >= sceneStartFrame && startFrame <= sceneEndFrame) {
					selectedChild.gotoAndPlay(startFrame);
				}
			}
			
			trace("firstRecordingFrame: " + MovieClipUtil.getCurrentFrame(ScenesState.selectedChild.value));
			currentSceneScript.updateRecording(animation, -1);
			
			if (endFrame > 0 && endFrame == startFrame) {
				finishRecording();
				return;
			}
			
			nextFrameToRecord = MovieClipUtil.getCurrentFrame(ScenesState.selectedChild.value) + 1;
		}
		
		private function updateRecording() : void {
			var selectedChild : MovieClip = ScenesState.selectedChild.value;
			if (selectedChild == null) {
				trace("Lost selected child during recording");
				finishRecording();
				return;
			}
			
			// TODO: Add isRecording into state, and disable input on ui
			
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			
			var isOutOfRange : Boolean = currentSceneScript.isAtScene(selectedChild) == false;
			if (isOutOfRange == true) {
				trace("Got out of range of the scene during recording");
				finishRecording();
				return;
			}
			
			if (currentSceneScript.canRecord() == false) {
				var dependencies : Array = [
					ScriptingState.stimulationMarkerAttachedTo.value,
					ScriptingState.stimulationMarkerPoint.value,
					ScriptingState.baseMarkerAttachedTo.value,
					ScriptingState.baseMarkerPoint.value,
					ScriptingState.tipMarkerAttachedTo.value,
					ScriptingState.tipMarkerPoint.value
				];
				
				trace(dependencies);
				
				throw new Error("Unable to update recording, it's not possible to record");
			}
			
			var haveLoopedOrStopped : Boolean = currentFrame != nextFrameToRecord;
			if (haveLoopedOrStopped == true) {
				trace("Looped or stopped during recording");
				finishRecording();
				return;
			}
			
			trace("Recording... Frame: " + currentFrame);
			currentSceneScript.updateRecording(animation, -1);
			
			var endFrame : Number = parseInt(scriptingPanel.endFrameInputText.getText());
			if (endFrame > 0 && currentFrame >= endFrame) {
				trace("Finished recording based on the end frame in the scripting panel");
				finishRecording();
				return;
			}
			
			nextFrameToRecord = currentFrame + 1;
		}
		
		private function finishRecording() : void {
			trace("Finish recording");
			
			GlobalEvents.stopAtSceneFrames.emit(recordingScene, recordingStartSceneFrames);
			GlobalEvents.finishedRecordingScript.emit();
			
			isRecording = false;
			recordingScene = null;
			nextFrameToRecord = -1;
		}
		
		private function getSceneScriptForCurrentScene() : SceneScript {
			if (ScenesState.currentScene.value == null) {
				return null;
			}
			
			var sceneScripts : Array = SceneScriptsState.scripts.value;
			for (var i : Number = 0; i < sceneScripts.length; i++) {
				var existingSceneScript : SceneScript = sceneScripts[i];
				if (existingSceneScript.getScene() == ScenesState.currentScene.value) {
					return existingSceneScript;
				}
			}
			
			return null;
		}
	}
}