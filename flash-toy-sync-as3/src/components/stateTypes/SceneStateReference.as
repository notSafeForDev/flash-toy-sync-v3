package components.stateTypes {
	
	import core.stateTypes.State;
	import core.stateTypes.StateReference;
	
	import components.Scene;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneStateReference extends StateReference {
		
		public function SceneStateReference(_state : State) {
			super(_state);
		}
		
		public function get value() : Scene {
			return stateObject.getValue();
		}
	}
}