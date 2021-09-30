package core {
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class MovieClipUtil {
		
		/**
		 * Get a path to a nested child
		 * Used in conjunction with getChildFromPath
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
			for (var i = 0; i < children.length; i++) {
				var name : String = children[i].name;
				
				// If the name starts with "instance", then it's most likely auto generated, which changes each time
				// So we instead use hashes followed by the child index, in order to generate a unique name that won't change each time
				if (name.indexOf("instance") == 0) {
					name = "";
					// The number of hashes to add are based on how deeply nested the child is, 1 if it's a direct child of the parent
					while (name.length <= i) {
						name += "#";
					}
					name += children[i].parent.getChildIndex(children[i]);
				}
				
				path.push(name);
			}
			
			return path;
		}
		
		/**
		 * Get a nested child from a path
		 * Used in conjunction with getChildPath
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
		 * @return An array of all nested children
		 */
		public static function getNestedChildren(_topParent : MovieClip) : Array {
			var children : Array = [];
			
			for (var i : int = 0; i < _topParent.numChildren; i++) {
				if (_topParent.getChildAt(i) is MovieClip) {
					var child : MovieClip = MovieClip(_topParent.getChildAt(i));
					children.push(child);
					children = children.concat(getNestedChildren(child));
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
		
		public static function create(_parent : MovieClip, _name : String = "") : MovieClip {
			var movieClip : MovieClip = new MovieClip();
			movieClip.name = _name;
			_parent.addChild(movieClip);
			return movieClip;
		}
		
		public static function getParent(_movieClip : MovieClip) : MovieClip {
			return MovieClip(_movieClip.parent);
		}
		
		public static function getChildIndex(_movieClip) : Number {
			return _movieClip.parent.getChildIndex(_movieClip);
		}
		
		public static function hasNestedAnimations(_topParent : MovieClip) : Boolean {
			return getMaxFramesInChildren(_topParent) > 1;
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
		
		public static function setVisible(_movieClip : MovieClip, _state : Boolean) {
			_movieClip.visible = _state;
		}
		
		public static function getAlpha(_movieClip : MovieClip) : Number {
			return _movieClip.alpha;
		}
		
		public static function setAlpha(_movieClip : MovieClip, _value : Number) {
			_movieClip.alpha = _value;
		}
		
		public static function getX(_movieClip : MovieClip) : Number {
			return _movieClip.x;
		}
		
		public static function setX(_movieClip : MovieClip, _value : Number) {
			_movieClip.x = _value;
		}
		
		public static function getY(_movieClip : MovieClip) : Number {
			return _movieClip.y;
		}
		
		public static function setY(_movieClip : MovieClip, _value : Number) {
			_movieClip.y = _value;
		}
		
		public static function getScaleX(_movieClip : MovieClip) : Number {
			return _movieClip.scaleX;
		}
		
		public static function setScaleX(_movieClip : MovieClip, _value : Number) {
			_movieClip.scaleX = _value;
		}
		
		public static function getScaleY(_movieClip : MovieClip) : Number {
			return _movieClip.scaleY;
		}
		
		public static function setScaleY(_movieClip : MovieClip, _value : Number) {
			_movieClip.scaleY = _value;
		}
		
		public static function getBounds(_movieClip : MovieClip, _targetCoordinateSpace : MovieClip = null) : Rectangle {
			return _movieClip.getBounds(_targetCoordinateSpace);
		}
	}
}