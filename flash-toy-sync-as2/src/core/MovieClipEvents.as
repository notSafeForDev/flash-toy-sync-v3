import core.FunctionUtil;
import core.MovieClipEvents;
/**
 * ...
 * @author notSafeForDev
 */
class core.MovieClipEvents {
	
	public function MovieClipEvents() {
		
	}
	
	public static function addOnEnterFrame(_scope, _movieClip : MovieClip, _handler : Function) {
		MovieClipEvents.add(_scope, _movieClip, "onEnterFrame", _handler);
	}
	
	private static function add(_scope, _movieClip : MovieClip, _type : String, _handler : Function) {
		var handler = FunctionUtil.bind(_scope, _handler);
		var originalFunction = _movieClip[_type];
		_movieClip[_type] = function() {
			if (originalFunction != undefined) {
				originalFunction();
			}
			handler();
		}
	}
}