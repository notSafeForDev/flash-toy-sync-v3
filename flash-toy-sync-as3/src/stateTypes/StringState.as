package stateTypes {
	import stateTypes.State;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StringState extends State {
		
		public function StringState(_defaultValue : String) {
			super(_defaultValue, StringStateReference);
		}
		
		public function getValue() : String {
			return value;
		}
		
		public function setValue(_value : String) : void {
			changeValue(_value);
		}
	}
}