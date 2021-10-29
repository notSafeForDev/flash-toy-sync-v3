import core.TranspiledDisplayObject;
import core.TranspiledGraphics;
import core.TranspiledMovieClip;

/**
 * ...
 * @author notSafeForDev
 */
class core.TranspiledMovieClip extends TranspiledDisplayObject {

	public var sourceMovieClip : MovieClip;
	
	private var transpiledGraphics : TranspiledGraphics;

	public function TranspiledMovieClip(_movieClip : MovieClip) {
		super(_movieClip);

		sourceMovieClip = _movieClip;
		transpiledGraphics = new TranspiledGraphics(_movieClip);
	}

	public function get currentFrame() : Number {
		return sourceMovieClip._currentframe;
	}

	public function get totalFrames() : Number {
		return sourceMovieClip._totalframes;
	}
	
	public function get graphics() : TranspiledGraphics {
		return transpiledGraphics;
	}

	public function get buttonMode() : Boolean {
		return sourceMovieClip.useHandCursor;
	}
	
	public function set buttonMode(_value : Boolean) : Void {
		sourceMovieClip.useHandCursor = _value;
	}
	
	public function play() : Void {
		sourceMovieClip.play();
	}

	public function stop() : Void {
		sourceMovieClip.stop();
	}

	public function gotoAndPlay(_frame : Number) : Void {
		sourceMovieClip.gotoAndPlay(_frame);
	}

	public function gotoAndStop(_frame : Number) : Void {
		sourceMovieClip.gotoAndStop(_frame);
	}
	
	public static function create(_parent : MovieClip, _name : String) : TranspiledMovieClip {
		var movieClip : MovieClip = _parent.createEmptyMovieClip(_name, _parent.getNextHighestDepth());
		return new TranspiledMovieClip(movieClip);
	}
}