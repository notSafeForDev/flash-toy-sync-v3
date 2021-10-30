package stateTypes {
	
	import stateTypes.MovieClipTranspilerState;
	import core.TPMovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MovieClipTranspilerStateReference extends StateReference {
		
		private var state : MovieClipTranspilerState;
		
		public function MovieClipTranspilerStateReference(_state : MovieClipTranspilerState) {
			super();
			state = _state;
		}
		
		public function get value() : TPMovieClip {
			return state.getValue();
		}
	}
}