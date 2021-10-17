package controllers {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	import core.ArrayUtil;
	import core.MovieClipUtil;
	import core.DisplayObjectUtil;
	
	import global.GlobalState;
	import global.GlobalEvents;
	
	import components.ScriptingPanel;
	import components.MarkerSceneScript;
	import components.SceneScript;
	import components.Scene;
	import components.ScenesPanel;
	import components.ScriptMarker;
	import components.ScriptMarkerElement;

	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptRecordingController {
		
		private var animation : MovieClip;
		
		private var globalState : GlobalState;
		
		private var isRecording : Boolean = false;
		private var recordingScene : Scene = null;
		private var nextFrameToRecord : Number = -1;
		
		private var currentSceneScript : SceneScript = null;
		
		private var scriptingPanel : ScriptingPanel;
		
		public function ScriptRecordingController(_globalState : GlobalState, _scriptingPanel : ScriptingPanel, _scenesPanel : ScenesPanel, _animation : MovieClip, _overlayContainer : MovieClip) {
			animation = _animation;
			globalState = _globalState;
			scriptingPanel = _scriptingPanel;
			
			_scriptingPanel.onStartRecording.listen(this, onScriptingPanelStartRecording);
			
			_scenesPanel.onSceneSelected.listen(this, onScenesPanelSceneSelected);
			
			GlobalEvents.scenesMerged.listen(this, onScenesMerged);
			GlobalEvents.sceneChanged.listen(this, onSceneChanged);
		}
		
		public function onEnterFrame() : void {
			if (isRecording == true) {
				updateRecording();
			}
			
			// TEMP: Only for debugging the depth of the current scripted scene
			/* if (isRecording == false && currentSceneScript != null && GlobalState.selectedChild.state != null) {
				var selectedChild : MovieClip = GlobalState.selectedChild.state;
				var startFrame : Number = currentSceneScript.getStartFrame();
				var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
				var depths : Array = currentSceneScript.getDepths();
				var depth : Number = depths[currentFrame - startFrame];
				trace(depth.toString().substring(0, 4));
			} */
		}
		
		private function onSceneChanged() : void {
			currentSceneScript = getSceneScriptForCurrentScene();
			globalState._currentSceneScript.setState(currentSceneScript);
		}
		
		private function onScenesMerged(_previousScene : Scene, _combinedScene : Scene) : void {
			var sceneScripts : Array = GlobalState.sceneScripts.state;
			for (var i : Number = 0; i < sceneScripts.length; i++) {
				var sceneScript : SceneScript = sceneScripts[i];
				if (sceneScript.scene == _previousScene) {
					sceneScript.scene = _combinedScene;
				}
			}
		}
		
		private function onScriptingPanelStartRecording() : void {
			if (GlobalState.currentScene.state != null) {
				startRecording();
			}
		}
		
		private function onScenesPanelSceneSelected(_scene : Scene) : void {
			GlobalEvents.playFromSceneStart.emit(_scene);
		}
		
		private function startRecording() : void {
			var existingSceneScript : SceneScript = getSceneScriptForCurrentScene();
			
			if (existingSceneScript != null) {
				trace("Start recording existing scene");
				currentSceneScript = existingSceneScript;
				globalState._currentSceneScript.setState(currentSceneScript);
			} else {
				trace("Start recording new scene");
				trace("First frames of current scene: " + GlobalState.currentScene.state.getFirstFrames());
				currentSceneScript = MarkerSceneScript.fromGlobalState(animation);
				globalState._sceneScripts.push(currentSceneScript);
				globalState._currentSceneScript.setState(currentSceneScript);
			}
			
			recordingScene = GlobalState.currentScene.state;
			isRecording = true;
			
			GlobalEvents.playFromSceneStart.emit(recordingScene);
			
			var startFrame : Number = parseInt(scriptingPanel.startFrameInputText.getText());
			var endFrame : Number = parseInt(scriptingPanel.endFrameInputText.getText());
			
			if (startFrame > 0) {
				var sceneStartFrame : Number = currentSceneScript.scene.getFirstFrame();
				var sceneEndFrame : Number = currentSceneScript.scene.getLastFrame();
				var selectedChild : MovieClip = GlobalState.selectedChild.state;
				
				if (startFrame >= sceneStartFrame && startFrame <= sceneEndFrame) {
					selectedChild.gotoAndPlay(startFrame);
				}
			}
			
			trace("firstRecordingFrame: " + MovieClipUtil.getCurrentFrame(GlobalState.selectedChild.state));
			currentSceneScript.startRecording(animation, -1);
			
			if (endFrame > 0 && endFrame == startFrame) {
				finishRecording();
				return;
			}
			
			nextFrameToRecord = MovieClipUtil.getCurrentFrame(GlobalState.selectedChild.state) + 1;
		}
		
		private function updateRecording() : void {
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			if (selectedChild == null) {
				trace("Lost selected child during recording");
				finishRecording();
				return;
			}
			
			// TODO: Add isRecording into state, and disable input on ui
			
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			
			var isOutOfRange : Boolean = currentSceneScript.isAtScene(animation, selectedChild) == false;
			if (isOutOfRange == true) {
				trace("Got out of range of the scene during recording");
				finishRecording();
				return;
			}
			
			if (currentSceneScript.canRecord() == false) {
				var dependencies : Array = [
					GlobalState.stimulationMarkerAttachedTo.state,
					GlobalState.stimulationMarkerPoint.state,
					GlobalState.baseMarkerAttachedTo.state,
					GlobalState.baseMarkerPoint.state,
					GlobalState.tipMarkerAttachedTo.state,
					GlobalState.tipMarkerPoint.state
				];
				
				trace(dependencies);
				
				throw new Error("Unable to update recording, it's not possible to record");
			}
			
			trace("Recording... Frame: " + currentFrame);
			currentSceneScript.updateRecording(animation, -1);
			
			var endFrame : Number = parseInt(scriptingPanel.endFrameInputText.getText());
			if (endFrame > 0 && currentFrame >= endFrame) {
				trace("Finished recording based on the end frame in the scripting panel");
				finishRecording();
				return;
			}

			// It's important that this happens after updating the recording,
			// Especially if it have looped
			var haveLoopedOrStopped : Boolean = currentFrame != nextFrameToRecord;
			if (haveLoopedOrStopped == true) {
				trace("Looped or stopped during recording");
				finishRecording();
				return;
			}
			
			nextFrameToRecord = currentFrame + 1;
		}
		
		private function finishRecording() : void {
			trace("Finish recording");
			
			GlobalEvents.stopAtSceneStart.emit(recordingScene);
			GlobalEvents.finishedRecordingScript.emit();
			
			isRecording = false;
			recordingScene = null;
			nextFrameToRecord = -1;
		}
		
		private function getSceneScriptForCurrentScene() : SceneScript {
			if (GlobalState.currentScene.state == null) {
				return null;
			}
			
			var sceneScripts : Array = GlobalState.sceneScripts.state;
			for (var i : Number = 0; i < sceneScripts.length; i++) {
				var existingSceneScript : SceneScript = sceneScripts[i];
				if (existingSceneScript.getScene() == GlobalState.currentScene.state) {
					return existingSceneScript;
				}
			}
			
			return null;
		}
	}
}