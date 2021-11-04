/**
 * ...
 * @author notSafeForDev
 */
class core.TPGraphics{
	
	private var graphics : MovieClip;
	
	public function TPGraphics(_graphics : MovieClip) {
		graphics = _graphics;
	}
	
	public function lineStyle(_thickness : Number, _color : Number, _alpha : Number, _pixelHinting : Boolean, _scaleMode : String, _caps : String, _joints : String, _miterLimit : Number) : Void {
		graphics.lineStyle(_thickness || NaN, _color || 0, _alpha != undefined ? _alpha * 100 : 100, _pixelHinting == true, _scaleMode || "normal", _caps || "round", _joints || "round", _miterLimit != undefined ? _miterLimit : 3);
	}
	
	public function beginFill(_color : Number, _alpha : Number) : Void {
		graphics.beginFill(_color, _alpha == undefined ? 100 : _alpha * 100);
	}
	
	public function moveTo(_x : Number, _y : Number) : Void {
		graphics.moveTo(_x, _y);
	}
	
	public function lineTo(_x : Number, _y : Number) : Void {
		graphics.lineTo(_x, _y);
	}
	
	public function curveTo(_controlX : Number, _controlY : Number, _anchorX : Number, _anchorY : Number) : Void {
		graphics.curveTo(_controlX, _controlY, _anchorX, _anchorY);
	}
	
	public function drawRect(_x : Number, _y : Number, _width : Number, _height : Number) : Void {
		graphics.moveTo(_x, _y); // Top left
		graphics.lineTo(_x + _width, _y); // To top right
		graphics.lineTo(_x + _width, _y + _height); // To bottom right
		graphics.lineTo(_x, _y + _height); // To bottom left
		graphics.moveTo(_x, _y); // To top left
	}
	
	public function drawRoundedRect(_x : Number, _y : Number, _width : Number, _height : Number, _radius : Number) : Void {
		var right : Number = _x + _width;
		var bottom : Number = _y + _height;
		
		graphics.moveTo(_x + _radius, _y); // Top left
		graphics.lineTo(right - _radius, _y); // Top edge
		graphics.curveTo(right, _y, right, _y + _radius); // Top right corner 
		graphics.lineTo(right, _height - _radius); // Right edge
		graphics.curveTo(right, bottom, right - _radius, bottom); // Bottom right corner
		graphics.lineTo(_x + _radius, bottom); // Bottom edge
		graphics.curveTo(_x, bottom, _x, bottom - _radius); // Bottom left corner
		graphics.lineTo(_x, _y + _radius); // Left edge
		graphics.curveTo(_x, _y, _x + _radius, _y); // Top left corner
	}
	
	public function drawCircle(_x : Number, _y : Number, _radius : Number) : Void {
		graphics.moveTo(_x+_radius, _y);
		graphics.curveTo(_radius+_x, Math.tan(Math.PI/8)*_radius+_y, Math.sin(Math.PI/4)*_radius+_x, Math.sin(Math.PI/4)*_radius+_y);
		graphics.curveTo(Math.tan(Math.PI/8)*_radius+_x, _radius+_y, _x, _radius+_y);
		graphics.curveTo(-Math.tan(Math.PI/8)*_radius+_x, _radius+_y, -Math.sin(Math.PI/4)*_radius+_x, Math.sin(Math.PI/4)*_radius+_y);
		graphics.curveTo(-_radius+_x, Math.tan(Math.PI/8)*_radius+_y, -_radius+_x, _y);
		graphics.curveTo(-_radius+_x, -Math.tan(Math.PI/8)*_radius+_y, -Math.sin(Math.PI/4)*_radius+_x, -Math.sin(Math.PI/4)*_radius+_y);
		graphics.curveTo(-Math.tan(Math.PI/8)*_radius+_x, -_radius+_y, _x, -_radius+_y);
		graphics.curveTo(Math.tan(Math.PI/8)*_radius+_x, -_radius+_y, Math.sin(Math.PI/4)*_radius+_x, -Math.sin(Math.PI/4)*_radius+_y);
		graphics.curveTo(_radius+_x, -Math.tan(Math.PI/8)*_radius+_y, _radius+_x, _y);
	}
	
	public function endFill() : Void {
		graphics.endFill();
	}
	
	public function clear() : Void {
		graphics.clear();
	}
}