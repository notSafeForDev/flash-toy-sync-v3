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
	}
}