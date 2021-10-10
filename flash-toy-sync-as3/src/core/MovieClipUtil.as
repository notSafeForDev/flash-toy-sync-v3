package core {
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class MovieClipUtil {
		
		/**
		 * Get all nested children of a parent
		 * @param	_topParent	The parent
		 * @param 	_evaluator	A function (_child : MovieClip) : Boolean - which when returning false, filters out the child and any of it's nested children
		 * @param 	_scope		The scope for the evaluator function, needed for compatiblity with AS2
		 * @return An array of all nested children
		 */
		public static function getNestedChildren(_topParent : MovieClip, _evaluator : Function = null, _scope : * = null, _currentDepth : Number = 0) : Array {
			var children : Array = [];
			
			for (var i : int = 0; i < _topParent.numChildren; i++) {
				if (_topParent.getChildAt(i) is MovieClip) {
					var child : MovieClip = MovieClip(_topParent.getChildAt(i));
					if (_evaluator == null || _evaluator(child, _currentDepth + 1) == true) {
						children.push(child);
						children = children.concat(getNestedChildren(child, _evaluator, _scope, _currentDepth + 1));
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
			
			iterateOverChildren(_topParent, function(_child : MovieClip, _depth : Number) : Number {
				if (_child.totalFrames > 1) {
					output = true;
					return ITERATE_ABORT;
				}
				return ITERATE_CONTINUE;
			}, undefined);
			
			return output;
		}
		
		/** Return this from the iterateOverChildren handler in order to keep iterating over children */
		public static var ITERATE_CONTINUE : Number = 0;
		/** Return this from the iterateOverChildren handler in order to skip the nested children of the current child */
		public static var ITERATE_SKIP_NESTED : Number = 1;
		/** Return this from the iterateOverChildren handler in order to skip the remaining children of the current parent */
		public static var ITERATE_SKIP_SIBLINGS : Number = 2;
		/** Return this from the iterateOverChildren handler in order to stop iterating over children */
		public static var ITERATE_ABORT : Number = 3;
		
		/**
		 * Calls a callback for each nested child to the parent 
		 * @param	_topParent	The parent
		 * @param	_handler	A function (_child : MovieClip, _depth : Number) : Number - The callback
		 * The handler should return one of the following codes:
		 * ITERATE_CONTINUE 		: Keep iterating over children
		 * ITERATE_SKIP_NESTED  	: Skip the nested children of the current child
		 * ITERATE_SKIP_SIBLINGS	: Skip the remaining children of the current parent
		 * ITERATE_ABORT			: Stop iterating over children
		 * @param	_scope		The scope for the function, required for AS2 compatibility
		 */
		public static function iterateOverChildren(_topParent : MovieClip, _handler : Function, _scope : *, _currentDepth : Number = 0) : Number {
			for (var i : int = 0; i < _topParent.numChildren; i++) {
				var child : * = _topParent.getChildAt(i);
				if (child is MovieClip == false) {
					continue;
				}
				
				var code : Number = _handler(child, _currentDepth + 1);
				if (code == ITERATE_ABORT || code == ITERATE_SKIP_SIBLINGS) {
					return code;
				}
				if (code != ITERATE_SKIP_NESTED) {
					var recursiveCode : Number = iterateOverChildren(child, _handler, _scope, _currentDepth + 1);
					if (recursiveCode == ITERATE_ABORT) {
						return ITERATE_ABORT;
					}
				}
			}
			
			return ITERATE_CONTINUE;
		}
		
		public static function getCurrentFrame(_movieClip : MovieClip) : Number {
			return _movieClip.currentFrame;
		}
		
		public static function getTotalFrames(_movieClip : MovieClip) : Number {
			return _movieClip.totalFrames;
		}
		
		public static function getBounds(_movieClip : MovieClip, _targetCoordinateSpace : MovieClip = null) : Rectangle {
			return _movieClip.getBounds(_targetCoordinateSpace);
		}
		
		public static function isMovieClip(_object : * ) : Boolean {
			return _object is MovieClip;
		}
		
		public static function objectAsMovieClip(_object : * ) : MovieClip {
			return _object as MovieClip;
		}
	}
}