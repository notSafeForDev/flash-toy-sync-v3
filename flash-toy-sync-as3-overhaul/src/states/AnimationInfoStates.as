package states {
	
	import components.StateManager;
	import stateTypes.BooleanState;
	import stateTypes.BooleanStateReference;
	import stateTypes.TPMovieClipState;
	import stateTypes.TPMovieClipStateReference;
	import stateTypes.StringState;
	import stateTypes.StringStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationInfoStates {
		
		private static var stateManager : StateManager;
		
		public var _isStandalone : BooleanState;
		public static var isStandalone : BooleanStateReference;
		
		public var _animationRoot : TPMovieClipState;
		public static var animationRoot : TPMovieClipStateReference;
		
		public var _name : StringState;
		public static var name : StringStateReference;
		
		public var _isLoaded : BooleanState;
		public static var isLoaded : BooleanStateReference;
		
		public function AnimationInfoStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_isStandalone = _stateManager.addState(BooleanState, false);
			isStandalone = _isStandalone.reference;
			
			_animationRoot = _stateManager.addState(TPMovieClipState, null);
			animationRoot = _animationRoot.reference;
			
			_name = _stateManager.addState(StringState, "");
			name = _name.reference;
			
			_isLoaded = _stateManager.addState(BooleanState, false);
			isLoaded = _isLoaded.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}