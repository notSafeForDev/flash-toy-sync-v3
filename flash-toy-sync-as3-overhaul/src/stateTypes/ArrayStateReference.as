package stateTypes {
	import stateTypes.ArrayState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ArrayStateReference extends StateReference {
		
		private var state : ArrayState;
		
		public function ArrayStateReference(_state : ArrayState) {
			super();
			state = _state;
		}
		
		public function get value() : Array {
			return state.getValue();
		}
	}
}