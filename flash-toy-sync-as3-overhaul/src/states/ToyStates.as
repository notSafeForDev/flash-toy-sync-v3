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
	public class ToyStates {
		
		private static var stateManager : StateManager;
		
		public var _theHandyConnectionKey : StringState;
		public static var theHandyConnectionKey : StringStateReference;
		
		public var _isScriptPrepared : BooleanState;
		public static var isScriptPrepared : BooleanStateReference;
		
		public var _error : StringState;
		public static var error : StringStateReference;
		
		public function ToyStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_theHandyConnectionKey = _stateManager.addState(StringState, "");
			theHandyConnectionKey = _theHandyConnectionKey.reference;
			
			_isScriptPrepared = _stateManager.addState(BooleanState, false);
			isScriptPrepared = _isScriptPrepared.reference;
			
			_error = _stateManager.addState(StringState, "");
			error = _error.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}