package core {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TranspiledMovieClipFunctions {
		
		public static function create(_parent : DisplayObjectContainer, _name : String) : MovieClip {
			var movieClip : MovieClip = new MovieClip();
			_parent.addChild(movieClip);
			movieClip.name = _name;
			
			return movieClip
		}
	}
}