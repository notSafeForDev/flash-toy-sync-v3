import core.stateTypes.State;
/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.StateReference {
	
	public var stateObject;
		
	public function StateReference(_state : State) {
		stateObject = _state;
	}
}