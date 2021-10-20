package global {
	
	import core.StateManager;
	import core.stateTypes.BooleanState;
	import core.stateTypes.BooleanStateReference;
	import core.stateTypes.DisplayObjectState;
	import core.stateTypes.DisplayObjectStateReference;
	import core.stateTypes.PointState;
	import core.stateTypes.PointStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptingState {
		
		private static var stateManager : StateManager;
		
		public var _isRecording : BooleanState;
		public static var isRecording : BooleanStateReference;
		
		public var _isDraggingMarker : BooleanState;
		public static var isDraggingMarker : BooleanStateReference;
		
		public var _childUnderDraggedMarker : DisplayObjectState;
		public static var childUnderDraggedMarker : DisplayObjectStateReference;
		
		public var _stimulationMarkerAttachedTo : DisplayObjectState;
		public static var stimulationMarkerAttachedTo : DisplayObjectStateReference;
		
		public var _baseMarkerAttachedTo : DisplayObjectState;
		public static var baseMarkerAttachedTo : DisplayObjectStateReference;
		
		public var _tipMarkerAttachedTo : DisplayObjectState;
		public static var tipMarkerAttachedTo : DisplayObjectStateReference;
		
		public var _stimulationMarkerPoint : PointState;
		public static var stimulationMarkerPoint : PointStateReference;
		
		public var _baseMarkerPoint : PointState;
		public static var baseMarkerPoint : PointStateReference;
		
		public var _tipMarkerPoint : PointState;
		public static var tipMarkerPoint : PointStateReference;
		
		public function ScriptingState(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create a new instance, there can only be one instance");
			}
			
			stateManager = _stateManager;
			
			_isRecording = stateManager.addState(BooleanState, BooleanStateReference, false);
			isRecording = _isRecording.reference;
			
			_isDraggingMarker = stateManager.addState(BooleanState, BooleanStateReference, false);
			isDraggingMarker = _isDraggingMarker.reference;
			
			_childUnderDraggedMarker = stateManager.addState(DisplayObjectState, DisplayObjectStateReference, null);
			childUnderDraggedMarker = _childUnderDraggedMarker.reference;
			
			_stimulationMarkerAttachedTo = stateManager.addState(DisplayObjectState, DisplayObjectStateReference, null);
			stimulationMarkerAttachedTo = _stimulationMarkerAttachedTo.reference;
			
			_baseMarkerAttachedTo = stateManager.addState(DisplayObjectState, DisplayObjectStateReference, null);
			baseMarkerAttachedTo = _baseMarkerAttachedTo.reference;
			
			_tipMarkerAttachedTo = stateManager.addState(DisplayObjectState, DisplayObjectStateReference, null);
			tipMarkerAttachedTo = _tipMarkerAttachedTo.reference;
			
			_stimulationMarkerPoint = stateManager.addState(PointState, PointStateReference, null);
			stimulationMarkerPoint = _stimulationMarkerPoint.reference;
			
			_baseMarkerPoint = stateManager.addState(PointState, PointStateReference, null);
			baseMarkerPoint = _baseMarkerPoint.reference;
			
			_tipMarkerPoint = stateManager.addState(PointState, PointStateReference, null);
			tipMarkerPoint = _tipMarkerPoint.reference;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}