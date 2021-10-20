import core.stateTypes.StateReference;
import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.DisplayObjectStateReference extends StateReference {
	
	public function DisplayObjectStateReference(_state : State) {
		super(_state);
	}
	
	public function get value() : MovieClip {
		return stateObject.getValue();
	}
}