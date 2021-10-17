package components.stateTypes {
	
	import components.SceneScript;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptStateReference {
		
		private var actualState : SceneScriptState;
		
		public function SceneScriptStateReference(_state : SceneScriptState) {
			actualState = _state;
		}
		
		public function get state() : SceneScript {
			return actualState.getState();
		}
	}
}