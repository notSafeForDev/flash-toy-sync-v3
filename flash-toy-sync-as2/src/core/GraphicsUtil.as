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
	
	public static function setLineStyle(_movieClip : MovieClip, _thickness : Number, _color : Number, _alpha : Number, _pixelHinting : Boolean, _scaleMode : String, _caps : String, _joints : String, _miterLimit : Number) : Void {
		_movieClip.lineStyle(_thickness || NaN, _color || 0, _alpha != undefined ? _alpha * 100 : 100, _pixelHinting == true, _scaleMode || "normal", _caps || "round", _joints || "round", _miterLimit != undefined ? _miterLimit : 3);
	}
	
	public static function drawRect(_movieClip : MovieClip, _x : Number, _y : Number, _width : Number, _height : Number) : Void {
		_movieClip.moveTo(_x, _y);
		_movieClip.lineTo(_x + _width, _y);
		_movieClip.lineTo(_x + _width, _y + _height);
		_movieClip.lineTo(_x, _y + _height);
		_movieClip.lineTo(_x, _y);
	}
	
	public static function drawRoundedRect(_sprite : MovieClip, _x : Number, _y : Number, _width : Number, _height : Number, _cornerRadius : Number) : Void {
		var right : Number = _x + _width;
		var bottom : Number = _y + _height;
		
		with (_sprite) {
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
	
	public static function drawCircle(_movieClip : MovieClip, _x : Number, _y : Number, _radius : Number) : Void {
		_movieClip.moveTo(_x+_radius, _y);
		_movieClip.curveTo(_radius+_x, Math.tan(Math.PI/8)*_radius+_y, Math.sin(Math.PI/4)*_radius+_x, 
		Math.sin(Math.PI/4)*_radius+_y);
		_movieClip.curveTo(Math.tan(Math.PI/8)*_radius+_x, _radius+_y, _x, _radius+_y);
		_movieClip.curveTo(-Math.tan(Math.PI/8)*_radius+_x, _radius+_y, -Math.sin(Math.PI/4)*_radius+_x, 
		Math.sin(Math.PI/4)*_radius+_y);
		_movieClip.curveTo(-_radius+_x, Math.tan(Math.PI/8)*_radius+_y, -_radius+_x, _y);
		_movieClip.curveTo(-_radius+_x, -Math.tan(Math.PI/8)*_radius+_y, -Math.sin(Math.PI/4)*_radius+_x, 
		-Math.sin(Math.PI/4)*_radius+_y);
		_movieClip.curveTo(-Math.tan(Math.PI/8)*_radius+_x, -_radius+_y, _x, -_radius+_y);
		_movieClip.curveTo(Math.tan(Math.PI/8)*_radius+_x, -_radius+_y, Math.sin(Math.PI/4)*_radius+_x, 
		-Math.sin(Math.PI/4)*_radius+_y);
		_movieClip.curveTo(_radius+_x, -Math.tan(Math.PI/8)*_radius+_y, _radius+_x, _y);
	}
	
	public static function moveTo(_movieClip : MovieClip, _x : Number, _y : Number) : Void {
		_movieClip.moveTo(_x, _y);
	}
	
	public static function lineTo(_movieClip : MovieClip, _x : Number, _y : Number) : Void {
		_movieClip.lineTo(_x, _y);
	}
	
	public static function beginFill(_movieClip : MovieClip, _color : Number, _alpha : Number) : Void {
		_movieClip.beginFill(_color != undefined ? _color : 0, _alpha != undefined ? _alpha * 100 : 100);
	}
}