package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class NumberStateReference extends StateReference {
		
		public function NumberStateReference(_state : State) {
			super(_state);
		}
		
		public function get value() : Number {
			return stateObject.getValue();
		}
	}
}