import core.FunctionUtil;
import core.MouseEvents;
import core.MovieClipUtil;
/**
 * ...
 * @author notSafeForDev
 */
class core.MouseEvents {
	
	/**
	 * Calls a callback when the user clicks: on, through, or anywhere around the target element, as long as the user doesn't click on an overlapping element with mouse event
	 * Note: Doesn't function identical to the AS3 version of addOnMouseDownPassThrough
	 * @param	_scope		The owner of the handler, required for AS2 compatibility
	 * @param	_target		The element the user clicks through
	 * @param	_handler	The callback
	 */
	public static function addOnMouseDownPassThrough(_scope, _target : MovieClip, _handler : Function, _arg) {
		add(_scope, _target, "onMouseDown", _handler, _arg);
	}
	
	public static function addOnMouseOver(_scope, _target : MovieClip, _handler : Function, _arg) {
		add(_scope, _target, "onRollOver", _handler, _arg);
	}
	
	public static function addOnMouseDown(_scope, _target : MovieClip, _handler : Function, _arg) {
		add(_scope, _target, "onPress", _handler, _arg);
	}
	
	public static function addOnMouseOut(_scope, _target : MovieClip, _handler : Function, _arg) {
		add(_scope, _target, "onRollOut", _handler, _arg);
	}
	
	private static function add(_scope, _target : MovieClip, _type : String, _handler : Function, _arg) {
		var handler = FunctionUtil.bind(_scope, _handler);
		
		var originalFunction : Function = _target[_type];
		_target[_type] = function() {
			if (originalFunction != undefined) {
				originalFunction();
			}
			
			if (_arg != undefined) {
				handler(_arg);
			} else {
				handler();
			}
		}
	}
}