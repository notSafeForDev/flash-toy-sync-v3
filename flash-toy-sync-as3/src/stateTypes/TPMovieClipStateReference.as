package stateTypes {
	
	import stateTypes.TPMovieClipState;
	import core.TPMovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPMovieClipStateReference extends StateReference {
		
		private var state : TPMovieClipState;
		
		public function TPMovieClipStateReference(_state : TPMovieClipState) {
			super();
			state = _state;
		}
		
		public function get value() : TPMovieClip {
			return state.getValue();
		}
	}
}