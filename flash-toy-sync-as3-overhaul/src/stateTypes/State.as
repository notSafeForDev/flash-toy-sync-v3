package stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class State {
		
		public var reference : *;
		
		protected var value : *;
		
		public function State(_defaultValue : *, _referenceClass : Class) {
			value = _defaultValue;
			reference = new _referenceClass(this);
		}
		
		public function getRawValue() : * {
			return value;
		}
		
		protected function changeValue(_value : * ) : void {
			var isDifferent : Boolean = value != _value;
			if (isDifferent == true) {
				value = _value;
				for (var i : Number = 0; i < reference.listeners.length; i++) {
					reference.listeners[i]();
				}
			}
		}
	}
}