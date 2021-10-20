import core.stateTypes.StateReference;
import core.stateTypes.State;
import flash.geom.Point;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.PointStateReference extends StateReference {
	
	public function PointStateReference(_state : State) {
		super(_state);
	}
	
	public function get value() : Point {
		return stateObject.getValue();
	}
}