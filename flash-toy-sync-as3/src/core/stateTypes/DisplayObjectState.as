package core.stateTypes {
	
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectState {
		
		private var value : DisplayObject;
		private var previousValue : DisplayObject;
		private var listeners : Array = [];
		
		public function DisplayObjectState(_default : DisplayObject = null) {
			previousValue = _default;
			value = _default;
		}
		
		public function listen(_scope : *, _handler : Function) : Object {
			var listener : Object = {handler: _handler, scope : _scope}
			listeners.push(listener);
			return listener;
		}
		
		public function setState(_value : DisplayObject) : void {
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
		
		public function getState() : DisplayObject {
			return value;
		}
		
		public function getPreviousState() : DisplayObject {
			return previousValue;
		}
	}
}