import core.stateTypes.State;
import flash.geom.Point;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.PointState extends State {
	
	public function PointState() {
		super();
	}
	
	public function setValue(_value : Point) : Void {
		value = _value;
	}
	
	public function getValue() : Point {
		return value;
	}
}