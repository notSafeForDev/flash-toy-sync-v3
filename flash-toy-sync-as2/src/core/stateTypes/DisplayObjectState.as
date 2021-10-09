/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.DisplayObjectState {
	
	private var value : MovieClip;
	private var PreviousValue : MovieClip;
	private var listeners : Array = [];
	
	public function DisplayObjectState(_default : MovieClip) {
		PreviousValue = _default != undefined ? _default : null;
		value = _default != undefined ? _default : null;
	}
	
	public function listen(_scope, _handler : Function) : Object {
		var listener : Object = {handler: _handler, scope: _scope}
		listeners.push(listener);
		return listener;
	}
	
	public function setState(_value : MovieClip) : Void {
		if (_value == value) {
			return;
		}
		
		for (var i : Number = 0; i < listeners.length; i++) {
			this.listeners[i].handler.apply(this.listeners[i].scope, [_value]);
		}
		
		PreviousValue = value;
		value = _value;
	}
	
	public function getState() : MovieClip {
		return value;
	}
	
	public function getPreviousValue() : MovieClip {
		return PreviousValue;
	}
}