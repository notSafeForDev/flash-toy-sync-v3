package stateTypes {
	
	import core.TPDisplayObject;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPDisplayObjectState extends State {
		
		public function TPDisplayObjectState(_defaultValue : TPDisplayObject) {
			super(_defaultValue, TPDisplayObjectStateReference);
		}
		
		public function getValue() : TPDisplayObject {
			return value;
		}
		
		public function setValue(_value : TPDisplayObject) : void {
			changeValue(_value);
		}
	}
}