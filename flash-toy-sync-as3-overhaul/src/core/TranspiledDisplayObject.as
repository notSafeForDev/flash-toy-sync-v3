package core {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	
	/**
	 * Provides an interface for display objects so that we can access information the same way in both Actionscript 3.0 and 2.0
	 *
	 * @author notSafeForDev
	 */
	public class TranspiledDisplayObject {
		
		public var sourceDisplayObject : DisplayObject;
		
		public function TranspiledDisplayObject(_object : DisplayObject) {
			sourceDisplayObject = _object;
		}
		
		public function get x() : Number {
			return sourceDisplayObject.x;
		}
		
		public function set x(_value : Number) : void {
			sourceDisplayObject.x = _value;
		}
		
		public function get y() : Number {
			return sourceDisplayObject.y;
		}
		
		public function set y(_value : Number) : void {
			sourceDisplayObject.y = _value;
		}
		
		public function get width() : Number {
			return sourceDisplayObject.width;
		}
		
		public function set width(_value : Number) : void {
			sourceDisplayObject.width = _value;
		}
		
		public function get height() : Number {
			return sourceDisplayObject.height;
		}
		
		public function set height(_value : Number) : void {
			sourceDisplayObject.height = _value;
		}
		
		public function get scaleX() : Number {
			return sourceDisplayObject.scaleX;
		}
		
		public function set scaleX(_value : Number) : void {
			sourceDisplayObject.scaleX = _value;
		}
		
		public function get scaleY() : Number {
			return sourceDisplayObject.scaleY;
		}
		
		public function set scaleY(_value : Number) : void {
			sourceDisplayObject.scaleY = _value;
		}
		
		public function get alpha() : Number {
			return sourceDisplayObject.alpha;
		}
		
		public function set alpha(_value : Number) : void {
			sourceDisplayObject.alpha = _value;
		}
		
		public function get visible() : Boolean {
			return sourceDisplayObject.visible;
		}
		
		public function set visible(_value : Boolean) : void {
			sourceDisplayObject.visible = _value;
		}
		
		public function get name() : String {
			return sourceDisplayObject.name;
		}
		
		public function set name(_value : String) : void {
			sourceDisplayObject.name = _value;
		}
		
		public function get parent() : DisplayObjectContainer {
			return sourceDisplayObject.parent;
		}
		
		public function get filters() : Array {
			return sourceDisplayObject.filters;
		}
		
		public function set filters(_value : Array) : void {
			sourceDisplayObject.filters = _value;
		}
		
		public function get colorTransform() : ColorTransform {
			return sourceDisplayObject.transform.colorTransform;
		}
		
		public function set colorTransform(_value : ColorTransform) : void {
			sourceDisplayObject.transform.colorTransform = _value;
		}
	}
}