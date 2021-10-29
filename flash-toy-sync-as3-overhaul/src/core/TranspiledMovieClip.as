package core {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TranspiledMovieClip extends TranspiledDisplayObject {
		
		public var sourceMovieClip : MovieClip;
		
		private var transpiledGraphics : TranspiledGraphics;
		
		public function TranspiledMovieClip(_object : MovieClip) {
			super(_object);
			
			sourceMovieClip = _object;
			transpiledGraphics = new TranspiledGraphics(_object.graphics);
		}
		
		public function get currentFrame() : Number {
			return sourceMovieClip.currentFrame;
		}
		
		public function get totalFrames() : Number {
			return sourceMovieClip.totalFrames;
		}
		
		public function get graphics() : TranspiledGraphics {
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
		
		public static function create(_parent : DisplayObjectContainer, _name : String) : TranspiledMovieClip {
			var movieClip : MovieClip = new MovieClip();
			_parent.addChild(movieClip);
			movieClip.name = _name;
			
			return new TranspiledMovieClip(movieClip);
		}
	}
}