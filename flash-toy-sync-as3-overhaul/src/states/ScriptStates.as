package states {
	
	import components.StateManager;
	import flash.geom.Point;
	import stateTypes.BooleanState;
	import stateTypes.BooleanStateReference;
	import stateTypes.TPDisplayObjectState;
	import stateTypes.TPDisplayObjectStateReference;
	import stateTypes.PointState;
	import stateTypes.PointStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptStates {
		
		private static var stateManager : StateManager;
		
		public var _baseTrackerPoint : PointState;
		public static var baseTrackerPoint : PointStateReference;
		
		public var _tipTrackerPoint : PointState;
		public static var tipTrackerPoint : PointStateReference;
		
		public var _stimTrackerPoint : PointState;
		public static var stimTrackerPoint : PointStateReference;
		
		public var _baseTrackerAttachedTo : TPDisplayObjectState;
		public static var baseTrackerAttachedTo : TPDisplayObjectStateReference;
		
		public var _tipTrackerAttachedTo : TPDisplayObjectState;
		public static var tipTrackerAttachedTo : TPDisplayObjectStateReference;
		
		public var _stimTrackerAttachedTo : TPDisplayObjectState;
		public static var stimTrackerAttachedTo : TPDisplayObjectStateReference;
		
		public var _isDraggingTrackerMarker : BooleanState;
		public static var isDraggingTrackerMarker : BooleanStateReference;
		
		public var _childUnderDraggedMarker : TPDisplayObjectState;
		public static var childUnderDraggedMarker : TPDisplayObjectStateReference;
		
		public function ScriptStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_baseTrackerPoint = _stateManager.addState(PointState, null);
			baseTrackerPoint = _baseTrackerPoint.reference;
			
			_tipTrackerPoint = _stateManager.addState(PointState, null);
			tipTrackerPoint = _tipTrackerPoint.reference;
			
			_stimTrackerPoint = _stateManager.addState(PointState, null);
			stimTrackerPoint = _stimTrackerPoint.reference;
			
			_baseTrackerAttachedTo = _stateManager.addState(TPDisplayObjectState, null);
			baseTrackerAttachedTo = _baseTrackerAttachedTo.reference;
			
			_tipTrackerAttachedTo = _stateManager.addState(TPDisplayObjectState, null);
			tipTrackerAttachedTo = _tipTrackerAttachedTo.reference;
			
			_stimTrackerAttachedTo = _stateManager.addState(TPDisplayObjectState, null);
			stimTrackerAttachedTo = _stimTrackerAttachedTo.reference;
			
			_isDraggingTrackerMarker = _stateManager.addState(BooleanState, false);
			isDraggingTrackerMarker = _isDraggingTrackerMarker.reference;
			
			_childUnderDraggedMarker = _stateManager.addState(TPDisplayObjectState, null);
			childUnderDraggedMarker = _childUnderDraggedMarker.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}