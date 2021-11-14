package states {
	
	import components.StateManager;
	import core.TPDisplayObject;
	import flash.geom.Point;
	import stateTypes.ArrayState;
	import stateTypes.ArrayStateReference;
	import stateTypes.BooleanState;
	import stateTypes.BooleanStateReference;
	import stateTypes.SceneState;
	import stateTypes.SceneStateReference;
	import stateTypes.TPDisplayObjectState;
	import stateTypes.TPDisplayObjectStateReference;
	import stateTypes.PointState;
	import stateTypes.PointStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptRecordingStates {
		
		private static var stateManager : StateManager;
		
		public var _isDraggingSampleMarker : BooleanState;
		public static var isDraggingSampleMarker : BooleanStateReference;
		
		public var _canRecord : BooleanState;
		public static var canRecord : BooleanStateReference;
		
		public var _isRecording : BooleanState;
		public static var isRecording : BooleanStateReference;
		
		public var _isDoneRecording : BooleanState;
		public static var isDoneRecording : BooleanStateReference;
		
		public var _recordingScene : SceneState;
		public static var recordingScene : SceneStateReference;
		
		public var _recordingStartFrames : ArrayState;
		public static var recordingStartFrames : ArrayStateReference;
		
		public var _interpolatedBasePoint : PointState;
		public static var interpolatedBasePoint : PointStateReference;
		
		public var _interpolatedStimPoint : PointState;
		public static var interpolatedStimPoint : PointStateReference;
		
		public var _interpolatedTipPoint : PointState;
		public static var interpolatedTipPoint : PointStateReference;
		
		public function ScriptRecordingStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_isDraggingSampleMarker = _stateManager.addState(BooleanState, false);
			isDraggingSampleMarker = _isDraggingSampleMarker.reference;
			
			_canRecord = _stateManager.addState(BooleanState, false);
			canRecord = _canRecord.reference;
			
			_isRecording = _stateManager.addState(BooleanState, false);
			isRecording = _isRecording.reference;
			
			_isDoneRecording = _stateManager.addState(BooleanState, false);
			isDoneRecording = _isDoneRecording.reference;
			
			_recordingScene = _stateManager.addState(SceneState, null);
			recordingScene = _recordingScene.reference;
			
			_recordingStartFrames = _stateManager.addState(ArrayState, null);
			recordingStartFrames = _recordingStartFrames.reference;
			
			_interpolatedBasePoint = _stateManager.addState(PointState, null);
			interpolatedBasePoint = _interpolatedBasePoint.reference;
			
			_interpolatedStimPoint = _stateManager.addState(PointState, null);
			interpolatedStimPoint = _interpolatedStimPoint.reference;
			
			_interpolatedTipPoint = _stateManager.addState(PointState, null);
			interpolatedTipPoint = _interpolatedTipPoint.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}