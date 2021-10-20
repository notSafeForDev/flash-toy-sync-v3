package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class NumberState extends State {
		
		public function NumberState() {
			super();
		}
		
		public function setValue(_value : Number) : void {
			value = _value;
		}
		
		public function getValue() : Number {
			return value;
		}
	}
}