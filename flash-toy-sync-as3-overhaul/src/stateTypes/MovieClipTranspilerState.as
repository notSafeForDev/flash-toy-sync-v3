package stateTypes {
	
	import core.TranspiledMovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MovieClipTranspilerState extends State {
		
		public function MovieClipTranspilerState(_defaultValue : TranspiledMovieClip) {
			super(_defaultValue, MovieClipTranspilerStateReference);
		}
		
		public function getValue() : TranspiledMovieClip {
			return value;
		}
		
		public function setValue(_value : TranspiledMovieClip) : void {
			value = _value;
		}
	}
}