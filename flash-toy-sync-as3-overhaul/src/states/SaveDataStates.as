package states {
	
	import components.StateManager;
	import stateTypes.ArrayState;
	import stateTypes.ArrayStateReference;
	import stateTypes.BooleanState;
	import stateTypes.BooleanStateReference;
	import stateTypes.StringState;
	import stateTypes.StringStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SaveDataStates {
		
		private static var stateManager : StateManager;
		
		public var _saveDataList : ArrayState;
		public static var saveDataList : ArrayStateReference;
		
		public var _copiedJSON : StringState;
		public static var copiedJSON : StringStateReference;
		
		public function SaveDataStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_saveDataList = _stateManager.addState(ArrayState, []);
			saveDataList = _saveDataList.reference;
			
			_copiedJSON = _stateManager.addState(StringState, "");
			copiedJSON = _copiedJSON.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}