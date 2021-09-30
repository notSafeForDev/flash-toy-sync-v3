/**
 * ...
 * @author notSafeForDev
 */
class core.GraphicsUtil {
	
	public function GraphicsUtil() {
		
	}
	
	public static function clear(_movieClip : MovieClip) {
		_movieClip.clear();
	}
	
	/**
	 * Sets the style for lines, this is cleared when graphics are cleared
	 * @param	_movieClip 		The movieClip to draw the graphics to
	 * @param	_thickness  	The thickness of the line in pixels
	 * @param	_color			The color in the following format: 0xRRGGBB
	 * @param	_alpha			The alpha, from 0 to 1
	 * @param	_pixelHinting	Affects where the pixels are drawn, if set to true, the line width will be rounded to nearest whole amount
	 * @param	_scaleMode		How the line should scale when the movieClip is scaled ("normal", "horizontal", "vertical", "none")
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
	public static function setLineStyle(_movieClip : MovieClip, _thickness : Number, _color : Number, _alpha : Number, _pixelHinting : Boolean, _scaleMode : String, _caps : String, _joints : String, _miterLimit : Number) {
		_movieClip.lineStyle(_thickness || NaN, _color || 0, _alpha != undefined ? _alpha * 100 : 100, _pixelHinting == true, _scaleMode || "normal", _caps || "round", _joints || "round", _miterLimit != undefined ? _miterLimit : 3);
	}
	
	public static function drawRect(_movieClip : MovieClip, _x : Number, _y : Number, _width : Number, _height : Number) {
		_movieClip.moveTo(_x, _y);
		_movieClip.lineTo(_x + _width, _y);
		_movieClip.lineTo(_x + _width, _y + _height);
		_movieClip.lineTo(_x, _y + _height);
		_movieClip.lineTo(_x, _y);
	}
	
	public static function moveTo(_movieClip : MovieClip, _x : Number, _y : Number) {
		_movieClip.moveTo(_x, _y);
	}
	
	public static function lineTo(_movieClip : MovieClip, _x : Number, _y : Number) {
		_movieClip.lineTo(_x, _y);
	}
	
	public static function beginFill(_movieClip : MovieClip, _color : Number, _alpha : Number) {
		_movieClip.beginFill(_color != undefined ? _color : 0, _alpha != undefined ? _alpha * 100 : 100);
	}
}