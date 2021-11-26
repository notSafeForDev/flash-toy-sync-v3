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
			if (_value == null || value == null) {
				changeValue(_value);
				return;
			}
			if (_value.x != value.x || _value.y != value.y) {
				changeValue(_value);
			}
		}
	}
}