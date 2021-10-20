package core.stateTypes {
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class PointState extends State {
		
		public function PointState() {
			super();
		}
		
		public function setValue(_value : Point) : void {
			value = _value != null ? new Point(_value.x, _value.y) : null;
		}
		
		public function getValue() : Point {
			return value;
		}
	}
}