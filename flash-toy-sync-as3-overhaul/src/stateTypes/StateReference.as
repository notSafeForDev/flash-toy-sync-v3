package stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StateReference {
		
		public var listeners : Array;
		
		public function StateReference() {
			listeners = [];
		}
		
		/**
		 * Start listening for changes to the state, the callback will be called as soon as the state changes, and as soon this function is called
		 * @param	_scope		The owner of the callback
		 * @param	_handler	The callback
		 */
		public function listen(_scope : *, _handler : Function) : void {
			var listener : Function = function() : void {
				_handler.apply(_scope);
			}
			
			listeners.push(listener);
			listener(); // We call the listener immediately, to ensure that the owner of the listener is up to date
		}
	}
}