package states {
	
	import components.StateManager;
	import stateTypes.BooleanState;
	import stateTypes.BooleanStateReference;
	import stateTypes.NumberState;
	import stateTypes.NumberStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationSizeStates {
		
		private static var stateManager : StateManager;
		
		public var _width : NumberState;
		public static var width : NumberStateReference;
		
		public var _height : NumberState;
		public static var height : NumberStateReference;
		
		public var _isUsingInitialSize : BooleanState;
		public static var isUsingInitialSize : BooleanStateReference;
		
		public function AnimationSizeStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_width = _stateManager.addState(NumberState, 1280);
			width = _width.reference;
			
			_height = _stateManager.addState(NumberState, 720);
			height = _height.reference;
			
			_isUsingInitialSize = _stateManager.addState(BooleanState, false);
			isUsingInitialSize = _isUsingInitialSize.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}