package ui {
	
	import core.TPGraphics;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Icons {
		
		public function Icons() {
			
		}
		
		/** Uses fill only */
		public static function drawListItemSelection(_graphics : TPGraphics, _x : Number, _y : Number, _width : Number, _height : Number) : void {
			_graphics.moveTo(_x, _y);
			_graphics.lineTo(_x + _width * 0.3, _y);
			_graphics.lineTo(_x + _width, _y + _height * 0.5);
			_graphics.lineTo(_x + _width * 0.3, _y + _height);
			_graphics.lineTo(_x, _y + _height);
			_graphics.lineTo(_x, _y);
		}
		
		/** Draw the body of the lock icon, uses fill only */
		public static function drawLockBody(_graphics : TPGraphics, _x : Number, _y : Number, _width : Number, _height : Number) : void {
			_graphics.moveTo(_x, _y + _height * 0.4);
			_graphics.lineTo(_x + _width, _y + _height * 0.4);
			_graphics.lineTo(_x + _width, _y + _height * 1);
			_graphics.lineTo(_x, _y + _height * 1);
			_graphics.lineTo(_x, _y + _height * 0.4);
		}
		
		/** Draw the shackle of the lock icon, uses lines only */
		public static function drawLockShackle(_graphics : TPGraphics, _x : Number, _y : Number, _width : Number, _height : Number) : void {
			_graphics.drawCircle(_x + _width * 0.5, _y + _height * 0.35, _width * 0.35);
		}
		
		/** Draw the key hole of the lock icon, uses fill only */
		public static function drawLockKeyHole(_graphics : TPGraphics, _x : Number, _y : Number, _width : Number, _height : Number) : void {
			_graphics.drawCircle(_x + _width * 0.5, _y + _height * 0.7, _width * 0.2);
		}
	}
}