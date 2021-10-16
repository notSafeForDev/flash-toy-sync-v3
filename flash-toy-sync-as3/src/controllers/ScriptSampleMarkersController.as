package controllers {

	import flash.display.MovieClip;

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
		
		private var currentSceneScript : MarkerSceneScript;
		
		public function ScriptSampleMarkersController(_globalState : GlobalState, _animation : MovieClip, _overlayContainer : MovieClip) {
			animation = _animation;
			
			var markersOverlay : MovieClip = MovieClipUtil.create(_overlayContainer, "scriptSampleMarkersContainer");
			
			stimulationMarker = new ScriptSampleMarkerElement(_overlayContainer, 0xFF0000, "S");
			baseMarker = new ScriptSampleMarkerElement(_overlayContainer, 0xFF0000, "B");
			tipMarker = new ScriptSampleMarkerElement(_overlayContainer, 0xFF0000, "T");
			
			GlobalState.listen(this, onSceneStatesChange, [GlobalState.currentScene, GlobalState.sceneScripts, GlobalState.scenes]);
		}
		
		public function onEnterFrame() : void {
			// TODO: Read from isRecording as well
			if (currentSceneScript == null) {
				stimulationMarker.setVisible(false);
				baseMarker.setVisible(false);
				tipMarker.setVisible(false);
				return;
			}
			
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(GlobalState.selectedChild.state);
			var frameIndex : Number = currentFrame - currentSceneScript.getStartFrame();
			
			if (frameIndex < 0 || frameIndex >= currentSceneScript.stimulationPositions.length) {
				stimulationMarker.setVisible(false);
				baseMarker.setVisible(false);
				tipMarker.setVisible(false);
				return;
			}
			
			stimulationMarker.setVisible(true);
			baseMarker.setVisible(true);
			tipMarker.setVisible(true);
			
			stimulationMarker.setPosition(currentSceneScript.stimulationPositions[frameIndex]);
			baseMarker.setPosition(currentSceneScript.basePositions[frameIndex]);
			tipMarker.setPosition(currentSceneScript.tipPositions[frameIndex]);
		}
		
		private function onSceneStatesChange() : void {
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
	}
}