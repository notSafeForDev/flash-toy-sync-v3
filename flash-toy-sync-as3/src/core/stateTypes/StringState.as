package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StringState extends State {
		
		public function StringState() {
			super();
		}
		
		public function setValue(_value : String) : void {
			value = _value;
		}
		
		public function getValue() : String {
			return value;
		}
	}
}