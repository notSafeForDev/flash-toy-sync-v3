package states {
	
	import components.StateManager;
	import stateTypes.ArrayState;
	import stateTypes.ArrayStateReference;
	import stateTypes.BooleanState;
	import stateTypes.BooleanStateReference;
	import stateTypes.NumberState;
	import stateTypes.NumberStateReference;
	import stateTypes.TPMovieClipState;
	import stateTypes.TPMovieClipStateReference;
	import stateTypes.SceneState;
	import stateTypes.SceneStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationSceneStates {
		
		private static var stateManager : StateManager;
		
		/** The inner child of the current scene */
		public var _activeChild : TPMovieClipState;
		/** The inner child of the current scene */
		public static var activeChild : TPMovieClipStateReference;
		
		/** If the inner child of the current scene have been stopped through the editor */
		public var _isForceStopped : BooleanState;
		/** If the inner child of the current scene have been stopped through the editor */
		public static var isForceStopped : BooleanStateReference;
		
		public var _currentScene : SceneState;
		public static var currentScene : SceneStateReference;
		
		public var _scenes : ArrayState;
		public static var scenes : ArrayStateReference;
		
		public var _selectedScenes : ArrayState;
		public static var selectedScenes : ArrayStateReference;
		
		public var _currentSceneLoopCount : NumberState;
		public static var currentSceneLoopCount : NumberStateReference;
		
		public function AnimationSceneStates(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create new instance, there can only be one instance");
			}
			
			_activeChild = _stateManager.addState(TPMovieClipState, null);
			activeChild = _activeChild.reference;
			
			_isForceStopped = _stateManager.addState(BooleanState, false);
			isForceStopped = _isForceStopped.reference;
			
			_currentScene = _stateManager.addState(SceneState, null);
			currentScene = _currentScene.reference;
			
			_scenes = _stateManager.addState(ArrayState, []);
			scenes = _scenes.reference;
			
			_selectedScenes = _stateManager.addState(ArrayState, []);
			selectedScenes = _selectedScenes.reference;
			
			_currentSceneLoopCount = _stateManager.addState(NumberState, -1);
			currentSceneLoopCount = _currentSceneLoopCount.reference;
			
			stateManager = _stateManager;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}