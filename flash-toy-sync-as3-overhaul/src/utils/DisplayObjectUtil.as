package utils {
	
	import core.TranspiledDisplayObject;
	import core.TranspiledDisplayObjectFunctions;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectUtil {
		
		public static function getParents(_object : DisplayObject) : Vector.<DisplayObjectContainer> {
			var parents : Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
			
			var parent : DisplayObjectContainer = TranspiledDisplayObjectFunctions.getParent(_object);
			while (parent != null) {
				parents.push(parent);
				parent = TranspiledDisplayObjectFunctions.getParent(parent);
			}
			
			return parents;
		}
	}
}