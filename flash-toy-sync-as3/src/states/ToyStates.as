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
		
		public static var THE_HANDY_CONNECTION_TYPE : String = "theHandy API";
		public static var INTIFACE_CONNECTION_TYPE : String = "Intiface Desktop";
		
		private static var stateManager : StateManager;
		
		public var _toyConnectionType : StringState;
		public static var toyConnectionType : StringStateReference;
		
		public var _theHandyConnectionKey : StringState;
		public static var theHandyConnectionKey : StringStateReference;
		
		public var _isPreparingScript : BooleanState;
		public static var isPreparingScript : BooleanStateReference;
		
		public var _isScriptPrepared : BooleanState;
		public static var isScriptPrepared : BooleanStateReference;
		
		public var _error : StringState;
		public static var error : StringStateReference;
		
		public function ToyStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_toyConnectionType = _stateManager.addState(StringState, THE_HANDY_CONNECTION_TYPE);
			toyConnectionType = _toyConnectionType.reference;
			
			_theHandyConnectionKey = _stateManager.addState(StringState, "");
			theHandyConnectionKey = _theHandyConnectionKey.reference;
			
			_isPreparingScript = _stateManager.addState(BooleanState, false);
			isPreparingScript = _isPreparingScript.reference;
			
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