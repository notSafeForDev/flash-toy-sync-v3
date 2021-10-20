import core.stateTypes.StateReference;
import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.StringStateReference extends StateReference {
	
	public function StringStateReference(_state : State) {
		super(_state);
	}
	
	public function get value() : String {
		return stateObject.getValue();
	}
}