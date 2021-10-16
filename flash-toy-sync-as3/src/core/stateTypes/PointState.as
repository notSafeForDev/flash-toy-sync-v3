package core.stateTypes {
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class PointState {
		
		private var value : Point;
		private var previousValue : Point;
		private var listeners : Array;
		
		public function PointState(_default : Point = null) {
			listeners = [];
			previousValue = _default;
			value = _default;
		}
		
		public function listen(_scope : *, _handler : Function) : Object {
			var listener : Object = {handler: _handler, scope : _scope}
			listeners.push(listener);
			return listener;
		}
		
		public function setState(_value : Point) : void {
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
		
		public function getState() : Point {
			return value != null ? new Point(value.x, value.y) : null;
		}
		
		public function getRawState() : Point {
			return value;
		}
		
		public function getPreviousState() : Point {
			return previousValue;
		}
	}
}