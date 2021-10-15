import flash.geom.Point;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.PointState {
	
	private var value : Point;
	private var PreviousValue : Point;
	private var listeners : Array;
	
	public function PointState(_default : Point) {
		listeners = [];
		PreviousValue = _default != undefined ? _default : null;
		value = _default != undefined ? _default : null;
	}
	
	public function listen(_scope, _handler : Function) : Object {
		var listener : Object = {handler: _handler, scope : _scope}
		listeners.push(listener);
		return listener;
	}
	
	public function setState(_value : Point) : Void {
		if (_value == value) {
			return;
		}
		
		for (var i : Number = 0; i < listeners.length; i++) {
			this.listeners[i].handler.apply(this.listeners[i].scope, [_value]);
		}
		
		PreviousValue = value;
		value = _value;
	}
	
	public function getState() : Point {
		return value != null ? new Point(value.x, value.y) : null;
	}
	
	public function getPreviousValue() : Point {
		return PreviousValue;
	}
}