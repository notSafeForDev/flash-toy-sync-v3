package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class BooleanStateReference {
		
		private var actualState : BooleanState;
		
		public function BooleanStateReference(_state : BooleanState) {
			actualState = _state;
		}
		
		public function get state() : Boolean {
			return actualState.getState();
		}
	}
}