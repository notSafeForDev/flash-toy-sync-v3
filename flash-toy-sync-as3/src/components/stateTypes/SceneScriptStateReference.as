package components.stateTypes {
	
	import core.stateTypes.State;
	import core.stateTypes.StateReference;
	
	import components.SceneScript;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptStateReference extends StateReference {
		
		public function SceneScriptStateReference(_state : State) {
			super(_state);
		}
		
		public function get value() : SceneScript {
			return stateObject.getValue();
		}
	}
}