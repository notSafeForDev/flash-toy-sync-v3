package core {
	
	public class CustomEvent {
		
		private var listeners : Array = [];
		
		public function CustomEvent() {
			listeners = [];
		}
		
		/**
		 * Calls a callback every time this event is emitted
		 * @param	_scope		The owner of the handler, required for AS2 compatibility
		 * @param	_handler	The callback function
		 */
		public function listen(_scope : *, _handler : Function) : void {
			listeners.push({
				handler: _handler, once: false 
			});
		}
		
		/**
		 * Calls a callback only one time when this event is emitted
		 * @param	_scope		The owner of the handler, required for AS2 compatibility
		 * @param	_handler	The callback function
		 */
		public function listenOnce(_scope : *, _handler : Function) : void {
			listeners.push({
				handler: _handler, once: true 
			});
		}
		
		/**
		 * Triggers the callbacks for each listener
		 * @param	args 	Any values to send to the callbacks
		 */
		public function emit(args : * = undefined) : void {
			for (var i : Number = 0; i < listeners.length; i++) {
				this.listeners[i].handler(args);
				if (this.listeners[i].once == true) {
					this.listeners.splice(i, 1);
					i--;
				}
			}
		}
	}
}