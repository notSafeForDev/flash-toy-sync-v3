package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ArrayState extends State {
		
		public function ArrayState() {
			super();
		}
		
		public function setValue(_value : Array) : void {
			value = _value != null ? _value.slice() : null;
		}
		
		public function getValue() : Array {
			return value.slice();
		}
	}
}