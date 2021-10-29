package stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class NumberState extends State {
		
		public function NumberState(_defaultValue : Number) {
			super(_defaultValue, NumberStateReference);
		}
		
		public function getValue() : Number {
			return value;
		}
		
		public function setValue(_value : Number) : void {
			value = _value;
		}
	}
}