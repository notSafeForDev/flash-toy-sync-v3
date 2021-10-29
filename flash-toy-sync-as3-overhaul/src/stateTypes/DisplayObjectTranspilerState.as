package stateTypes {
	
	import core.TranspiledDisplayObject;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectTranspilerState extends State {
		
		public function DisplayObjectTranspilerState(_defaultValue : TranspiledDisplayObject) {
			super(_defaultValue, DisplayObjectTranspilerStateReference);
		}
		
		public function getValue() : TranspiledDisplayObject {
			return value;
		}
		
		public function setValue(_value : TranspiledDisplayObject) : void {
			value = _value;
		}
	}
}