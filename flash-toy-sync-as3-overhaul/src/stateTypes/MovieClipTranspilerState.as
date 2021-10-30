package stateTypes {
	
	import core.TPMovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MovieClipTranspilerState extends State {
		
		public function MovieClipTranspilerState(_defaultValue : TPMovieClip) {
			super(_defaultValue, MovieClipTranspilerStateReference);
		}
		
		public function getValue() : TPMovieClip {
			return value;
		}
		
		public function setValue(_value : TPMovieClip) : void {
			value = _value;
		}
	}
}