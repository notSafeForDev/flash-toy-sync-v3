/**
 * ...
 * @author notSafeForDev
 */
class core.TranspiledDisplayObjectEventFunctions{
	
	public static function addEnterFrameEventListener(_object : MovieClip, _scope, _handler : Function, _rest : Array) : Void {
		addEventListener(_object, "onEnterFrame", _scope, _handler, _rest);
	}
	
	private static function addEventListener(_object : MovieClip, _event : String, _scope, _handler : Function, _rest : Array) : Void {
		var handler : Function = function() : Void {
			_handler.apply(_scope, _rest);
		}
		
		var originalHandler : Function = _object[_event];
		
		_object[_event] = function() : Void {
			originalHandler();
			handler();
		}
	}
}