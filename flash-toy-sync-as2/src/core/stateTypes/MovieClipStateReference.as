import core.stateTypes.StateReference;
import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.MovieClipStateReference extends StateReference {
	
	public function MovieClipStateReference(_state : State) {
		super(_state);
	}
	
	public function get value() : MovieClip {
		return stateObject.getValue();
	}
}