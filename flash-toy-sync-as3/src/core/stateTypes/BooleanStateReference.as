package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class BooleanStateReference extends StateReference {
		
		public function BooleanStateReference(_state : State) {
			super(_state);
		}
		
		public function get value() : Boolean {
			return stateObject.getValue();
		}
	}
}