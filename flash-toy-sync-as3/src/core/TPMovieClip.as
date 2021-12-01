package core {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPMovieClip extends TPDisplayObject {
		
		public var sourceDisplayObjectContainer : DisplayObjectContainer;
		public var sourceMovieClip : MovieClip;
		
		private var isLoader : Boolean; // If it's a loader, it's treated as a movieClip with a single frame
		private var transpiledGraphics : TPGraphics;
		
		public function TPMovieClip(_object : DisplayObjectContainer) {
			super(_object);
			
			sourceDisplayObjectContainer = _object;
			
			isLoader = _object is Loader;
			
			if (_object is MovieClip) {
				sourceMovieClip = (_object as MovieClip);
				transpiledGraphics = new TPGraphics(sourceMovieClip.graphics);
			}
		}
		
		public function get currentFrame() : Number {
			return sourceMovieClip != null ? sourceMovieClip.currentFrame : 1;
		}
		
		public function get totalFrames() : Number {
			return sourceMovieClip != null ? sourceMovieClip.totalFrames : 1;
		}
		
		public function get graphics() : TPGraphics {
			if (sourceMovieClip == null) {
				throw new Error("Unable to access graphics, graphics is only available on valid movieClips");
			}
			
			return transpiledGraphics;
		}
		
		public function get buttonMode() : Boolean {
			return sourceMovieClip != null ? sourceMovieClip.buttonMode : false;
		}
		
		public function set buttonMode(_value : Boolean) : void {
			if (sourceMovieClip == null) {
				throw new Error("Unable to set buttonMode, buttonMode is only available on valid movieClips");
			}
			
			sourceMovieClip.buttonMode = _value;
		}
		
		public function play() : void {
			if (isLoader == true) {
				return;
			}
			
			sourceMovieClip.play();
		}
		
		public function stop() : void {
			if (isLoader == true) {
				return;
			}
			
			sourceMovieClip.stop();
		}
		
		public function gotoAndPlay(_frame : Number) : void {
			if (isLoader == true) {
				return;
			}
			
			sourceMovieClip.gotoAndPlay(_frame);
		}
		
		public function gotoAndStop(_frame : Number) : void {
			if (isLoader == true) {
				return;
			}
			
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
			
			_parent.sourceDisplayObjectContainer.addChild(movieClip);
			
			return new TPMovieClip(movieClip);
		}
		
		/**
		 * Check if a parent has any nested children with more than 1 total frame
		 * @param	_topParent	The parent
		 * @return	Wether it's true or not
		 */
		public static function hasNestedAnimations(_topParent : MovieClip) : Boolean {
			var output : Boolean = false;
			
			TPDisplayObject.iterateOverChildren(_topParent, undefined, function(_child : DisplayObject, _depth : Number, _childIndex : Number) : Number {
				if (_child is MovieClip == true && (_child as MovieClip).totalFrames > 1) {
					output = true;
					return ITERATE_ABORT;
				}
				return ITERATE_CONTINUE;
			});
			
			return output;
		}
	}
}