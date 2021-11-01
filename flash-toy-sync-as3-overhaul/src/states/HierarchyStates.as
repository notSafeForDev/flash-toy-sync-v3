package states {
	
	import components.StateManager;
	import stateTypes.ArrayState;
	import stateTypes.ArrayStateReference;
	import stateTypes.TPMovieClipState;
	import stateTypes.TPMovieClipStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyStates {
		
		private static var stateManager : StateManager;
		
		public var _hierarchyPanelInfoList : ArrayState;
		public static var hierarchyPanelInfoList : ArrayStateReference;
		
		public function HierarchyStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_hierarchyPanelInfoList = _stateManager.addState(ArrayState, []);
			hierarchyPanelInfoList = _hierarchyPanelInfoList.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}