package core.stateTypes {
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class PointStateReference extends StateReference {
		
		public function PointStateReference(_state : State) {
			super(_state);
		}
		
		public function get value() : Point {
			return stateObject.getValue();
		}
	}
}