import core.stateTypes.ArrayState;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.ArrayStateReference {
	
	private var actualState : ArrayState;
	
	public function ArrayStateReference(_state : ArrayState) {
		actualState = _state;
	}
	
	public function get state() : Array {
		return actualState.getState();
	}
}