package stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class State {
		
		public var reference : *;
		
		protected var value : *;
		protected var defaultValue : *;
		
		public function State(_defaultValue : *, _referenceClass : Class) {
			value = _defaultValue;
			defaultValue = _defaultValue;
			reference = new _referenceClass(this);
		}
		
		/**
		 * Gets the actual value of the state, if it's an array, this will return the actual instance
		 * @return
		 */
		public function getRawValue() : * {
			return value;
		}
		
		/**
		 * Resets the state to the default value
		 */
		public function reset() : void {
			changeValue(defaultValue);
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