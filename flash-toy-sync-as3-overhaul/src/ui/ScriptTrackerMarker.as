package ui {
	
	import core.TPMovieClip;
	import ui.ScriptMarker;
	import ui.TextElement;
	import ui.TextStyles;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptTrackerMarker extends ScriptMarker {
		
		public function ScriptTrackerMarker(_parent : TPMovieClip, _color : Number, _text : String) {
			super(_parent, _text);
			
			element.graphics.beginFill(_color, 0.5);
			element.graphics.drawCircle(0, 0, getRadius());
		}
		
		public function getRadius() : Number {
			return 12;
		}
	}
}