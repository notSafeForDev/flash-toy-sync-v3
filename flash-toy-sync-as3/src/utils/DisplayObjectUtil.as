package utils {
	
	import core.TPDisplayObject;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectUtil {
		
		public static function getParents(_object : DisplayObject) : Vector.<DisplayObjectContainer> {
			var parents : Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
			
			var parent : DisplayObjectContainer = TPDisplayObject.getParent(_object);
			while (parent != null) {
				parents.push(parent);
				parent = TPDisplayObject.getParent(_object);
			}
			
			return parents;
		}
		
		public static function getPathPart(_object : TPDisplayObject, _depth : Number) : String {
			if (_object.name.indexOf("instance") != 0) {
				return _object.name;
			}
			
			var part : String = "";
			
			while (part.length < _depth) {
				part += "#";
			}
			
			return part;
		}
	}
}