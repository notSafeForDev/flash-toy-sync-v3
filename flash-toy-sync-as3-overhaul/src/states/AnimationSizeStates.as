package states {
	
	import components.StateManager;
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
		
		public function AnimationSizeStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_width = _stateManager.addState(NumberState, 1280);
			width = _width.reference;
			
			_height = _stateManager.addState(NumberState, 720);
			height = _height.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}