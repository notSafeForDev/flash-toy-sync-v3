package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class BooleanState extends State {
		
		public function BooleanState() {
			super();
		}
		
		public function setValue(_value : Boolean) : void {
			value = _value;
		}
		
		public function getValue() : Boolean {
			return value;
		}
	}
}