package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class NumberStateReference {
		
		private var actualState : NumberState;
		
		public function NumberStateReference(_state : NumberState) {
			actualState = _state;
		}
		
		public function get state() : Number {
			return actualState.getState();
		}
	}
}