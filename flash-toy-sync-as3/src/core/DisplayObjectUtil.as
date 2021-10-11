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
		 * Get the name used for the child in a child path
		 * @param	_child	The child
		 * @param	_depth	How deeply nested a child is, 1 means it's a direct child to the parent
		 * @return	The name
		 */
		public static function getChildPathPart(_child : DisplayObject, _depth : int) : String {
			// If the name starts with "instance", then it's most likely auto generated, which changes each time
			// So only return the actual name if that isn't the case
			if (_child.name.indexOf("instance") != 0) {
				return _child.name;
			}
				
			var name : String = "";
			
			// Otherwise we use hashes followed by the child index, in order to generate a unique name that won't change each time
			// The number of hashes to add are based on how deeply nested the child is, 1 if it's a direct child of the parent
			while (name.length <= _depth) {
				name += "#";
			}
			
			name += _child.parent.getChildIndex(_child);
			return name;
		}
		
		/**
		 * Get a path to a nested child, used in conjunction with getChildFromPath
		 * @param	_topParent	The DisplayObjectContainer to start generating the path from
		 * @param	_child		The target DisplayObject
		 * @return 	An array of strings representing the path to a nested child
		 */
		public static function getChildPath(_topParent : DisplayObjectContainer, _child : DisplayObject) : Array {
			if (_child == _topParent) {
				return [];
			}
			if (_child.parent == null) {
				return null;
			}
			
			var path : Array = [];
			var children : Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var currentChild : DisplayObject = _child;
			children.push(currentChild);
			
			// Start from the child, going back up the hierarchy until it reaches the parent
			while (currentChild.parent != _topParent && currentChild.parent is DisplayObjectContainer) {
				currentChild = DisplayObject(currentChild.parent);
				children.push(currentChild);
			}
			
			// Reverse the array so that it ends with the child
			children.reverse();
				
			// Fill the path array with child names
			for (var i : Number = 0; i < children.length; i++) {
				path.push(getChildPathPart(children[i], i));
			}
			
			return path;
		}
		
		public static function getChildIndex(_child : DisplayObject) : Number {
			return _child.parent.getChildIndex(_child);
		}
		
		/**
		 * Get a nested child from a path, used in conjunction with getChildPath
		 * @param	_topParent	The MovieClip that is parent to the first child in the path
		 * @param	_path		An array of strings representing the path to a nested child
		 * @return 	The child at the end of the path, or null if a child can't be found
		 */
		public static function getChildFromPath(_topParent : DisplayObjectContainer, _path : Array) : DisplayObject {
			var child : DisplayObject = _topParent;
		
			for (var i : int = 0; i < _path.length; i++) {
				if (child == null) {
					return null;
				}
				
				var lastHashIndex : Number = _path[i].lastIndexOf("#");
				
				if (lastHashIndex < 0) {
					child = child[_path[i]];
					continue;
				}
				
				var childIndex : Number = parseInt(_path[i].substr(lastHashIndex + 1));
				var foundValidChild : Boolean = false;
				if (child is DisplayObjectContainer == true) {
					var childAsParent : DisplayObjectContainer = child as DisplayObjectContainer;
					if (childIndex < childAsParent.numChildren && childAsParent.getChildAt(childIndex) is DisplayObject) {
						child = childAsParent.getChildAt(childIndex);
						foundValidChild = true;
					}
				}
				
				if (foundValidChild == false) {
					child = null;
				}
			}
			
			return child;
		}
		
		public static function getName(_object : DisplayObject) : String {
			return _object.name;
		}
		
		public static function getChildren(_parent : DisplayObject) : Array {
			if (_parent is DisplayObjectContainer == false) {
				return [];
			}
			
			var parent : DisplayObjectContainer = DisplayObjectContainer(_parent);
			var children : Array = [];
			for (var i : int = 0; i < parent.numChildren; i++) {
				var child : DisplayObject = parent.getChildAt(i);
				// Children sometimes become null, likely due to them not being included on the current frame of the parent
				if (child != null) {
					children.push(child);
				}
			}
			
			return children;
		}
		
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
		public static function getParent(_object : DisplayObject) : DisplayObjectContainer {
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
		
		public static function bringToFront(_object : DisplayObject) : void {
			if (_object.parent != null) {
				_object.parent.setChildIndex(_object, _object.parent.numChildren - 1);
			}
		}
		
		public static function isDisplayObjectContainer(_object : * ) : Boolean {
			return _object is DisplayObjectContainer;
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
		
		public static function isVisible(_movieClip : DisplayObject) : Boolean {
			return _movieClip.visible;
		}
		
		public static function setVisible(_movieClip : DisplayObject, _state : Boolean) : void {
			_movieClip.visible = _state;
		}
		
		public static function getAlpha(_movieClip : DisplayObject) : Number {
			return _movieClip.alpha;
		}
		
		public static function setAlpha(_movieClip : DisplayObject, _value : Number) : void {
			_movieClip.alpha = _value;
		}
		
		public static function getX(_movieClip : DisplayObject) : Number {
			return _movieClip.x;
		}
		
		public static function setX(_movieClip : DisplayObject, _value : Number) : void {
			_movieClip.x = _value;
		}
		
		public static function getY(_movieClip : DisplayObject) : Number {
			return _movieClip.y;
		}
		
		public static function setY(_movieClip : DisplayObject, _value : Number) : void {
			_movieClip.y = _value;
		}
		
		public static function getScaleX(_movieClip : DisplayObject) : Number {
			return _movieClip.scaleX;
		}
		
		public static function setScaleX(_movieClip : DisplayObject, _value : Number) : void {
			_movieClip.scaleX = _value;
		}
		
		public static function getScaleY(_movieClip : DisplayObject) : Number {
			return _movieClip.scaleY;
		}
		
		public static function setScaleY(_movieClip : DisplayObject, _value : Number) : void {
			_movieClip.scaleY = _value;
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
	}
}