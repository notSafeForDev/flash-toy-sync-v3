/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.StringState {
	
	private var value : String;
	private var PreviousValue : String;
	private var listeners : Array = [];
	
	public function StringState(_default : String) {
		PreviousValue = _default != undefined ? _default : null;
		value = _default != undefined ? _default : null;
	}
	
	public function listen(_scope, _handler : Function) : Object {
		var listener : Object = {handler: _handler, scope : _scope}
		listeners.push(listener);
		return listener;
	}
	
	public function setState(_value : String) : Void {
		if (_value == value) {
			return;
		}
		
		for (var i : Number = 0; i < listeners.length; i++) {
			this.listeners[i].handler.apply(this.listeners[i].scope, [_value]);
		}
		
		PreviousValue = value;
		value = _value;
	}
	
	public function getState() : String {
		return value;
	}
	
	public function getPreviousValue() : String {
		return PreviousValue;
	}
}