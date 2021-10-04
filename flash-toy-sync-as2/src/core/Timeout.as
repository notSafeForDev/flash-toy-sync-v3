/**
 * ...
 * @author notSafeForDev
 */
class core.Timeout {
	
	public static function set(_scope, _callback : Function, _delayInMiliseconds : Number) : Number {
		var callback = function() {
			_callback.apply(_scope, arguments);
		}
		return setTimeout(callback, _delayInMiliseconds);
	}
	
	public static function clear(_id : Number) : Void {
		clearTimeout(_id);
	}
}