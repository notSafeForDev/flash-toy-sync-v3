package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ArrayStateReference {
		
		private var actualState : ArrayState;
		
		public function ArrayStateReference(_state : ArrayState) {
			actualState = _state;
		}
		
		public function get state() : Array {
			return actualState.getState();
		}
	}
}