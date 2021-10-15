package controllers {
	
	import core.ArrayUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	import core.MovieClipUtil;
	import core.DisplayObjectUtil;
	
	import global.GlobalState;
	import global.GlobalEvents;
	
	import components.ScriptingPanel;
	import components.StageElementSelector;
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
	public class ScriptingController {
		
		private var animation : MovieClip;
		
		private var globalState : GlobalState;
		
		private var scriptMarkers : Array = null;
		
		private var stimulationScriptMarker : ScriptMarker;
		private var baseScriptMarker : ScriptMarker;
		private var tipScriptMarker : ScriptMarker;
		
		private var isRecording : Boolean = false;
		private var recordingScene : Scene = null;
		private var nextFrameToRecord : Number = -1;
		
		private var currentSceneScript : SceneScript = null;
		
		public function ScriptingController(_globalState : GlobalState, _panelContainer : MovieClip, _animation : MovieClip, _overlayContainer : MovieClip) {
			animation = _animation;
			globalState = _globalState;
			
			var stageElementSelector : StageElementSelector = new StageElementSelector(_animation, _overlayContainer);
			stageElementSelector.onSelectChild.listen(this, onStageElementSelectorSelectChild);
			
			var stimulationMarkerElement : ScriptMarkerElement = new ScriptMarkerElement(_overlayContainer, 0xD99EC6, "STIM");
			var baseMarkerElement : ScriptMarkerElement = new ScriptMarkerElement(_overlayContainer, 0xA1D99E, "BASE");
			var tipMarkerElement : ScriptMarkerElement = new ScriptMarkerElement(_overlayContainer, 0x9ED0D9, "TIP");
			
			stimulationScriptMarker = new ScriptMarker(animation, stimulationMarkerElement, globalState._stimulationMarkerAttachedTo, globalState._stimulationMarkerPoint);
			baseScriptMarker = new ScriptMarker(animation, baseMarkerElement, globalState._baseMarkerAttachedTo, globalState._baseMarkerPoint);
			tipScriptMarker = new ScriptMarker(animation, tipMarkerElement, globalState._tipMarkerAttachedTo, globalState._tipMarkerPoint);
			
			scriptMarkers = [stimulationScriptMarker, baseScriptMarker, tipScriptMarker];
			
			var scriptingPanel : ScriptingPanel = new ScriptingPanel(_panelContainer);
			scriptingPanel.setPosition(700, 300);
			scriptingPanel.onAttachStimulationMarker.listen(this, onScriptingPanelAttachStimulationMarker);
			scriptingPanel.onAttachBaseMarker.listen(this, onScriptingPanelAttachBaseMarker);
			scriptingPanel.onAttachTipMarker.listen(this, onScriptingPanelAttachTipMarker);
			scriptingPanel.onMouseSelectFilterChange.listen(this, onScriptingPanelMouseSelectFilterChange);
			scriptingPanel.onStartRecording.listen(this, onScriptingPanelStartRecording);
			
			var scenesPanel : ScenesPanel = new ScenesPanel(_panelContainer);
			scenesPanel.setPosition(700, 700);
			scenesPanel.onSceneSelected.listen(this, onScenesPanelSceneSelected);
			
			GlobalState.listen(this, onCurrentSceneStateChange, [GlobalState.currentScene]);
			GlobalState.listen(this, onScenesStateChange, [GlobalState.scenes]);
		}
		
		public function onEnterFrame() : void {
			if (DisplayObjectUtil.isNested(animation, GlobalState.clickedChild.state) == false) {
				globalState._clickedChild.setState(null);
			}
			
			for (var i : Number = 0; i < scriptMarkers.length; i++) {
				var scriptMarker : ScriptMarker = scriptMarkers[i];
				scriptMarker.update();
			}
			
			if (isRecording == true) {
				updateRecording();
			}
			
			// TEMP: Only for debugging the depth of the current scripted scene
			if (isRecording == false && currentSceneScript != null && GlobalState.selectedChild.state != null) {
				var selectedChild : MovieClip = GlobalState.selectedChild.state;
				var startFrame : Number = currentSceneScript.getStartFrame();
				var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
				var depths : Array = currentSceneScript.getDepths();
				var depth : Number = depths[currentFrame - startFrame];
				trace(depth.toString().substring(0, 4));
			}
		}
		
		private function onCurrentSceneStateChange() : void {
			currentSceneScript = getSceneScriptForCurrentScene();
			
			globalState._stimulationMarkerAttachedTo.setState(null);
			globalState._baseMarkerAttachedTo.setState(null);
			globalState._tipMarkerAttachedTo.setState(null);
			globalState._stimulationMarkerPoint.setState(null);
			globalState._baseMarkerPoint.setState(null);
			globalState._tipMarkerPoint.setState(null);
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
		
		private function onScriptingPanelAttachStimulationMarker() : void {
			stimulationScriptMarker.attachTo(GlobalState.clickedChild.state || GlobalState.selectedChild.state);
		}
		
		private function onScriptingPanelAttachBaseMarker() : void {
			baseScriptMarker.attachTo(GlobalState.clickedChild.state || GlobalState.selectedChild.state);
		}
		
		private function onScriptingPanelAttachTipMarker() : void {
			tipScriptMarker.attachTo(GlobalState.clickedChild.state || GlobalState.selectedChild.state);
		}
		
		private function onScriptingPanelMouseSelectFilterChange(_filter : String) : void {
			globalState._mouseSelectFilter.setState(_filter);
		}
		
		private function onScriptingPanelStartRecording() : void {
			if (GlobalState.currentScene.state != null) {
				startRecording();
			}
		}
		
		private function onScenesPanelSceneSelected(_scene : Scene) : void {
			GlobalEvents.playFromSceneStart.emit(_scene);
		}
		
		private function onStageElementSelectorSelectChild(_child : DisplayObject) : void {
			globalState._clickedChild.setState(_child);
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
			
			var isOutOfRange : Boolean = currentSceneScript.isAtScene(animation) == false;
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