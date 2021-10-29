package stateTypes {
	import stateTypes.BooleanState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class BooleanStateReference extends StateReference {
		
		private var state : BooleanState;
		
		public function BooleanStateReference(_state : BooleanState) {
			super();
			state = _state;
		}
		
		public function get value() : Boolean {
			return state.getValue();
		}
	}
}