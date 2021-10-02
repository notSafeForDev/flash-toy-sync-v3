package core {
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class MovieClipUtil {
		
		/**
		 * Get the name used for the child in a child path
		 * @param	_child	The child
		 * @param	_depth	How deeply nested a child is, 1 means it's a direct child to the parent
		 * @return	The name
		 */
		private static function getChildPathPart(_child : MovieClip, _depth : int) : String {
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
		 * @param	_topParent	The MovieClip to start generating the path from
		 * @param	_child		The target MovieClip
		 * @return 	An array of strings representing the path to a nested child
		 */
		public static function getChildPath(_topParent : MovieClip, _child : MovieClip) : Array {
			if (_child == _topParent) {
				return [];
			}
			if (_child.parent == null) {
				return null;
			}
			
			var path : Array = [];
			var children : Vector.<MovieClip> = new Vector.<MovieClip>();
			var currentChild : MovieClip = _child;
			children.push(currentChild);
			
			// Start from the child, going back up the hierarchy until it reaches the parent
			while (currentChild.parent != _topParent && currentChild.parent is MovieClip) {
				currentChild = MovieClip(currentChild.parent);
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
		
		/**
		 * Get a nested child from a path, used in conjunction with getChildPath
		 * @param	_topParent	The MovieClip that is parent to the first child in the path
		 * @param	_path		An array of strings representing the path to a nested child
		 * @return 	The child at the end of the path, or null if a child can't be found
		 */
		public static function getChildFromPath(_topParent : MovieClip, _path : Array) : MovieClip {
			var child : MovieClip = _topParent;
		
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
				if (childIndex < child.numChildren && child.getChildAt(childIndex) is MovieClip) {
					child = MovieClip(child.getChildAt(childIndex));
				}
				else {
					child = null;
				}
			}
			
			return child;
		}
		
		/**
		 * Get all nested children of a parent
		 * @param	_topParent	The parent
		 * @param 	_evaluator	A function (_child : MovieClip) : Boolean - which when returning false, filters out the child and any of it's nested children
		 * @param 	_scope		The scope for the evaluator function, needed for compatiblity with AS2
		 * @return An array of all nested children
		 */
		public static function getNestedChildren(_topParent : MovieClip, _evaluator : Function = null, _scope : * = null) : Array {
			var children : Array = [];
			
			for (var i : int = 0; i < _topParent.numChildren; i++) {
				if (_topParent.getChildAt(i) is MovieClip) {
					var child : MovieClip = MovieClip(_topParent.getChildAt(i));
					if (_evaluator == null || _evaluator(child) == true) {
						children.push(child);
						children = children.concat(getNestedChildren(child, _evaluator, _scope));
					}
				}
			}
			
			return children;
		}
		
		/**
		 * Get the max number of animation frames in nested children
		 * @param	_topParent	The parent
		 * @return	The max number of animation frames
		 */
		public static function getMaxFramesInChildren(_topParent : MovieClip) : Number {
			var children : Array = getNestedChildren(_topParent);
			var maxFrames : Number = -1;
			
			for (var i : int = 0; i < children.length; i++) {
				maxFrames = Math.max(maxFrames, children[i].totalFrames);
			}
			
			return maxFrames;
		}
		
		/**
		 * Checks if a position on the stage intersects with a child
		 * @param	_child 		The child to check against
		 * @param	_stageX		The horizontal position on the stage
		 * @param	_stageY		The vertical position on the stage
		 * @param	_shapeFlag	Whether it should take into account the shape of the child, if it's set to false, it will count it as a hit as long as the position is anywhere within the child's bounding box
		 * @return	Whether the position intersected with the child
		 */
		public static function hitTest(_child : MovieClip, _stageX : Number, _stageY : Number, _shapeFlag : Boolean = false) : Boolean {
			return _child.hitTestPoint(_stageX, _stageY, _shapeFlag);
		}
		
		public static function create(_parent : MovieClip, _name : String = "") : MovieClip {
			var movieClip : MovieClip = new MovieClip();
			movieClip.name = _name;
			_parent.addChild(movieClip);
			return movieClip;
		}
		
		public static function remove(_movieClip : MovieClip) : void {
			if (_movieClip.parent != null) {
				_movieClip.parent.removeChild(_movieClip);
			}
		}
		
		public static function getParent(_movieClip : MovieClip) : MovieClip {
			return MovieClip(_movieClip.parent);
		}
		
		public static function getParents(_movieClip : MovieClip) : Array {
			if (_movieClip.parent is MovieClip == false) {
				return [];
			}
			
			var parents : Array = [];
			var parent : MovieClip = MovieClip(_movieClip.parent);
			while (parent is MovieClip) {
				parents.push(parent);
				if (parent.parent is MovieClip) {
					parent = MovieClip(parent.parent);
				} else {
					break;
				}
			}
			return parents;
		}
		
		public static function getChildIndex(_movieClip : MovieClip) : Number {
			return _movieClip.parent.getChildIndex(_movieClip);
		}
		
		/**
		 * Check if a parent has any nested children with more than 1 total frame
		 * @param	_topParent	The parent
		 * @return	Wether it's true or not
		 */
		public static function hasNestedAnimations(_topParent : MovieClip) : Boolean {
			var output : Boolean = false;
			
			iterateOverChildren(_topParent, function(_child : MovieClip) : Boolean {
				if (_child.totalFrames > 1) {
					output = true;
					return false;
				}
				return true;
			}, undefined);
			
			return output;
		}
		
		/**
		 * Calls a callback for each nested child to the parent 
		 * @param	_topParent	The parent
		 * @param	_handler	A function (_child : MovieClip) : Boolean - When this returns false, it stops iterating
		 * @param	_scope		The scope for the function, required for AS2 compatibility
		 */
		public static function iterateOverChildren(_topParent : MovieClip, _handler : Function, _scope : *) : void {
			for (var i : int = 0; i < _topParent.numChildren; i++) {
				var child : * = _topParent.getChildAt(i);
				if (child is MovieClip == false) {
					continue;
				}
				var shouldStop : Boolean = _handler(child) == false;
				if (shouldStop == true) {
					break;
				}
				iterateOverChildren(child, _handler, _scope);
			}
		}
		
		public static function getCurrentFrame(_movieClip : MovieClip) : Number {
			return _movieClip.currentFrame;
		}
		
		public static function getTotalFrames(_movieClip : MovieClip) : Number {
			return _movieClip.totalFrames;
		}
		
		public static function isVisible(_movieClip : MovieClip) : Boolean {
			return _movieClip.visible;
		}
		
		public static function setVisible(_movieClip : MovieClip, _state : Boolean) : void {
			_movieClip.visible = _state;
		}
		
		public static function getAlpha(_movieClip : MovieClip) : Number {
			return _movieClip.alpha;
		}
		
		public static function setAlpha(_movieClip : MovieClip, _value : Number) : void {
			_movieClip.alpha = _value;
		}
		
		public static function getX(_movieClip : MovieClip) : Number {
			return _movieClip.x;
		}
		
		public static function setX(_movieClip : MovieClip, _value : Number) : void {
			_movieClip.x = _value;
		}
		
		public static function getY(_movieClip : MovieClip) : Number {
			return _movieClip.y;
		}
		
		public static function setY(_movieClip : MovieClip, _value : Number) : void {
			_movieClip.y = _value;
		}
		
		public static function getScaleX(_movieClip : MovieClip) : Number {
			return _movieClip.scaleX;
		}
		
		public static function setScaleX(_movieClip : MovieClip, _value : Number) : void {
			_movieClip.scaleX = _value;
		}
		
		public static function getScaleY(_movieClip : MovieClip) : Number {
			return _movieClip.scaleY;
		}
		
		public static function setScaleY(_movieClip : MovieClip, _value : Number) : void {
			_movieClip.scaleY = _value;
		}
		
		public static function getBounds(_movieClip : MovieClip, _targetCoordinateSpace : MovieClip = null) : Rectangle {
			return _movieClip.getBounds(_targetCoordinateSpace);
		}
	}
}