package controllers {
	
	import core.TPMovieClip;
	import flash.geom.Point;
	import models.SceneModel;
	import models.SceneScriptModel;
	import stateTypes.BooleanState;
	import stateTypes.PointState;
	import states.AnimationInfoStates;
	import states.AnimationSceneStates;
	import states.EditorStates;
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

		private var isDraggingSampleMarkerState : BooleanState;
		
		private var type : String;
		private var marker : ScriptSampleMarker;
		
		public function ScriptSampleMarkerSubController(_type : String, _container : TPMovieClip, _isDraggingSampleMarkerState : BooleanState) {
			type = _type;
			
			isDraggingSampleMarkerState = _isDraggingSampleMarkerState;
			
			if (_type == MARKER_TYPE_BASE) {
				marker = new ScriptSampleMarker(_container, Colors.baseMarker, "B");
			} else if (_type == MARKER_TYPE_STIM) {
				marker = new ScriptSampleMarker(_container, Colors.stimMarker, "S");
			} else if (_type == MARKER_TYPE_TIP) {
				marker = new ScriptSampleMarker(_container, Colors.tipMarker, "T");
			}
			
			marker.hide();
			
			marker.startDragEvent.listen(this, onMarkerStartDrag);
			marker.stopDragEvent.listen(this, onMarkerStopDrag);
			
			AnimationInfoStates.listen(this, onAnimationLoadedStateChange, [AnimationInfoStates.isLoaded]);
		}
		
		public function update(_script : SceneScriptModel, _currentFrame : Number) : void {
			if (EditorStates.isEditor.value == false) {
				return;
			}
			
			marker.hide();
			
			if (_script == null || _script.isFrameWithinRecordedFrames(_currentFrame) == false) {
				return;
			}
			
			var positions : Vector.<Point>;
			
			if (type == MARKER_TYPE_BASE) {
				positions = _script.getBasePositions();
			} else if (type == MARKER_TYPE_STIM) {
				positions = _script.getStimPositions();
			} else if (type == MARKER_TYPE_TIP) {
				positions = _script.getTipPositions();
			}
			
			if (positions == null) {
				return;
			}
			
			var position : Point = _script.getInterpolatedPosition(positions, _currentFrame);
			if (position == null) {
				return;
			}
			
			marker.show();
			
			var isKeyPosition : Boolean = _script.hasRecordedPositionOnFrame(positions, _currentFrame);
			
			if (marker.isDragging() == false) {
				marker.setPosition(position.x, position.y);
			} else {
				if (type == MARKER_TYPE_BASE) {
					_script.setBasePosition(_currentFrame, marker.getPosition());
				} else if (type == MARKER_TYPE_STIM) {
					_script.setStimPosition(_currentFrame, marker.getPosition());
				} else if (type == MARKER_TYPE_TIP) {
					_script.setTipPosition(_currentFrame, marker.getPosition());
				}
			}
			
			if (isKeyPosition == true) {
				marker.displayAsKeyPosition();
			} else {
				marker.displayAsInterpolatedPosition();
			}
		}
		
		private function onAnimationLoadedStateChange() : void {
			if (AnimationInfoStates.isLoaded.value == false) {
				marker.hide();
			}
		}
		
		private function onMarkerStartDrag() : void {
			isDraggingSampleMarkerState.setValue(true);
		}
		
		private function onMarkerStopDrag() : void {
			isDraggingSampleMarkerState.setValue(false);
			
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