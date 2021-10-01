import core.FunctionUtil;
import core.MouseEvents;
/**
 * ...
 * @author notSafeForDev
 */
class core.MouseEvents {
	
	public function MouseEvents() {
		
	}
	
	public static function addOnMouseDown(_scope, _target : MovieClip, _handler : Function, _arg) {
		add(_scope, _target, "mouseDown", _handler, _arg);
	}
	
	private static function add(_scope, _target : MovieClip, _type : String, _handler : Function, _arg) {
		var functionName = "";
		if (_type == "click") {
			functionName = "onPress"; // Not recommended as that blocks other click events in the children
		} else if (_type == "mouseDown") {
			functionName = "onMouseDown";
		} else if (_type == "mouseUp") {
			functionName = "onMouseUp";
		}
		
		var handler = FunctionUtil.bind(_scope, _handler);
		
		var originalFunction = _target[functionName];
		_target[functionName] = function() {
			if (_target.hitTest(_root._xmouse, _root._ymouse, true) == false) {
				return;
			}
			
			if (_arg != undefined) {
				handler(_arg);
			} else {
				handler();
			}
		}
	}
}