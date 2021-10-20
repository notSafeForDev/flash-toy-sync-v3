package global {
	
	import core.StateManager;
	import core.stateTypes.ArrayState;
	import core.stateTypes.ArrayStateReference;
	import core.stateTypes.BooleanState;
	import core.stateTypes.BooleanStateReference;
	import core.stateTypes.DisplayObjectState;
	import core.stateTypes.DisplayObjectStateReference;
	import core.stateTypes.StringState;
	import core.stateTypes.StringStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class EditorState {
		
		private static var stateManager : StateManager;
		
		public var _isEditor : BooleanState;
		public static var isEditor : BooleanStateReference;
		
		public var _mouseSelectDisabledForChildren : ArrayState;
		public static var mouseSelectDisabledForChildren : ArrayStateReference;
		
		public var _mouseSelectFilter : StringState;
		public static var mouseSelectFilter : StringStateReference;
		
		public var _clickedChild : DisplayObjectState;
		public static var clickedChild : DisplayObjectStateReference;
		
		/** The child under the cursor, which is only active while it's in a state where it could be needed */
		public var _hoveredChild : DisplayObjectState;
		public static var hoveredChild : DisplayObjectStateReference;
		
		public function EditorState(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create a new instance, there can only be one instance");
			}
			
			stateManager = _stateManager;
			
			_isEditor = stateManager.addState(BooleanState, BooleanStateReference, false);
			isEditor = _isEditor.reference;
			
			_mouseSelectDisabledForChildren = stateManager.addState(ArrayState, ArrayStateReference, []);
			mouseSelectDisabledForChildren = _mouseSelectDisabledForChildren.reference;
			
			_mouseSelectFilter = stateManager.addState(StringState, StringStateReference, "");
			mouseSelectFilter = _mouseSelectFilter.reference;
			
			_clickedChild = stateManager.addState(DisplayObjectState, DisplayObjectStateReference, null);
			clickedChild = _clickedChild.reference;
			
			_hoveredChild = stateManager.addState(DisplayObjectState, DisplayObjectStateReference, null);
			hoveredChild = _hoveredChild.reference;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}