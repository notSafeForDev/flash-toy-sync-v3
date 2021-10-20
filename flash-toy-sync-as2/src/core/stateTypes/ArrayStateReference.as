import core.stateTypes.StateReference;
import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.ArrayStateReference extends StateReference {
	
	public function ArrayStateReference(_state : State) {
		super(_state);
	}
	
	public function get value() : Array {
		return stateObject.getValue();
	}
}