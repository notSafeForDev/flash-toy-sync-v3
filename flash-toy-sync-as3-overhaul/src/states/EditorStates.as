package states {
	
	import components.StateManager;
	import stateTypes.BooleanState;
	import stateTypes.BooleanStateReference;
	import stateTypes.StringState;
	import stateTypes.StringStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class EditorStates {
		
		private static var stateManager : StateManager;
		
		public var _isEditor : BooleanState;
		public static var isEditor : BooleanStateReference;
		
		public var _mouseSelectFilter : StringState;
		public static var mouseSelectFilter : StringStateReference;
		
		public function EditorStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_isEditor = _stateManager.addState(BooleanState, false);
			isEditor = _isEditor.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}