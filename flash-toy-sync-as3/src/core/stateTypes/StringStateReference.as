package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StringStateReference {
		
		private var actualState : StringState;
		
		public function StringStateReference(_state : StringState) {
			actualState = _state;
		}
		
		public function get state() : String {
			return actualState.getState();
		}
	}
}