package core.stateTypes {
	
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MovieClipStateReference {
		
		private var actualState : MovieClipState;
		
		public function MovieClipStateReference(_state : MovieClipState) {
			actualState = _state;
		}
		
		public function get state() : MovieClip {
			return actualState.getState();
		}
	}
}