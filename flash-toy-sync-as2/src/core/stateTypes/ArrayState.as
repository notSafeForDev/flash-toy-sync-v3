import core.ArrayUtil;
/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.ArrayState {
	
	private var value : Array;
	private var PreviousValue : Array;
	private var listeners : Array;
	
	public function ArrayState(_default : Array) {
		PreviousValue = _default != undefined ? _default : null;
		value = _default != undefined ? _default : null;
		listeners = [];
	}
	
	public function listen(_scope, _handler : Function) : Object {
		var listener : Object = {handler: _handler, scope: _scope}
		listeners.push(listener);
		return listener;
	}
	
	public function setState(_value : Array) : Void {		
		if (_value == value) {
			return;
		}
		
		for (var i : Number = 0; i < listeners.length; i++) {
			this.listeners[i].handler.apply(this.listeners[i].scope, [_value]);
		}
		
		PreviousValue = value;
		value = _value;
	}
	
	public function push(_value) : Void {
		var state : Array = getState();
		state.push(_value);
		setState(state);
	}
	
	public function remove(_value) : Void {
		var state : Array = getState();
		var index : Number = ArrayUtil.indexOf(state, _value);
		if (index >= 0) {
			state.splice(index, 1);
			setState(state);
		}
	}
	
	public function getState() : Array {
		return value.slice();
	}
	
	public function getPreviousValue() : Array {
		return PreviousValue;
	}
}