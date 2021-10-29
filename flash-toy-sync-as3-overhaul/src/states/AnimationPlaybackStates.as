package states {
	
	import components.StateManager;
	import stateTypes.ArrayState;
	import stateTypes.ArrayStateReference;
	import stateTypes.BooleanState;
	import stateTypes.BooleanStateReference;
	import stateTypes.SceneState;
	import stateTypes.SceneStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationPlaybackStates {
		
		private static var stateManager : StateManager;
		
		public var _isForceStopped : BooleanState;
		public static var isForceStopped : BooleanStateReference;
		
		public var _currentScene : SceneState;
		public static var currentScene : SceneStateReference;
		
		public var _scenes : ArrayState;
		public static var scenes : ArrayStateReference;
		
		public function AnimationPlaybackStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_isForceStopped = _stateManager.addState(BooleanState, false);
			isForceStopped = _isForceStopped.reference;
			
			_currentScene = _stateManager.addState(SceneState, null);
			currentScene = _currentScene.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}