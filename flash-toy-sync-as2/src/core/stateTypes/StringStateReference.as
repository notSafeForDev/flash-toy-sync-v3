import core.stateTypes.StringState;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.StringStateReference {
	
	private var actualState : StringState;
	
	public function StringStateReference(_state : StringState) {
		actualState = _state;
	}
	
	public function get state() : String {
		return actualState.getState();
	}
}