package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class BooleanState {
		
		private var value : Boolean;
		private var previousValue : Boolean;
		private var listeners : Array = [];
		
		public function BooleanState(_default : Boolean = false) {
			previousValue = _default;
			value = _default;
		}
		
		public function listen(_scope : *, _handler : Function) : Object {
			var listener : Object = {handler: _handler, scope : _scope}
			listeners.push(listener);
			return listener;
		}
		
		public function setState(_value : Boolean) : void {
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
		
		public function getState() : Boolean {
			return value;
		}
		
		public function getPreviousState() : Boolean {
			return previousValue;
		}
	}
}