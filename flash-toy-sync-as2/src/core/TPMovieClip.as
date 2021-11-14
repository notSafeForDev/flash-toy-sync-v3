import core.TPDisplayObject;
import core.TPGraphics;
import core.TPMovieClip;

/**
 * ...
 * @author notSafeForDev
 */
class core.TPMovieClip extends TPDisplayObject {

	public var sourceMovieClip : MovieClip;
	
	private var transpiledGraphics : TPGraphics;

	public function TPMovieClip(_movieClip : MovieClip) {
		super(_movieClip);

		sourceMovieClip = _movieClip;
		transpiledGraphics = new TPGraphics(_movieClip);
	}

	public function get currentFrame() : Number {
		return sourceMovieClip._currentframe;
	}

	public function get totalFrames() : Number {
		return sourceMovieClip._totalframes;
	}
	
	public function get graphics() : TPGraphics {
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
	
	public static function isMovieClip(_object) : Boolean {
		return typeof _object == "movieclip";
	}
	
	public static function asMovieClip(_object) : MovieClip {
		return _object;
	}
	
	public static function create(_parent : TPMovieClip, _name : String) : TPMovieClip {
		var movieClip : MovieClip = _parent.sourceMovieClip.createEmptyMovieClip(_name, _parent.sourceMovieClip.getNextHighestDepth());
		return new TPMovieClip(movieClip);
	}
	
	static var ITERATE_CONTINUE : Number = 0;
	static var ITERATE_SKIP_NESTED : Number = 1;
	static var ITERATE_SKIP_SIBLINGS : Number = 2;
	static var ITERATE_ABORT : Number = 3;
	
	static function iterateOverChildren(_topParent : MovieClip, _scope, _handler : Function, _args : Array, _currentDepth : Number) : Number {
		if (_currentDepth == undefined) {
			_currentDepth = 0;
		}
		if (_args == undefined) {
			_args = [];
		}
		
		var i : Number = -1;
		for (var childName : String in _topParent) {
			if (typeof _topParent[childName] != "movieclip") {
				continue;
			}
			
			var child : MovieClip = _topParent[childName];
			
			// In case of external swfs, one of the properties can be itself, which puts it into an endless loop
			if (child == _topParent) {
				continue;
			}
			
			i++;
			
			var code = _handler.apply(_scope, [child, _currentDepth + 1, i].concat(_args));
			if (code == ITERATE_ABORT || code == ITERATE_SKIP_SIBLINGS) {
				return code;
			}
			if (code != ITERATE_SKIP_NESTED) {
				var recursiveCode : Number = iterateOverChildren(child, _scope, _handler, _args, _currentDepth + 1);
				if (recursiveCode == ITERATE_ABORT) {
					return ITERATE_ABORT;
				}
			}
			
		}
		
		return ITERATE_CONTINUE;
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