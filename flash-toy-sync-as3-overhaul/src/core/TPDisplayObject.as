package core {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	/**
	 * Provides an interface for display objects so that we can access information the same way in both Actionscript 3.0 and 2.0
	 *
	 * @author notSafeForDev
	 */
	public class TPDisplayObject {
		
		private var enterFrameHandlers : Array;
		
		public var sourceDisplayObject : DisplayObject;
		
		public function TPDisplayObject(_object : DisplayObject) {
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
		
		public function get children() : Vector.<DisplayObject> {
			if (sourceDisplayObject is DisplayObjectContainer == false) {
				return null;
			}
			
			var children : Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var container : DisplayObjectContainer = (sourceDisplayObject as DisplayObjectContainer);
			for (var i : Number = 0; i < container.numChildren; i++) {
				if (container.getChildAt(i) != null) {
					children.push(container.getChildAt(i));
				}
			}
			
			return children;
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
		
		public function setMask(_object : TPDisplayObject) : void {
			sourceDisplayObject.mask = _object.sourceDisplayObject;
		}
		
		public function addEnterFrameListener(_scope : * , _handler : Function) : void {
			if (enterFrameHandlers == null) {
				enterFrameHandlers = [];
			}
			
			var handler : Function = function(e : Event) : void {
				_handler.apply(_scope);
			}
			
			sourceDisplayObject.addEventListener(Event.ENTER_FRAME, handler);
			
			enterFrameHandlers.push({scope: _scope, originalHandler: _handler, handler: handler});
		}
		
		public function removeEnterFrameListener(_scope : * , _handler : Function) : void {
			throw new Error("Unable to remove enterFrame listener, it's not yet implemented in the AS2 version");
			
			if (enterFrameHandlers == null) {
				return;
			}
			
			var handler : Function = null;
			for (var i : Number = 0; i < enterFrameHandlers.length; i++) {
				if (enterFrameHandlers[i].scope == _scope && enterFrameHandlers[i].originalHandler == _handler) {
					handler = enterFrameHandlers[i].handler;
					break;
				}
			}
			
			sourceDisplayObject.removeEventListener(Event.ENTER_FRAME, handler); 
		}
		
		public function localToGlobal(_point : Point) : Point {
			return sourceDisplayObject.localToGlobal(_point);
		}
		
		public function globalToLocal(_point : Point) : Point {
			return sourceDisplayObject.globalToLocal(_point);
		}
		
		public static function getParent(_object : DisplayObject) : DisplayObjectContainer {
			return _object.parent;
		}
		
		public static function getParents(_object : DisplayObject) : Vector.<DisplayObjectContainer> {
			var parents : Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
			
			var parent : DisplayObjectContainer = _object.parent;
			while (parent != null) {
				parents.push(parent);
				parent = parent.parent;
			}
			
			return parents;
		}
		
		public static function getNestedChildren(_topParent : DisplayObjectContainer) : Vector.<DisplayObject> {
			var children : Vector.<DisplayObject> = new Vector.<DisplayObject>();
			
			for (var i : int = 0; i < _topParent.numChildren; i++) {
				var child : * = _topParent.getChildAt(i);
				if (child != null) {
					children.push(child);
				}
				if (child is DisplayObjectContainer) {
					children = children.concat(getNestedChildren(DisplayObjectContainer(child)));
				}
			}
			
			return children;
		}
		
		public static function getChildIndex(_child : DisplayObject) : Number {
			return _child.parent.getChildIndex(_child);
		}
		
		public static function getChildAtIndex(_parent : DisplayObjectContainer, _index : Number) : DisplayObject {
			return _parent.getChildAt(_index);
		}
		
		public static function create(_parent : TPMovieClip, _name : String) : TPDisplayObject {
			var displayObject : DisplayObject = new DisplayObject();
			displayObject.name = _name; 
			
			_parent.sourceMovieClip.addChild(displayObject);
			
			return new TPDisplayObject(displayObject);
		}
		
		public static function isDisplayObjectContainer(_object : *) : Boolean {
			return _object is DisplayObjectContainer;
		}
		
		public static function asDisplayObjectContainer(_object : *) : DisplayObjectContainer {
			return _object;
		}
	}
}