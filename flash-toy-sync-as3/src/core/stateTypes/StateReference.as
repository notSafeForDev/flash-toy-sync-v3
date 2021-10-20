package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StateReference {
		
		/** The actual state, must extend the State class */
		protected var stateObject : *;
		
		public function StateReference(_state : State) {
			stateObject = _state;
		}
	}
}