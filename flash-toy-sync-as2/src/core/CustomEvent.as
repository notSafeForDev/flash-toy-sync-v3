import core.ArrayUtil;
class core.CustomEvent {
	
	private var listeners = [];
	
	function CustomEvent() {
		listeners = [];
	}
	
	function listen(_scope, _handler : Function) : Object {
		var listener : Object = {handler: _handler, scope: _scope, once: false}
		listeners.push(listener);
		return listener;
	}
	
	function listenOnce(_scope, _handler : Function) : Object {
		var listener : Object = {handler: _handler, scope: _scope, once: true}
		listeners.push(listener);
		return listener;
	}
	
	function stopListening(_listener : Object) : Boolean {
		return ArrayUtil.remove(listeners, _listener);
	}
	
	function emit() : Void {
		for (var i : Number = 0; i < listeners.length; i++) {
			var listenerHandler : Function = this.listeners[i].handler;
			listenerHandler.apply(this.listeners[i].scope, arguments);
			if (this.listeners[i].once == true) {
				this.listeners.splice(i, 1);
				i--;
			}
		}
	}
}