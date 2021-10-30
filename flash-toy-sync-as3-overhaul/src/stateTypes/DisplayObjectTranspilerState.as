package stateTypes {
	
	import core.TPDisplayObject;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectTranspilerState extends State {
		
		public function DisplayObjectTranspilerState(_defaultValue : TPDisplayObject) {
			super(_defaultValue, DisplayObjectTranspilerStateReference);
		}
		
		public function getValue() : TPDisplayObject {
			return value;
		}
		
		public function setValue(_value : TPDisplayObject) : void {
			value = _value;
		}
	}
}