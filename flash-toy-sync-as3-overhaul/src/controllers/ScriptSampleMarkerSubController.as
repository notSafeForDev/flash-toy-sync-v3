package controllers {
	
	import core.TPMovieClip;
	import flash.geom.Point;
	import models.SceneModel;
	import models.SceneScriptModel;
	import states.AnimationSceneStates;
	import ui.Colors;
	import ui.ScriptSampleMarker;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptSampleMarkerSubController {
		
		public static var MARKER_TYPE_BASE : String = "MARKER_TYPE_BASE";
		public static var MARKER_TYPE_STIM : String = "MARKER_TYPE_STIM";
		public static var MARKER_TYPE_TIP : String = "MARKER_TYPE_TIP";
		
		private var type : String;
		private var marker : ScriptSampleMarker;
		
		public function ScriptSampleMarkerSubController(_type : String, _container : TPMovieClip) {
			type = _type;
			
			if (_type == MARKER_TYPE_BASE) {
				marker = new ScriptSampleMarker(_container, Colors.baseMarker, "B");
			} else if (_type == MARKER_TYPE_STIM) {
				marker = new ScriptSampleMarker(_container, Colors.stimMarker, "S");
			} else if (_type == MARKER_TYPE_TIP) {
				marker = new ScriptSampleMarker(_container, Colors.tipMarker, "T");
			}
			
			marker.hide();
			
			marker.stopDragEvent.listen(this, onMarkerStopDrag);
		}
		
		public function update(_script : SceneScriptModel, _currentFrame : Number) : void {
			if (_script == null || _script.isFrameWithinRecordedFrames(_currentFrame) == false) {
				marker.hide();
				return;
			}
			
			marker.show();
			
			var positions : Vector.<Point>;
			
			if (type == MARKER_TYPE_BASE) {
				positions = _script.getBasePositions();
			} else if (type == MARKER_TYPE_STIM) {
				positions = _script.getStimPositions();
			} else if (type == MARKER_TYPE_TIP) {
				positions = _script.getTipPositions();
			}
			
			var isKeyPosition : Boolean = _script.hasRecordedPositionOnFrame(positions, _currentFrame);
			var position : Point = _script.getInterpolatedPosition(positions, _currentFrame);
			
			if (marker.isDragging() == false) {
				marker.setPosition(position.x, position.y);
			}
			
			if (isKeyPosition == true) {
				marker.displayAsKeyPosition();
			} else {
				marker.displayAsInterpolatedPosition();
			}
		}
		
		private function onMarkerStopDrag() : void {
			if (marker.isVisible() == false) {
				return;
			}
			
			var activeChild : TPMovieClip = AnimationSceneStates.activeChild.value;
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			var currentFrame : Number = activeChild != null ? activeChild.currentFrame : -1;
			var script : SceneScriptModel = currentScene != null ? currentScene.getPlugins().getScript() : null;
			var position : Point = marker.getPosition();
			
			if (type == MARKER_TYPE_BASE) {
				script.setBasePosition(currentFrame, position);
			} else if (type == MARKER_TYPE_STIM) {
				script.setStimPosition(currentFrame, position);
			} else if (type == MARKER_TYPE_TIP) {
				script.setTipPosition(currentFrame, position);
			}
		}
	}
}