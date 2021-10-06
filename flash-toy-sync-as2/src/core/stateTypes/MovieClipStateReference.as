import core.stateTypes.MovieClipState;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.MovieClipStateReference {
	
	private var actualState : MovieClipState;
	
	public function MovieClipStateReference(_state : MovieClipState) {
		actualState = _state;
	}
	
	public function get state() : MovieClip {
		return actualState.getState();
	}
}