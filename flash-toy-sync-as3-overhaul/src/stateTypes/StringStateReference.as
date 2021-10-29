package stateTypes {
	import stateTypes.StateReference;
	import stateTypes.StringState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StringStateReference extends StateReference {
		
		private var state : StringState;
		
		public function StringStateReference(_state : StringState) {
			super();
			state = _state;
		}
		
		public function get value() : String {
			return state.getValue();
		}
	}
}