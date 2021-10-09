import core.stateTypes.PointState;
import flash.geom.Point;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.PointStateReference {
	
	private var actualState : PointState;
	
	public function PointStateReference(_state : PointState) {
		actualState = _state;
	}
	
	public function get state() : Point {
		return actualState.getState();
	}
}