package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ArrayState {
		
		private var value : Array;
		private var previousValue : Array;
		private var listeners : Array;
		
		public function ArrayState(_default : Array = null) {
			previousValue = _default;
			value = _default;
			listeners = [];
		}
		
		public function listen(_scope : *, _handler : Function) : Object {
			var listener : Object = {handler: _handler, scope : _scope}
			listeners.push(listener);
			return listener;
		}
		
		public function setState(_value : Array) : void {
			if (_value == value) {
				return;
			}
			
			for (var i : Number = 0; i < listeners.length; i++) {
				this.listeners[i].handler(_value);
				if (this.listeners[i].once == true) {
					this.listeners.splice(i, 1);
					i--;
				}
			}
			previousValue = value;
			value = _value;
		}
		
		public function push(_value : *) : void {
			var state : Array = getState();
			state.push(_value);
			setState(state);
		}
		
		public function remove(_value : * ) : void {
			var state : Array = getState();
			var index : Number = state.indexOf(_value);
			if (index >= 0) {
				state.splice(index, 1);
				setState(state);
			}
		}
		
		public function getState() : Array {
			return value != null ? value.slice() : null;
		}
		
		public function getRawState() : Array {
			return value;
		}
		
		public function getPreviousState() : Array {
			return previousValue.slice();
		}
	}
}