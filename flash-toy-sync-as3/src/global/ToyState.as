package global {
	
	import core.StateManager;
	import core.stateTypes.StringState;
	import core.stateTypes.StringStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ToyState {
		
		private static var stateManager : StateManager;
		
		public var _theHandyConnectionKey : StringState;
		public static var theHandyConnectionKey : StringStateReference;
		
		public var _status : StringState;
		public static var status : StringStateReference;
		
		public var _error : StringState;
		public static var error : StringStateReference;
		
		public function ToyState(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create a new instance, there can only be one instance");
			}
			
			stateManager = _stateManager;
			
			_theHandyConnectionKey = stateManager.addState(StringState, StringStateReference, "");
			theHandyConnectionKey = _theHandyConnectionKey.reference;
			
			_status = stateManager.addState(StringState, StringStateReference, "");
			status = _status.reference;
			
			_error = stateManager.addState(StringState, StringStateReference, "");
			error = _error.reference;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}