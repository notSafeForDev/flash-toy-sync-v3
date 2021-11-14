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
	public static function addOnMouseDownPassThrough(_scope, _target, _handler : Function) {
		add(_scope, _target, "onMouseDown", _handler, arguments.slice(3));
	}
	
	public static function addOnMouseOver(_scope, _target, _handler : Function) {
		add(_scope, _target, "onRollOver", _handler, arguments.slice(3));
	}
	
	public static function addOnMouseDown(_scope, _target, _handler : Function) {
		add(_scope, _target, "onPress", _handler, arguments.slice(3));
	}
	
	public static function addOnMouseUp(_scope, _target, _handler : Function) {
		add(_scope, _target, "onRelease", _handler, arguments.slice(3));
	}
	
	public static function addOnMouseMove(_scope, _target, _handler : Function) {
		add(_scope, _target, "onMouseMove", _handler, arguments.slice(3));
	}
	
	public static function addOnMouseOut(_scope, _target, _handler : Function) {
		add(_scope, _target, "onRollOut", _handler, arguments.slice(3));
	}
	
	private static function add(_scope, _target, _type : String, _handler : Function, _args : Array) {
		var handler : Function = function() {
			_handler.apply(_scope, _args);
		}
		
		var originalFunction : Function = _target[_type];
		_target[_type] = function() {
			if (originalFunction != undefined) {
				originalFunction();
			}
			
			handler();
		}
	}
}