package states {
	
	import components.StateManager;
	import stateTypes.ArrayState;
	import stateTypes.ArrayStateReference;
	import stateTypes.TPDisplayObjectState;
	import stateTypes.TPDisplayObjectStateReference;
	import stateTypes.TPMovieClipState;
	import stateTypes.TPMovieClipStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyStates {
		
		private static var stateManager : StateManager;
		
		/** The selected child the hierarchy panel */
		public var _selectedChild : TPDisplayObjectState;
		/** The selected child the hierarchy panel */
		public static var selectedChild : TPDisplayObjectStateReference;
		
		/** Information about each child in the hierarchy panel */
		public var _hierarchyPanelInfoList : ArrayState;
		/** Information about each child in the hierarchy panel */
		public static var hierarchyPanelInfoList : ArrayStateReference;
		
		/** Children that can't be selected on the stage */
		public var _lockedChildren : ArrayState;
		/** Children that can't be selected on the stage */
		public static var lockedChildren : ArrayStateReference;
		
		public function HierarchyStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_selectedChild = _stateManager.addState(TPDisplayObjectState, null);
			selectedChild = _selectedChild.reference;
			
			_hierarchyPanelInfoList = _stateManager.addState(ArrayState, []);
			hierarchyPanelInfoList = _hierarchyPanelInfoList.reference;
			
			_lockedChildren = _stateManager.addState(ArrayState, []);
			lockedChildren = _lockedChildren.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}