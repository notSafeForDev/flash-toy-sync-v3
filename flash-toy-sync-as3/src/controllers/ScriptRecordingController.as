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
		
		public function ScriptRecordingController(_globalState : GlobalState, _scriptingPanel : ScriptingPanel, _scenesPanel : ScenesPanel, _animation : MovieClip, _overlayContainer : MovieClip) {
			animation = _animation;
			globalState = _globalState;
			
			_scriptingPanel.onStartRecording.listen(this, onScriptingPanelStartRecording);
			
			_scenesPanel.setPosition(700, 700);
			_scenesPanel.onSceneSelected.listen(this, onScenesPanelSceneSelected);
			
			GlobalState.listen(this, onCurrentSceneStateChange, [GlobalState.currentScene]);
			GlobalState.listen(this, onScenesStateChange, [GlobalState.scenes]);
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
		
		private function onCurrentSceneStateChange() : void {
			currentSceneScript = getSceneScriptForCurrentScene();
		}
		
		private function onScenesStateChange() : void {
			var sceneScripts : Array = GlobalState.sceneScripts.state;
			var scenes : Array = GlobalState.scenes.state;
			for (var i : Number = 0; i < sceneScripts.length; i++) {
				var sceneScript : SceneScript = sceneScripts[i];
				if (ArrayUtil.indexOf(scenes, sceneScript.scene) < 0) {
					handleRemovedScene(sceneScript);
					currentSceneScript = getSceneScriptForCurrentScene();
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
			} else {
				trace("Start recording new scene");
				trace("First frames of current scene: " + GlobalState.currentScene.state.getFirstFrames());
				currentSceneScript = MarkerSceneScript.fromGlobalState(animation);
				trace("Push");
				globalState._sceneScripts.push(currentSceneScript);
			}
			
			recordingScene = GlobalState.currentScene.state;
			isRecording = true;
			
			GlobalEvents.playFromSceneStart.emit(recordingScene);
			trace("firstRecordingFrame: " + MovieClipUtil.getCurrentFrame(GlobalState.selectedChild.state))
			
			currentSceneScript.startRecording(animation, -1);
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
			
			currentSceneScript.updateRecording(animation, -1);
			
			// It's important that this happens after updating the recording,
			// Especially if it have looped
			var haveLoopedOrStopped : Boolean = currentFrame != nextFrameToRecord;
			if (haveLoopedOrStopped == true) {
				trace("Looped or stopped during recording");
				finishRecording();
				return;
			}
			
			trace("Recording... Frame: " + currentFrame);
			
			nextFrameToRecord = currentFrame + 1;
		}
		
		private function finishRecording() : void {
			trace("Finish recording");
			
			GlobalEvents.stopAtSceneStart.emit(recordingScene);
			
			isRecording = false;
			recordingScene = null;
			nextFrameToRecord = -1;
		}
		
		private function handleRemovedScene(_sceneScript : SceneScript) : void {
			var scenes : Array = GlobalState.scenes.state;
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				if (scene.intersects(_sceneScript.scene) == true) {
					_sceneScript.scene = scene;
					break;
				}
			}
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