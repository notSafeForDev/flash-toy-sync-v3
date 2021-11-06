package ui {
	import core.TPMovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptSampleMarker extends ScriptMarker {
		
		private var color : Number;
		
		public function ScriptSampleMarker(_parent : TPMovieClip, _color : Number, _text : String) {
			super(_parent, _text);
			
			color = _color;
			
			displayAsInterpolatedPosition();
		}
		
		public function getRadius() : Number {
			return 10;
		}
		
		public function displayAsKeyPosition() : void {
			element.graphics.clear();
			element.graphics.lineStyle(1, color);
			element.graphics.beginFill(color, 0.25);
			element.graphics.drawCircle(0, 0, getRadius());
		}
		
		public function displayAsInterpolatedPosition() : void {
			element.graphics.clear();
			element.graphics.lineStyle(1, 0xFFFFFF);
			element.graphics.beginFill(0xFFFFFF, 0.25);
			element.graphics.drawCircle(0, 0, getRadius());
		}
	}
}