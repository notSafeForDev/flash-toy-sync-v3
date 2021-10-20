package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ArrayStateReference extends StateReference {
		
		public function ArrayStateReference(_state : State) {
			super(_state);
		}
		
		public function get value() : Array {
			return stateObject.getValue();
		}
	}
}