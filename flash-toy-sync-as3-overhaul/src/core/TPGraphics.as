package core {
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPGraphics {
		
		private var graphics : Graphics;
		
		public function TPGraphics (_graphics : Graphics) {
			graphics = _graphics;
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
		public function lineStyle(_thickness : Number = NaN, _color : uint = 0, _alpha : Number = 1, _pixelHinting : Boolean = false, _scaleMode : String = "normal", _caps : String = null, _joints : String = null, _miterLimit : Number = 3) : void {
			graphics.lineStyle(_thickness, _color, _alpha, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit);
		}
		
		public function beginFill(_color : Number, _alpha : Number = 1) : void {
			graphics.beginFill(_color, _alpha);
		}
		
		public function moveTo(_x : Number, _y : Number) : void {
			graphics.moveTo(_x, _y);
		}
		
		public function lineTo(_x : Number, _y : Number) : void {
			graphics.lineTo(_x, _y);
		}
		
		public function curveTo(_controlX : Number, _controlY : Number, _anchorX : Number, _anchorY : Number) : void {
			graphics.curveTo(_controlX, _controlY, _anchorX, _anchorY);
		}
		
		public function drawRect(_x : Number, _y : Number, _width : Number, _height : Number) : void {
			graphics.drawRect(_x, _y, _width, _height);
		}
		
		public function drawRoundedRect(_x : Number, _y : Number, _width : Number, _height : Number, _radius : Number) : void {
			graphics.drawRoundRect(_x, _y, _width, _height, _radius, _radius);
		}
		
		public function drawCircle(_x : Number, _y : Number, _radius : Number) : void {
			graphics.drawCircle(_x, _y, _radius);
		}
		
		public function endFill() : void {
			graphics.endFill();
		}
		
		public function clear() : void {
			graphics.clear();
		}
	}
}