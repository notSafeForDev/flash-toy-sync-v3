import flash.geom.ColorTransform;
/**
 * ...
 * @author notSafeForDev
 */
class core.TranspiledDisplayObject {
	
	public var sourceDisplayObject : MovieClip;
	
	// Doesn't use any type, as the object could be a TextField
	public function TranspiledDisplayObject(_object) {
		sourceDisplayObject = _object;
	}
	
	public function get x() : Number {
		return sourceDisplayObject._x;
	}
	
	public function set x(_value : Number) : Void {
		sourceDisplayObject._x = _value;
	}
	
	public function get y() : Number {
		return sourceDisplayObject._y;
	}
	
	public function set y(_value : Number) : Void {
		sourceDisplayObject._y = _value;
	}
	
	public function get width() : Number {
		return sourceDisplayObject._width;
	}
	
	public function set width(_value : Number) : Void {
		sourceDisplayObject._width = _value;
	}
	
	public function get height() : Number {
		return sourceDisplayObject._height;
	}
	
	public function set height(_value : Number) : Void {
		sourceDisplayObject._height = _value;
	}
	
	public function get scaleX() : Number {
		return sourceDisplayObject._xscale / 100;
	}
	
	public function set scaleX(_value : Number) : Void {
		sourceDisplayObject._xscale = _value * 100;
	}
	
	public function get scaleY() : Number {
		return sourceDisplayObject._yscale / 100;
	}
	
	public function set scaleY(_value : Number) : Void {
		sourceDisplayObject._yscale = _value * 100;
	}
	
	public function get alpha() : Number {
		return sourceDisplayObject._alpha / 100;
	}
	
	public function set alpha(_value : Number) : Void {
		sourceDisplayObject._alpha = _value * 100;
	}
	
	public function get visible() : Boolean {
		return sourceDisplayObject._visible;
	}
	
	public function set visible(_value : Boolean) : Void {
		sourceDisplayObject._visible = _value;
	}
	
	public function get name() : String {
		return sourceDisplayObject._name;
	}
	
	public function set name(_value : String) : Void {
		sourceDisplayObject._name = _value;
	}
	
	public function get parent() : MovieClip {
		return sourceDisplayObject._parent;
	}
	
	public function get filters() : Array {
		return sourceDisplayObject.filters;
	}
	
	public function set filters(_value : Array) : Void {
		sourceDisplayObject.filters = _value;
	}
	
	public function get colorTransform() : ColorTransform {
		return sourceDisplayObject.transform.colorTransform;
	}
	
	public function set colorTransform(_value : ColorTransform) : Void {
		sourceDisplayObject.transform.colorTransform = _value;
	}
}