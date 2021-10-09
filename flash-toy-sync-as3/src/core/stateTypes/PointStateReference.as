package core.stateTypes {
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class PointStateReference {
		
		private var actualState : PointState;
		
		public function PointStateReference(_state : PointState) {
			actualState = _state;
		}
		
		public function get state() : Point {
			return actualState.getState();
		}
	}
}