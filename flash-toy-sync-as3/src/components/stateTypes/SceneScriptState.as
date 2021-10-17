package components.stateTypes {
	
	import components.SceneScript;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptState {
		
		private var value : SceneScript;
		private var previousValue : SceneScript;
		private var listeners : Array;
		
		public function SceneScriptState(_default : SceneScript) {
			listeners = [];
			previousValue = _default;
			value = _default;
		}
		
		public function listen(_scope : *, _handler : Function) : Object {
			var listener : Object = {handler: _handler, scope : _scope}
			listeners.push(listener);
			return listener;
		}
		
		public function setState(_value : SceneScript) : void {
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
		
		public function getState() : SceneScript {
			return value;
		}
		
		public function getRawState() : SceneScript {
			return value;
		}
		
		public function getPreviousState() : SceneScript {
			return previousValue;
		}
	}
}