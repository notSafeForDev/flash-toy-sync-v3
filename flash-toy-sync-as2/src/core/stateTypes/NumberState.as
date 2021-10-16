/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.NumberState {
	
	private var value : Number;
	private var PreviousValue : Number;
	private var listeners : Array;
	
	public function NumberState(_default : Number) {
		listeners = [];
		PreviousValue = _default != undefined ? _default : 0;
		value = _default != undefined ? _default : 0;
	}
	
	public function listen(_scope, _handler : Function) : Object {
		var listener : Object = {handler: _handler, scope : _scope}
		listeners.push(listener);
		return listener;
	}
	
	public function setState(_value : Number) : Void {
		if (_value == value) {
			return;
		}
		
		for (var i : Number = 0; i < listeners.length; i++) {
			this.listeners[i].handler.apply(this.listeners[i].scope, [_value]);
		}
		
		PreviousValue = value;
		value = _value;
	}
	
	public function getState() : Number {
		return value;
	}
	
	public function getRawState() : Number {
		return value;
	}
	
	public function getPreviousValue() : Number {
		return PreviousValue;
	}
}