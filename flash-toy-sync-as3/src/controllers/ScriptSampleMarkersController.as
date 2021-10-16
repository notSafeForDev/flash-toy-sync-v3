package controllers {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import core.KeyboardManager;
	import core.MovieClipUtil;
	
	import global.GlobalState;
	
	import components.MarkerSceneScript;
	import components.Scene;
	import components.SceneScript;
	import components.ScriptSampleMarkerElement;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptSampleMarkersController {
		
		private var animation : MovieClip;
		
		private var stimulationMarker : ScriptSampleMarkerElement;
		private var baseMarker : ScriptSampleMarkerElement;
		private var tipMarker : ScriptSampleMarkerElement;
		
		private var markers : Array;
		private var selectedMarker : ScriptSampleMarkerElement;
		
		private var currentSceneScript : MarkerSceneScript;
		
		public function ScriptSampleMarkersController(_globalState : GlobalState, _animation : MovieClip, _overlayContainer : MovieClip) {
			animation = _animation;
			
			var markersOverlay : MovieClip = MovieClipUtil.create(_overlayContainer, "scriptSampleMarkersContainer");
			
			stimulationMarker = new ScriptSampleMarkerElement(_overlayContainer, 0xFF0000, "S");
			baseMarker = new ScriptSampleMarkerElement(_overlayContainer, 0xFF0000, "B");
			tipMarker = new ScriptSampleMarkerElement(_overlayContainer, 0xFF0000, "T");
			
			markers = [stimulationMarker, baseMarker, tipMarker];
			
			stimulationMarker.onMouseDown.listen(this, onMarkerMouseDown, stimulationMarker);
			baseMarker.onMouseDown.listen(this, onMarkerMouseDown, baseMarker);
			tipMarker.onMouseDown.listen(this, onMarkerMouseDown, tipMarker);
			
			stimulationMarker.onStopDrag.listen(this, onMarkerStopDrag, stimulationMarker);
			baseMarker.onStopDrag.listen(this, onMarkerStopDrag, baseMarker);
			tipMarker.onStopDrag.listen(this, onMarkerStopDrag, tipMarker);
			
			var keyboardManager : KeyboardManager = new KeyboardManager(_overlayContainer);
			
			keyboardManager.addShortcut(this, [Keyboard.BACKSPACE], onRemovePositionShortcut);
			
			GlobalState.listen(this, onSceneStatesChange, [GlobalState.currentScene, GlobalState.sceneScripts, GlobalState.scenes]);
		}
		
		public function onEnterFrame() : void {
			var frameIndex : Number = getFrameIndex();
			
			// TODO: Read from isRecording as well
			if (currentSceneScript == null || frameIndex < 0) {
				stimulationMarker.setVisible(false);
				baseMarker.setVisible(false);
				tipMarker.setVisible(false);
				return;
			}
			
			updateMarker(stimulationMarker, frameIndex);
			updateMarker(baseMarker, frameIndex);
			updateMarker(tipMarker, frameIndex);
		}
		
		private function updateMarker(_marker : ScriptSampleMarkerElement, _frameIndex : Number) : void {
			var positions : Array = getPositionsForMarker(_marker);
			
			_marker.setVisible(true);
			
			if (positions[_frameIndex] != null) {
				_marker.displayAsKeyframe();
			} else {
				_marker.displayAsInterpolated();
			}
			
			if (_marker.isDragging == false) {
				_marker.setPosition(currentSceneScript.getRecordedPosition(positions, _frameIndex));
			}
		}
		
		private function onSceneStatesChange() : void {
			if (selectedMarker != null) {
				selectedMarker.clearHighlight();
				selectedMarker = null;
			}
			
			var currentScene : Scene = GlobalState.currentScene.state;
			if (currentScene == null) {
				currentSceneScript = null;
				return;
			}
			
			var sceneScripts : Array = GlobalState.sceneScripts.state;
			for (var i : Number = 0; i < sceneScripts.length; i++) {
				var sceneScript : SceneScript = sceneScripts[i];
				if (sceneScript.scene == currentScene && sceneScript.getType() == MarkerSceneScript.sceneScriptType) {
					currentSceneScript = MarkerSceneScript.asMarkerSceneScript(sceneScript);
					return;
				}
			}
			
			currentSceneScript = null;
		}
		
		private function onMarkerMouseDown(_marker : ScriptSampleMarkerElement) : void {
			for (var i : Number = 0; i < markers.length; i++) {
				var marker : ScriptSampleMarkerElement = markers[i];
				marker.clearHighlight();
			}
			
			selectedMarker = _marker;
			_marker.highlight();
		}
		
		private function onMarkerStopDrag(_marker : ScriptSampleMarkerElement) : void {
			var positions : Array = getPositionsForMarker(_marker);
			var frameIndex : Number = getFrameIndex();
			
			positions.splice(frameIndex, 1, new Point(_marker.getX(), _marker.getY()));
			
			_marker.displayAsKeyframe();
		}
		
		private function onRemovePositionShortcut() : void {
			if (selectedMarker == null) {
				return;
			}
			
			var frameIndex : Number = getFrameIndex();
			var positions : Array = getPositionsForMarker(selectedMarker);
			
			positions.splice(frameIndex, 1, null);
			
			selectedMarker.displayAsInterpolated();
		}
		
		private function getPositionsForMarker(_marker : ScriptSampleMarkerElement) : Array {
			if (currentSceneScript == null) {
				return null;
			}
			if (_marker == stimulationMarker) {
				return currentSceneScript.stimulationPositions;
			}
			if (_marker == baseMarker) {
				return currentSceneScript.basePositions;
			}
			if (_marker == tipMarker) {
				return currentSceneScript.tipPositions;
			}
			return null;
		}
		
		private function getFrameIndex() : Number {
			if (currentSceneScript == null || GlobalState.selectedChild.state == null) {
				return -1;
			}
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(GlobalState.selectedChild.state);
			return currentFrame - currentSceneScript.getStartFrame();
		}
	}
}