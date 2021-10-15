package components.stateTypes {
	
	import components.Scene;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneStateReference {
		
		private var actualState : SceneState;
		
		public function SceneStateReference(_state : SceneState) {
			actualState = _state;
		}
		
		public function get state() : Scene {
			return actualState.getState();
		}
	}
}