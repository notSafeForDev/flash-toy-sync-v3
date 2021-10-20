package global {
	
	import core.StateManager;
	import core.stateTypes.ArrayState;
	import core.stateTypes.ArrayStateReference;
	import core.stateTypes.BooleanState;
	import core.stateTypes.BooleanStateReference;
	import core.stateTypes.MovieClipState;
	import core.stateTypes.MovieClipStateReference;
	import core.stateTypes.StringState;
	import core.stateTypes.StringStateReference;
	
	import components.stateTypes.SceneState;
	import components.stateTypes.SceneStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenesState {
		
		private static var stateManager : StateManager;
		
		// TODO: Rename this state to something like sceneRootMovieClip or sceneTimeLineMovieClip
		public var _selectedChild : MovieClipState;
		public static var selectedChild : MovieClipStateReference;
		
		public var _selectedChildPath : ArrayState;
		public static var selectedChildPath : ArrayStateReference;
		
		public var _scenes : ArrayState;
		public static var scenes : ArrayStateReference;
		
		public var _currentScene : SceneState;
		public static var currentScene : SceneStateReference;
		
		public var _isForceStopped : BooleanState;
		public static var isForceStopped : BooleanStateReference;
		
		public function ScenesState(_stateManager : StateManager) {
			if (stateManager != null) {
				throw new Error("Unable to create a new instance, there can only be one instance");
			}
			
			stateManager = _stateManager;
			
			_selectedChild = stateManager.addState(MovieClipState, MovieClipStateReference, null);
			selectedChild = _selectedChild.reference;
			
			_selectedChildPath = stateManager.addState(ArrayState, ArrayStateReference, null);
			selectedChildPath = _selectedChildPath.reference;
			
			_scenes = stateManager.addState(ArrayState, ArrayStateReference, []);
			scenes = _scenes.reference;
			
			_currentScene = stateManager.addState(SceneState, SceneStateReference, null);
			currentScene = _currentScene.reference;
			
			_isForceStopped = stateManager.addState(BooleanState, BooleanStateReference, false);
			isForceStopped = _isForceStopped.reference;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}