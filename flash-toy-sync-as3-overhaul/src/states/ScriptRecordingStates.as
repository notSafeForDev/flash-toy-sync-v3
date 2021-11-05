package states {
	
	import components.StateManager;
	import core.TPDisplayObject;
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
	public class ScriptRecordingStates {
		
		private static var stateManager : StateManager;
		
		public var _canRecord : BooleanState;
		public static var canRecord : BooleanStateReference;
		
		public function ScriptRecordingStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_canRecord = _stateManager.addState(BooleanState, false);
			canRecord = _canRecord.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}