package ui {
	
	import core.TPGraphics;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Icons {
		
		/** Uses fill only */
		public static function drawListItemSelectionIcon(_graphics : TPGraphics, _x : Number, _y : Number, _width : Number, _height : Number) : void {
			_graphics.moveTo(_x, _y);
			_graphics.lineTo(_x + _width * 0.3, _y);
			_graphics.lineTo(_x + _width, _y + _height * 0.5);
			_graphics.lineTo(_x + _width * 0.3, _y + _height);
			_graphics.lineTo(_x, _y + _height);
			_graphics.lineTo(_x, _y);
		}
		
		/** Uses fill only */
		public static function drawLockIcon(_graphics : TPGraphics, _x : Number, _y : Number, _width : Number, _height : Number) : void {
			// Shackle
			_graphics.drawRect(_x + _width * 0.2, _y, _width * 0.6, _height * 0.1);
			_graphics.drawRect(_x + _width * 0.1, _y + _height * 0.1, _width * 0.8, _height * 0.1);
			_graphics.drawRect(_x + _width * 0.1, _y + _height * 0.2, _width * 0.2, _height * 0.2);
			_graphics.drawRect(_x + _width * 0.7, _y + _height * 0.2, _width * 0.2, _height * 0.2);
			// Body
			_graphics.drawRect(_x, _y + _height * 0.4, _width, _height * 0.6);
			_graphics.drawRect(_x + _width * 0.4, _y + _height * 0.6, _width * 0.2, _height * 0.2);
		}
		
		/** Uses fill only */
		public static function drawDeleteIcon(_graphics : TPGraphics, _x : Number, _y : Number, _width : Number, _height : Number) : void {
			// Lid
			_graphics.drawRect(_x + _width * 0.1, _y, _width * 0.8, _height * 0.1);
			_graphics.drawRect(_x, _y + _height * 0.1, _width, _height * 0.1);
			// Container
			_graphics.drawRect(_x + _width * 0.1, _y + _height * 0.3, _width * 0.8, _height * 0.7);
			// Lines on container
			_graphics.drawRect(_x + _width * 0.3, _y + _height * 0.4, _width * 0.1, _height * 0.4)
			_graphics.drawRect(_x + _width * 0.6, _y + _height * 0.4, _width * 0.1, _height * 0.4);
		}
		
		/** Uses fill only */
		public static function drawMergeIcon(_graphics : TPGraphics, _x : Number, _y : Number, _width : Number, _height : Number) : void {
			// Top left and bottom right squares
			_graphics.drawRect(_x, _y, _width * 0.7, _height * 0.7);
			_graphics.drawRect(_x + _width * 0.3, _y + _height * 0.3, _width * 0.7, _height * 0.7);
			// Middle square
			_graphics.drawRect(_x + _width * 0.4, _y + _height * 0.4, _width * 0.2, _height * 0.2);
		}
	}
}