package states {
	
	import components.StateManager;
	import stateTypes.TPMovieClipState;
	import stateTypes.TPMovieClipStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyStates {
		
		private static var stateManager : StateManager;
		
		public var _selectedChild : TPMovieClipState;
		public static var selectedChild : TPMovieClipStateReference;
		
		public function HierarchyStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_selectedChild = _stateManager.addState(TPMovieClipState, null);
			selectedChild = _selectedChild.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}