import flash.geom.Point;
import flash.geom.Rectangle;
/**
 * ...
 * @author notSafeForDev
 */
class core.DisplayObjectUtil {
	
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
			parent = parent.parent;
		}
		return parents;
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
}