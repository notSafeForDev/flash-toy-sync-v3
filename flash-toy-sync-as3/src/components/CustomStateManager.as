package components {
	
	import components.stateTypes.SceneScriptState;
	import components.stateTypes.SceneScriptStateReference;
	import core.StateManager;
	
	import components.stateTypes.SceneState;
	import components.stateTypes.SceneStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class CustomStateManager extends StateManager {
		
		public function CustomStateManager() {
			super();
		}
		
		/**
		 * Add a state that holds a Scene
		 * @param	_default	The default value for the state
		 * @return	{state: SceneState, reference: SceneStateReference} - An object with the added state and reference
		 */
		public function addSceneState(_default : Scene) : Object {
			var state : SceneState = new SceneState(_default);
			var reference : SceneStateReference = new SceneStateReference(state);
			states.push(state);
			references.push(reference);
			return {state: state, reference: reference};
		}
		
		/**
		 * Add a state that holds a Scene
		 * @param	_default	The default value for the state
		 * @return	{state: SceneState, reference: SceneStateReference} - An object with the added state and reference
		 */
		public function addSceneScriptState(_default : SceneScript) : Object {
			var state : SceneScriptState = new SceneScriptState(_default);
			var reference : SceneScriptStateReference = new SceneScriptStateReference(state);
			states.push(state);
			references.push(reference);
			return {state: state, reference: reference};
		}
	}
}