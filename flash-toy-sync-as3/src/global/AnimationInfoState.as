package global {
	
	import core.StageUtil;
	import core.StateManager;
	import core.stateTypes.NumberState;
	import core.stateTypes.NumberStateReference;
	import core.stateTypes.StringState;
	import core.stateTypes.StringStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationInfoState {
		
		private static var stateManager : StateManager;
		
		// The actual states are only accessible on a single instance of TestState
		// They start with an underscore, as AS2 can't have more than one property with the same name, even if the accessor is different
		
		// The state references are available to all classes, where the state value is read only
		// This is to prevent other classes from interacting with the state in unintended ways
		
		public var _name : StringState;
		public static var name : StringStateReference;
		
		public var _width : NumberState;
		public static var width : NumberStateReference;
		
		public var _height : NumberState;
		public static var height : NumberStateReference;
		
		public function AnimationInfoState(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create a new instance, there can only be one instance");
			}
			
			// While this class could create it's own stateManager, 
			// it's designed this way to make it more clear that only the class that creates the stateManager, 
			// is intended to call the notifyListeners method on the stateManager
			stateManager = _stateManager;
			
			_name = _stateManager.addState(StringState, StringStateReference, "");
			name = _name.reference;
			
			_width = _stateManager.addState(NumberState, NumberStateReference, StageUtil.getWidth());
			width = _width.reference;
			
			_height = _stateManager.addState(NumberState, NumberStateReference, StageUtil.getHeight());
			height = _height.reference;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}