package ui {
	import core.GraphicsUtil;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Icons {
		
		public static function drawCursor(_object : Sprite, _size : Number) : void {
			var x : Number = _size * -0.24;
			var y : Number = _size * -0.5;
			
			GraphicsUtil.moveTo(_object, x, y); // Top left
			GraphicsUtil.lineTo(_object, _size * 0.5, _size * 0.24); // Down right
			GraphicsUtil.lineTo(_object, _size * 0.035, _size * 0.24); // Left
			GraphicsUtil.lineTo(_object, x, _size * 0.5); // Down left
			GraphicsUtil.lineTo(_object, x, y); // Up
			GraphicsUtil.drawCircle(_object, _size * 0.16, _size * 0.35, _size * 0.12);
		}
		
		public static function drawStrikeThrough(_object : Sprite, _size : Number) : void {
			var x : Number = _size * -0.5;
			var y : Number = _size * 0.22;
			
			GraphicsUtil.moveTo(_object, x, y); // Left side top
			GraphicsUtil.lineTo(_object, _size * 0.5, _size * -0.38); // Up right
			GraphicsUtil.lineTo(_object, _size * 0.5, _size * -0.22); // Down
			GraphicsUtil.lineTo(_object, _size * -0.5, _size * 0.38); // Left
			GraphicsUtil.lineTo(_object, x, y); // Up
		}
	}
}