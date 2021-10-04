package core {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectUtil {
		
		/**
		 * Get all nested children of a parent
		 * @param	_topParent	The parent
		 * @return An array of all nested children
		 */
		public static function getNestedChildren(_topParent : DisplayObjectContainer) : Array {
			var children : Array = [];
			
			for (var i : int = 0; i < _topParent.numChildren; i++) {
				var child : * = _topParent.getChildAt(i);
				children.push(child);
				if (child is DisplayObjectContainer) {
					children = children.concat(getNestedChildren(DisplayObjectContainer(child)));
				}
			}
			
			return children;
		}
		
		/**
		 * Checks if a position on the stage intersects with an object
		 * @param	_child 		The child to check against
		 * @param	_stageX		The horizontal position on the stage
		 * @param	_stageY		The vertical position on the stage
		 * @param	_shapeFlag	Whether it should take into account the shape of the child, if it's set to false, it will count it as a hit as long as the position is anywhere within the child's bounding box
		 * @return	Whether the position intersected with the child
		 */
		public static function hitTest(_object : DisplayObject, _stageX : Number, _stageY : Number, _shapeFlag : Boolean = false) : Boolean {
			return _object.hitTestPoint(_stageX, _stageY, _shapeFlag);
		}
		
		/**
		 * Get the bounding box for an object, which is represented by a rectangle that encompases the object
		 * @param	_object					The object to get the bounds from
		 * @param	_targetCoordinateSpace	The object to use as a reference point when calculating the position and size of the bounding box
		 * @return	A rectangle representing the object's bounding box
		 */
		public static function getBounds(_object : DisplayObject, _targetCoordinateSpace : DisplayObject = null) : Rectangle {
			return _object.getBounds(_targetCoordinateSpace);
		}
		
		/**
		 * Get the parent of an object
		 * @param	_object		The object to get the parent from
		 * @return	The parent
		 */
		public static function getParent(_object : DisplayObject) : DisplayObject {
			return _object.parent;
		}
		
		/**
		 * Get a list of parents for an object
		 * @param	_movieClip
		 * @return	The list of parents, starting with it's first direct parent, ending with the top most parent
		 */
		public static function getParents(_object : DisplayObject) : Array {
			if (_object.parent is DisplayObjectContainer == false) {
				return [];
			}
			
			var parents : Array = [];
			var parent : DisplayObject = DisplayObject(_object.parent);
			while (true) {
				parents.push(parent);
				if (parent.parent is DisplayObjectContainer) {
					parent = DisplayObject(parent.parent);
				} else {
					break;
				}
			}
			return parents;
		}
		
		public static function getWidth(_object : DisplayObject) : Number {
			return _object.width;
		}
		
		public static function setWidth(_object : DisplayObject, _value : Number) : void {
			_object.width = _value;
		}
		
		public static function getHeight(_object : DisplayObject) : Number {
			return _object.height;
		}
		
		public static function setHeight(_object : DisplayObject, _value : Number) : void {
			_object.height = _value;
		}
		
		public static function isDisplayObject(_object : * ) : Boolean {
			return _object is DisplayObject;
		}
		
		public static function isShape(_object : * ) : Boolean {
			return _object is Shape;
		}
		
		public static function localToGlobal(_object : DisplayObject, _x : Number, _y : Number) : Point {
			return _object.localToGlobal(new Point(_x, _y));
		}
		
		public static function globalToLocal(_object : DisplayObject, _x : Number, _y : Number) : Point {
			return _object.globalToLocal(new Point(_x, _y));
		}
	}
}