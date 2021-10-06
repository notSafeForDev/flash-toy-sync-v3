import core.stateTypes.BooleanState;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.BooleanStateReference {
	
	private var actualState : BooleanState;
	
	public function BooleanStateReference(_state : BooleanState) {
		actualState = _state;
	}
	
	public function get state() : Boolean {
		return actualState.getState();
	}
}