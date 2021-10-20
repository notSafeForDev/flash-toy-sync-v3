package core.stateTypes {
	
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MovieClipStateReference extends StateReference {
		
		public function MovieClipStateReference(_state : State) {
			super(_state);
		}
		
		public function get value() : MovieClip {
			return stateObject.getValue();
		}
	}
}