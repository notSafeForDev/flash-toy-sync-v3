package stateTypes {
	
	import flash.geom.Point;
	import stateTypes.PointState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class PointStateReference extends StateReference {
		
		private var state : PointState;
		
		public function PointStateReference(_state : PointState) {
			super();
			state = _state;
		}
		
		public function get value() : Point {
			return state.getValue();
		}
	}
}