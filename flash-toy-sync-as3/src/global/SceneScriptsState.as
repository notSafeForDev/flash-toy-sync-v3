package global {
	
	import core.StateManager;
	import core.stateTypes.ArrayState;
	import core.stateTypes.ArrayStateReference;
	
	import components.stateTypes.SceneScriptState;
	import components.stateTypes.SceneScriptStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptsState {
		
		private static var stateManager : StateManager;
		
		public var _scripts : ArrayState;
		public static var scripts : ArrayStateReference;
		
		public var _currentScript : SceneScriptState;
		public static var currentScript : SceneScriptStateReference;
		
		public function SceneScriptsState(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create a new instance, there can only be one instance");
			}
			
			stateManager = _stateManager;
			
			_scripts = stateManager.addState(ArrayState, ArrayStateReference, []);
			scripts = _scripts.reference;
			
			_currentScript = stateManager.addState(SceneScriptState, SceneScriptStateReference, null);
			currentScript = _currentScript.reference;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}