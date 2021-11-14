package components {
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Timeout {
		
		/**
		 * Excutes a function after a delay
		 * @param	_scope					The scope for the function
		 * @param	_callback				The function to execute
		 * @param	_delayInMiliseconds		The delay in miliseconds to wait until executing
		 * @param	...rest					Any arguments that will be passed to the callback function when it's executed
		 * @return	An ID for the timeout, can be passed to clear, in order to abort execution of the callback
		 */
		public static function set(_scope : *, _callback : Function, _delayInMiliseconds : Number) : Number {
			var callback : Function = function() : void {
				_callback.apply(_scope);
			}
			return setTimeout(callback, _delayInMiliseconds);
		}
		
		/**
		 * Aborts a timeout with the specified ID
		 * @param	_id		A number representing a reference to the timeout 
		 */
		public static function clear(_id : Number) : void {
			clearTimeout(_id);
		}
	}
}