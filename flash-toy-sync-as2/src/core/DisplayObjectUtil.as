import flash.geom.Rectangle;
/**
 * ...
 * @author notSafeForDev
 */
class core.DisplayObjectUtil {
	
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
	
	public static function isDisplayObject(_object) : Boolean {
		return typeof _object == "movieclip" || _object["_visible"] != undefined
	}
}