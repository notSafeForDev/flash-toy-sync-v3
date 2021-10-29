package stateTypes {
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class PointState extends State {
		
		public function PointState(_defaultValue : Point) {
			super(_defaultValue, PointStateReference);
		}
		
		public function getValue() : Point {
			return value;
		}
		
		public function setValue(_value : Point) : void {
			value = _value;
		}
	}
}