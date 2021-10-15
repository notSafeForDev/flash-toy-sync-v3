import flash.geom.Point;
import flash.geom.Rectangle;
/**
 * ...
 * @author notSafeForDev
 */
class core.DisplayObjectUtil {
	
	static function getChildPathPart(_child : MovieClip, _depth : Number) : String {
		if (_child._name.indexOf("instance") != 0) {
			return _child._name;
		}
		
		var name : String = "";
		
		while (name.length <= _depth) {
			name += "#";
		}
		
		name += _child._parent != null ? getChildIndex(_child).toString() : "-1";
		return name;
	}
	
	static function getChildPath(_topParent : MovieClip, _child : MovieClip) : Array {
		if (_child == _topParent) {
			return [];
		}
		if (_child._parent == null) {
			return null;
		}
		
		var path : Array = [];
		var children : Array = [];
		var currentChild : MovieClip = _child;
		children.push(currentChild);
		
		while (currentChild._parent != _topParent) {
			currentChild = currentChild._parent;
			children.push(currentChild);
		}
		
		children.reverse();
		
		for (var i : Number = 0; i < children.length; i++) {
			path.push(getChildPathPart(children[i], i));
		}
		
		return path;
	}
	
	static function getChildFromPath(_topParent : MovieClip, _path : Array) : MovieClip {
		var child : MovieClip = _topParent;
		
		for (var i : Number = 0; i < _path.length; i++) {
			if (child == null) {
				return null;
			}
			
			var lastHashIndex : Number = _path[i].lastIndexOf("#");
			
			if (lastHashIndex < 0) {
				child = child[_path[i]];
				continue;
			}
			
			var childIndex : Number = parseInt(_path[i].substr(lastHashIndex + 1));
			child = getChildAtIndex(child, childIndex);
		}
		
		return child;
	}
	
	static function getChildIndex(_child : MovieClip) : Number {
		var i : Number = 0;
		
		for (var childName in _child._parent) {
			if (typeof _child._parent[childName] == "movieclip") {
				if (childName == _child._name) {
					return i;
				}
				i++;
			}
		}
	}
	
	private static function getChildAtIndex(_movieClip : MovieClip, _index : Number) : MovieClip {
		var i : Number = 0;
		
		for (var childName in _movieClip) {
			if (typeof _movieClip[childName] == "movieclip") {
				if (i == _index) {
					return _movieClip[childName];
				}
				i++;
			}
		}
	}
	
	public static function getName(_displayObject : MovieClip) : String {
		return _displayObject._name;
	}
	
	public static function getChildren(_parent : MovieClip) : Array {
		var children : Array = [];
		
		for (var childName : String in _parent) {
			if (isDisplayObject(_parent[childName]) == true) {
				children.push(_parent[childName]);
			}
		}
		
		// We reverse the children as in AS2, they are ordered from highest to lowest depth, where as in AS3, it's the other way around
		children.reverse();
		
		return children;
	}
	
	public static function getNestedChildren(_topParent : MovieClip) : Array {
		var children : Array = [];
		
		for (var childName : String in _topParent) {
			if (isDisplayObject(_topParent[childName]) == true) {
				children.push(_topParent[childName]);
				children = children.concat(getNestedChildren(_topParent[childName]));
			}
		}
		
		return children;
	}
	
	public static function isNested(_topParent : MovieClip, _child : MovieClip) : Boolean {
		if (_child == null) {
			return false;
		}
		var parents : Array = getParents(_child);
		for (var i : Number = 0; i < parents.length; i++) {
			if (parents[i] == _topParent) {
				return true;
			}
		}
		return false;
	}
	
	public static function hitTest(_object : MovieClip, _stageX : Number, _stageY : Number, _shapeFlag : Boolean) : Boolean {
		return _object.hitTest(_stageX, _stageY, _shapeFlag == true);
	}
	
	public static function getBounds(_object : MovieClip, _targetCoordinateSpace : MovieClip) : Rectangle {
		var bounds : Object = _object.getBounds(_targetCoordinateSpace || _object._parent);
		return new Rectangle(bounds.xMin, bounds.yMin, bounds.xMax - bounds.xMin, bounds.yMax - bounds.yMin);
	}
	
	public static function getParent(_object : MovieClip) : MovieClip {
		return _object._parent;
	}
	
	public static function getParents(_object : MovieClip) : Array {
		var parents : Array = [];
		var parent = _object._parent;
		while (true) {
			if (isDisplayObject(parent) == false) {
				break;
			}
			parents.push(parent);
			parent = parent._parent;
		}
		return parents;
	}
	
	public static function bringToFront(_object : MovieClip) : Void {
		if (_object._parent != null) {
			_object.swapDepths(_object._parent.getNextHighestDepth());
		}
	}

	public static function isDisplayObject(_object) : Boolean {
		return typeof _object == "movieclip" || _object["_visible"] != undefined
	}
	
	// For providing comaptibility with AS3
	public static function isShape(_object) : Boolean {
		return false;
	}
	
	public static function localToGlobal(_object : MovieClip, _x : Number, _y : Number) : Point {
		var point : Point = new Point(_x, _y);
		_object.localToGlobal(point);
		return point;
	}
	
	public static function globalToLocal(_object : MovieClip, _x : Number, _y : Number) : Point {
		var point : Point = new Point(_x, _y);
		_object.globalToLocal(point);
		return point;
	}
	
	static function isVisible(_movieClip : MovieClip) : Boolean {
		return _movieClip._visible;
	}
	
	static function setVisible(_movieClip : MovieClip, _state : Boolean) {
		_movieClip._visible = _state;
	}

	static function getAlpha(_movieClip : MovieClip) : Number {
		return _movieClip._alpha * 0.01;
	}
	
	static function setAlpha(_movieClip : MovieClip, _value : Number) {
		_movieClip._alpha = _value * 100;
	}
	
	static function getX(_movieClip : MovieClip) : Number {
		return _movieClip._x;
	}
	
	static function setX(_movieClip : MovieClip, _value : Number) {
		_movieClip._x = _value;
	}
	
	static function getY(_movieClip : MovieClip) : Number {
		return _movieClip._y;
	}
	
	static function setY(_movieClip : MovieClip, _value : Number) {
		_movieClip._y = _value;
	}

	static function getScaleX(_movieClip : MovieClip) : Number {
		return _movieClip._xscale * 0.01;
	}
	
	static function setScaleX(_movieClip : MovieClip, _value : Number) {
		_movieClip._xscale = _value * 100;
	}
	
	static function getScaleY(_movieClip : MovieClip) : Number {
		return _movieClip._yscale * 0.01;
	}
	
	static function setScaleY(_movieClip : MovieClip, _value : Number) {
		_movieClip._yscale = _value * 100;
	}
	
	public static function getWidth(_object : MovieClip) : Number {
		return _object._width;
	}
	
	public static function setWidth(_object : MovieClip, _value : Number) : Void {
		_object._width = _value;
	}
	
	public static function getHeight(_object : MovieClip) : Number {
		return _object._height;
	}
	
	public static function setHeight(_object : MovieClip, _value : Number) : Void {
		_object._height = _value;
	}
}