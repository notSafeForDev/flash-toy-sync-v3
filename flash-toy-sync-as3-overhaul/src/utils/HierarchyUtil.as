package utils {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyUtil {
		
		/**
		 * Get a unique identifier for a child based on it's name, depth and child index
		 * @param	_name			The name for the child, if the name starts with "instance", then the first part of the id is represented by hashes
		 * @param	_depth			How deeply nested the child is
		 * @param	_childIndex		It's child index within it's own parent
		 * @return  The identifier
		 */
		public static function getChildIdentifier(_name : String, _depth : Number, _childIndex : Number) : String {
			if (_depth == 0) {
				return "root";
			}
			
			if (_name.indexOf("instance") != 0) {
				return _name;
			}
			
			var hashes : String = "";
			while (hashes.length < _depth) {
				hashes += "#";
			}
			
			return hashes + _childIndex;
		}
		
		/**
		 * Get a list of identifiers, starting from, but not including, the top parent, ending with the nested child
		 * @param	_topParent	The top most element to start generating the identifiers from
		 * @param	_child		A nested child element within the top parent
		 * @return	An array of identifiers, excluding the topParent
		 */
		public static function getChildPath(_topParent : TPMovieClip, _child : TPDisplayObject) : Vector.<String> {			
			var path : Vector.<String> = new Vector.<String>();
			
			if (_child.sourceDisplayObject == _topParent.sourceDisplayObject) {
				return path;
			}
			if (_child.parent == null) {
				return null;
			}
			
			var children : Vector.<TPDisplayObject> = new Vector.<TPDisplayObject>();
			var currentChild : TPDisplayObject = _child;
			children.push(currentChild);
			
			// Start from the child, going back up the hierarchy until it reaches the parent
			while (currentChild.parent != _topParent.sourceDisplayObject && TPDisplayObject.isDisplayObjectContainer(currentChild.parent) == true) {
				currentChild = new TPDisplayObject(currentChild.parent);
				children.push(currentChild);
			}
			
			// Reverse the array so that it ends with the child
			children.reverse();
				
			// Fill the path array with child names
			for (var i : Number = 0; i < children.length; i++) {
				var childIndex : Number = TPDisplayObject.getChildIndex(children[i].sourceDisplayObject);
				path.push(getChildIdentifier(children[i].name, i + 1, childIndex));
			}
			
			return path;
		}
		
		/**
		 * Get a nested child from list of identifiers, used in conjunction with getChildPath
		 * @param	_topParent	The Object that is parent to the first child in the path
		 * @param	_path		An array of identifiers representing the path to a nested child
		 * @return 	The child at the end of the path, or null if a child can't be found
		 */
		public static function getChildFromPath(_topParent : TPMovieClip, _path : Vector.<String>) : TPDisplayObject {
			var child : DisplayObject = _topParent.sourceDisplayObject;
		
			for (var i : Number = 0; i < _path.length; i++) {
				if (child == null) {
					return null;
				}
				
				var lastHashIndex : Number = _path[i].lastIndexOf("#");
				
				if (lastHashIndex < 0) {
					child = child[_path[i]];
					continue;
				}
				
				if (TPDisplayObject.isDisplayObjectContainer(child) == false) {
					return null;
				}
				
				var childAsParent : DisplayObjectContainer = TPDisplayObject.asDisplayObjectContainer(child);
				var childIndex : Number = parseInt(_path[i].substr(lastHashIndex + 1));
				child = TPDisplayObject.getChildAtIndex(childAsParent, childIndex);
			}
			
			return new TPDisplayObject(child);
		}
	}
}