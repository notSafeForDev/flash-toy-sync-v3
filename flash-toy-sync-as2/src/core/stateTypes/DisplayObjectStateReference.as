import core.stateTypes.DisplayObjectState;
import core.stateTypes.MovieClipState;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.DisplayObjectStateReference {
	
	private var actualState : DisplayObjectState;
	
	public function DisplayObjectStateReference(_state : DisplayObjectState) {
		actualState = _state;
	}
	
	public function get state() : MovieClip {
		return actualState.getState();
	}
}