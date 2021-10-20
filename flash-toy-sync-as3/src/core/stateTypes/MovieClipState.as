package core.stateTypes {
	
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MovieClipState extends State {
		
		public function MovieClipState() {
			super();
		}
		
		public function setValue(_value : MovieClip) : void {
			value = _value;
		}
		
		public function getValue() : MovieClip {
			return value;
		}
	}
}