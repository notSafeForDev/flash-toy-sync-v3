package core {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Provides an interface for display objects so that we can access information the same way in both Actionscript 3.0 and 2.0
	 *
	 * @author notSafeForDev
	 */
	public class TPDisplayObject {
		
		private var enterFrameHandlers : Array;
		
		public var sourceDisplayObject : DisplayObject;
		
		public function TPDisplayObject(_object : DisplayObject) {
			if (_object == null) {
				throw new Error("Unable to create a tsDisplayObject, the supplied object is null");
			}
			
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
		
		public function getBounds(_targetCoordinateSpace : TPDisplayObject) : Rectangle {
			return sourceDisplayObject.getBounds(_targetCoordinateSpace.sourceDisplayObject);
		}
		
		public function hitTest(_stageX : Number, _stageY : Number, _shapeFlag : Boolean) : Boolean {
			return sourceDisplayObject.hitTestPoint(_stageX, _stageY, _shapeFlag);
		}
		
		public function isRemoved() : Boolean {
			return sourceDisplayObject.stage == null;
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
			if (_parent.numChildren <= _index) {
				return null;
			}
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
		
		public static function isShape(_object : * ) : Boolean {
			return _object is Shape;
		}
		
		public static function asDisplayObjectContainer(_object : *) : DisplayObjectContainer {
			return _object;
		}
		
		/**
		 * Takes the same transform from one object and applies it to the other, so that the other appears to have the same position, scale, rotation, etc
		 * @param	_fromObject		The object to read the transform from
		 * @param	_toObject		The object to apply the transform to
		 */
		public static function applyTransformMatrixFromOtherObject(_fromObject : TPDisplayObject, _toObject : TPDisplayObject) : void {
			var fromObject : DisplayObject = _fromObject.sourceDisplayObject;
			var toObject : DisplayObject = _toObject.sourceDisplayObject;
			
			var fromBounds : Rectangle = fromObject.getBounds(toObject.parent);
			
			toObject.transform.matrix = fromObject.transform.matrix.clone();
			
			var toBounds : Rectangle = toObject.getBounds(toObject.parent);
			toObject.scaleX = fromBounds.width / toBounds.width;
			toObject.scaleY = fromBounds.height / toBounds.height;
			
			toBounds = toObject.getBounds(toObject.parent);
			
			toObject.x += fromBounds.x - toBounds.x;
			toObject.y += fromBounds.y - toBounds.y;
		}
		
		public static function remove(_object : TPDisplayObject) : void {
			if (_object.parent != null) {
				_object.parent.removeChild(_object.sourceDisplayObject);
			}
		}
	}
}