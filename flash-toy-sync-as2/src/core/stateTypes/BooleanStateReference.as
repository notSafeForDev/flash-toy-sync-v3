import core.stateTypes.StateReference;
import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.BooleanStateReference extends StateReference {
	
	public function BooleanStateReference(_state : State) {
		super(_state);
	}
	
	public function get value() : Boolean {
		return stateObject.getValue();
	}
}