import core.stateTypes.StateReference;
import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.NumberStateReference extends StateReference {
	
	public function NumberStateReference(_state : State) {
		super(_state);
	}
	
	public function get value() : Number {
		return stateObject.getValue();
	}
}