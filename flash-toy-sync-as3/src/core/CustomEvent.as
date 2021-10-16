package core {
	
	public class CustomEvent {
		
		private var listeners : Array = [];
		
		public function CustomEvent() {
			listeners = [];
		}
		
		/**
		 * Calls a callback every time this event is emitted
		 * @param	_scope		The owner of the handler
		 * @param	_handler	The callback function
		 * @return	The listener that was added
		 */
		public function listen(_scope : * , _handler : Function, ...args) : Object {
			var handler : Function = _handler;
			
			if (args.length > 0) {
				handler = function(...args2) : void {
					_handler.apply(_scope, args.concat(args2));
				}
			}
			
			var listener : Object = {handler: handler, scope : _scope, once: false}
			listeners.push(listener);
			return listener;
		}
		
		/**
		 * Calls a callback only one time when this event is emitted
		 * @param	_scope		The owner of the handler
		 * @param	_handler	The callback function
		 * @return	The listener that was added
		 */
		public function listenOnce(_scope : * , _handler : Function) : Object {
			var listener : Object = {handler: _handler, scope : _scope, once: true}
			listeners.push(listener);
			return listener;
		}
		
		/**
		 * Attempts to remove a listener
		 * @param	_listener	The listener to remove
		 * @return	Whether it was successful in removing the listener
		 */
		public function stopListening(_listener : Object) : Boolean {
			var index : int = listeners.indexOf(_listener);
			if (index >= 0) {
				listeners.splice(index, 1);
				return true;
			}
			return false;
		}
		
		/**
		 * Triggers the callbacks for each listener
		 * @param	args 	Any values to send to the callbacks
		 */
		public function emit(...args) : void {
			for (var i : Number = 0; i < listeners.length; i++) {
				var listenerFunction : Function = this.listeners[i].handler;
				listenerFunction.apply(listeners[i].scope, args);
				if (this.listeners[i].once == true) {
					this.listeners.splice(i, 1);
					i--;
				}
			}
		}
	}
}