package stateTypes {
	import stateTypes.NumberState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class NumberStateReference extends StateReference {
		
		private var state : NumberState;
		
		public function NumberStateReference(_state : NumberState) {
			super();
			state = _state;
		}
		
		public function get value() : Number {
			return state.getValue();
		}
	}
}