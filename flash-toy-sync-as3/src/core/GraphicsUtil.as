package core {
	
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class GraphicsUtil {
		
		public function GraphicsUtil() {
			
		}
		
		public static function clear(_sprite : Sprite) : void {
			_sprite.graphics.clear();
		}
		
		/**
		 * Sets the style for lines, this is cleared when graphics are cleared
		 * @param	_sprite 		The sprite to draw the graphics to
		 * @param	_thickness  	The thickness of the line in pixels
		 * @param	_color			The color in the following format: 0xRRGGBB
		 * @param	_alpha			The alpha, from 0 to 1
		 * @param	_pixelHinting	Affects where the pixels are drawn, if set to true, the line width will be rounded to nearest whole amount
		 * @param	_scaleMode		How the line should scale when the sprite is scaled ("normal", "horizontal", "vertical", "none")
		 * "normal" 	: the thickness of the line always scales when the object is scaled (the default)
		 * "horizontal"	: the thickness of the line only scales based on the y scale of the object
		 * "vertical" 	: the thickness of the line only scales based on the x scale of the object
		 * "none" 		: the thickness of the line never scales
		 * @param	_caps			How it should draw the end of lines ("round", "square", "none")
		 * "round"		: rounded
		 * "square"		: squared, with the end of the line extruded based on width
		 * "none"		: squared, with the end where the line ends
		 * @param	_joints			How it should draw corners ("round", "bevel", "miter")
		 * "round"		: makes corners appear rounded
		 * "bevel"		: adds a flat side to corners
		 * "miter"		: adds a sharp edge to corners
		 * @param	_miterLimit		Angle threshold for drawing corners
		 */
		public static function setLineStyle(_sprite : Sprite, _thickness : Number = NaN, _color : uint = 0, _alpha : Number = 1, _pixelHinting : Boolean = false, _scaleMode : String = "normal", _caps : String = null, _joints : String = null, _miterLimit : Number = 3) : void {
			_sprite.graphics.lineStyle(_thickness, _color, _alpha, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit);
		}
		
		public static function drawRect(_sprite : Sprite, _x : Number, _y : Number, _width : Number, _height : Number) : void {
			_sprite.graphics.moveTo(_x, _y);
			_sprite.graphics.lineTo(_x + _width, _y);
			_sprite.graphics.lineTo(_x + _width, _y + _height);
			_sprite.graphics.lineTo(_x, _y + _height);
			_sprite.graphics.lineTo(_x, _y);
		}
		
		public static function drawRoundedRect(_sprite : Sprite, _x : Number, _y : Number, _width : Number, _height : Number, _cornerRadius : Number) : void {
			var right : Number = _x + _width;
			var bottom : Number = _y + _height;
			
			with (_sprite.graphics) {
				moveTo(_x + _cornerRadius, _y); // Top left
				lineTo(right - _cornerRadius, _y); // Top edge
				curveTo(right, _y, right, _y + _cornerRadius); // Top right corner 
				lineTo(right, _height - _cornerRadius); // Right edge
				curveTo(right, bottom, right - _cornerRadius, bottom); // Bottom right corner
				lineTo(_x + _cornerRadius, bottom); // Bottom edge
				curveTo(_x, bottom, _x, bottom - _cornerRadius); // Bottom left corner
				lineTo(_x, _y + _cornerRadius); // Left edge
				curveTo(_x, _y, _x + _cornerRadius, _y); // Top left corner
			}
		}
		
		public static function drawCircle(_sprite : Sprite, _x : Number, _y : Number, _radius : Number) : void {
			_sprite.graphics.drawCircle(_x, _y, _radius);
		}
		
		public static function moveTo(_sprite : Sprite, _x : Number, _y : Number) : void {
			_sprite.graphics.moveTo(_x, _y);
		}
		
		public static function lineTo(_sprite : Sprite, _x : Number, _y : Number) : void {
			_sprite.graphics.lineTo(_x, _y);
		}
		
		public static function beginFill(_sprite : Sprite, _color : uint = 0, _alpha : Number = 1) : void {
			_sprite.graphics.beginFill(_color, _alpha);
		}
	}
}