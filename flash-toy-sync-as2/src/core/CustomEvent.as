class core.CustomEvent {
	
	private var listeners = [];
	
	function CustomEvent() {
		listeners = [];
	}
	
	function listen(_scope, _handler : Function) {
		var handler = function() {
			_handler.apply(_scope, arguments);
		}
		listeners.push({
			handler: handler, once: false 
		});
	}
	
	function listenOnce(_scope, _handler : Function) {
		var handler = function() {
			_handler.apply(_scope, arguments);
		}
		listeners.push({
			handler: handler, once: true 
		});
	}
	
	function emit(_args) {
		for (var i : Number = 0; i < listeners.length; i++) {
			this.listeners[i].handler(_args);
			if (this.listeners[i].once == true) {
				this.listeners.splice(i, 1);
				i--;
			}
		}
	}
}