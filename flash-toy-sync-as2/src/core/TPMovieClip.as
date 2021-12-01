import core.TPDisplayObject;
import core.TPGraphics;
import core.TPMovieClip;

/**
 * ...
 * @author notSafeForDev
 */
class core.TPMovieClip extends TPDisplayObject {

	public var sourceDisplayObjectContainer : MovieClip;
	public var sourceMovieClip : MovieClip;
	
	private var transpiledGraphics : TPGraphics;

	public function TPMovieClip(_displayObjectContainer : MovieClip) {
		super(_displayObjectContainer);

		sourceDisplayObjectContainer = _displayObjectContainer;
		sourceMovieClip = _displayObjectContainer;
		transpiledGraphics = new TPGraphics(_displayObjectContainer);
	}

	public function get currentFrame() : Number {
		return sourceDisplayObjectContainer._currentframe;
	}

	public function get totalFrames() : Number {
		return sourceDisplayObjectContainer._totalframes;
	}
	
	public function get graphics() : TPGraphics {
		return transpiledGraphics;
	}

	public function get buttonMode() : Boolean {
		return sourceDisplayObjectContainer.useHandCursor;
	}
	
	public function set buttonMode(_value : Boolean) : Void {
		sourceDisplayObjectContainer.useHandCursor = _value;
	}
	
	public function play() : Void {
		sourceDisplayObjectContainer.play();
	}

	public function stop() : Void {
		sourceDisplayObjectContainer.stop();
	}

	public function gotoAndPlay(_frame : Number) : Void {
		sourceDisplayObjectContainer.gotoAndPlay(_frame);
	}

	public function gotoAndStop(_frame : Number) : Void {
		sourceDisplayObjectContainer.gotoAndStop(_frame);
	}
	
	public static function isMovieClip(_object) : Boolean {
		return typeof _object == "movieclip";
	}
	
	public static function asMovieClip(_object) : MovieClip {
		return _object;
	}
	
	public static function create(_parent : TPMovieClip, _name : String) : TPMovieClip {
		var movieClip : MovieClip = _parent.sourceDisplayObjectContainer.createEmptyMovieClip(_name, _parent.sourceDisplayObjectContainer.getNextHighestDepth());
		return new TPMovieClip(movieClip);
	}
	
	static function hasNestedAnimations(_topParent : MovieClip) : Boolean {
		var output : Boolean = false;
		
		iterateOverChildren(_topParent, undefined, function(_child : MovieClip) : Number {
			if (_child._totalframes > 1) {
				output = true;
				return TPMovieClip.ITERATE_ABORT;
			}
			return TPMovieClip.ITERATE_CONTINUE;
		});
		
		return output;
	}
}