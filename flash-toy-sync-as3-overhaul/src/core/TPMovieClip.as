package core {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPMovieClip extends TPDisplayObject {
		
		public var sourceMovieClip : MovieClip;
		
		private var transpiledGraphics : TPGraphics;
		
		public function TPMovieClip(_object : MovieClip) {
			super(_object);
			
			sourceMovieClip = _object;
			transpiledGraphics = new TPGraphics(_object.graphics);
		}
		
		public function get currentFrame() : Number {
			return sourceMovieClip.currentFrame;
		}
		
		public function get totalFrames() : Number {
			return sourceMovieClip.totalFrames;
		}
		
		public function get graphics() : TPGraphics {
			return transpiledGraphics;
		}
		
		public function get buttonMode() : Boolean {
			return sourceMovieClip.buttonMode;
		}
		
		public function set buttonMode(_value : Boolean) : void {
			sourceMovieClip.buttonMode = _value;
		}
		
		public function play() : void {
			sourceMovieClip.play();
		}
		
		public function stop() : void {
			sourceMovieClip.stop();
		}
		
		public function gotoAndPlay(_frame : Number) : void {
			sourceMovieClip.gotoAndPlay(_frame);
		}
		
		public function gotoAndStop(_frame : Number) : void {
			sourceMovieClip.gotoAndStop(_frame);
		}
		
		public static function isMovieClip(_object : *) : Boolean {
			return _object is MovieClip;
		}
		
		public static function asMovieClip(_object : *) : MovieClip {
			return _object;
		}
		
		public static function create(_parent : TPMovieClip, _name : String) : TPMovieClip {
			var movieClip : MovieClip = new MovieClip();
			movieClip.name = _name; 
			
			_parent.sourceMovieClip.addChild(movieClip);
			
			return new TPMovieClip(movieClip);
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
		 * @param	_topParent		The parent to start with
		 * @param	_scope			The scope for the function
		 * @param	_handler		A function (_child : MovieClip, _depth : Number, _childIndex : Number) : Number - The callback
		 * The handler should return one of the following codes:
		 * ITERATE_CONTINUE 	: Keep iterating over children
		 * ITERATE_SKIP_NESTED  	: Skip the nested children of the current child
		 * ITERATE_SKIP_SIBLINGS	: Skip the remaining children of the current parent
		 * ITERATE_ABORT		: Stop iterating over children
		 * @param _restArguments	Any arguments to pass to the handler
		 * @param _currentDepth 	How deeply nested the current child is in the hierarchy, 1 if it's a direct child to the topParent, this should be left at default
		 */
		public static function iterateOverChildren(_topParent : MovieClip, _scope : *, _handler : Function, _restArguments : Array = null, _currentDepth : Number = 0) : Number {
			for (var i : int = 0; i < _topParent.numChildren; i++) {
				var child : * = _topParent.getChildAt(i);
				if (child is MovieClip == false) {
					continue;
				}
				
				var code : Number = _handler.apply(_scope, [child, _currentDepth + 1, i].concat(_restArguments || []));
				if (code == ITERATE_ABORT || code == ITERATE_SKIP_SIBLINGS) {
					return code;
				}
				if (code != ITERATE_SKIP_NESTED) {
					var recursiveCode : Number = iterateOverChildren(child, _scope, _handler, _restArguments, _currentDepth + 1);
					if (recursiveCode == ITERATE_ABORT) {
						return ITERATE_ABORT;
					}
				}
			}
			
			return ITERATE_CONTINUE;
		}
		
		/**
		 * Check if a parent has any nested children with more than 1 total frame
		 * @param	_topParent	The parent
		 * @return	Wether it's true or not
		 */
		public static function hasNestedAnimations(_topParent : MovieClip) : Boolean {
			var output : Boolean = false;
			
			iterateOverChildren(_topParent, undefined, function(_child : MovieClip, _depth : Number, _childIndex : Number) : Number {
				if (_child.totalFrames > 1) {
					output = true;
					return ITERATE_ABORT;
				}
				return ITERATE_CONTINUE;
			});
			
			return output;
		}
	}
}