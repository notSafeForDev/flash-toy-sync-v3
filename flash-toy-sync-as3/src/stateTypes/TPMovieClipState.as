package stateTypes {
	
	import core.TPMovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPMovieClipState extends State {
		
		public function TPMovieClipState(_defaultValue : TPMovieClip) {
			super(_defaultValue, TPMovieClipStateReference);
		}
		
		public function getValue() : TPMovieClip {
			return value;
		}
		
		public function setValue(_value : TPMovieClip) : void {
			changeValue(_value);
		}
	}
}