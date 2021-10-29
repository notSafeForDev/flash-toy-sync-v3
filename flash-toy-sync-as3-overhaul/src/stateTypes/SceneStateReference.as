package stateTypes {
	
	import models.SceneModel;
	import stateTypes.SceneState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneStateReference extends StateReference {
		
		private var state : SceneState;
		
		public function SceneStateReference(_state : SceneState) {
			super();
			state = _state;
		}
		
		public function get value() : SceneModel {
			return state.getValue();
		}
	}
}