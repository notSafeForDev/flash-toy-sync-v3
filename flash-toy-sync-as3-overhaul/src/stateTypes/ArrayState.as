package stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ArrayState extends State {
		
		public function ArrayState(_defaultValue : Array) {
			super(_defaultValue, ArrayStateReference);
		}
		
		public function getValue() : Array {
			return value;
		}
		
		public function setValue(_value : Array) : void {
			changeValue(_value.slice());
		}
	}
}