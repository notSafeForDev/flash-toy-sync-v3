package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StringStateReference extends StateReference {
		
		public function StringStateReference(_state : State) {
			super(_state);
		}
		
		public function get value() : String {
			return stateObject.getValue();
		}
	}
}