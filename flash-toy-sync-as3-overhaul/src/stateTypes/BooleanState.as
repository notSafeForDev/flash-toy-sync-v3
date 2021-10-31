package stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class BooleanState extends State {
		
		public function BooleanState(_defaultValue : Boolean) {
			super(_defaultValue, BooleanStateReference);
		}
		
		public function getValue() : Boolean {
			return value;
		}
		
		public function setValue(_value : Boolean) : void {
			changeValue(_value);
		}
	}
}