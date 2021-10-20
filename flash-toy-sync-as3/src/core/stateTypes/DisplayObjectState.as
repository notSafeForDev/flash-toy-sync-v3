package core.stateTypes {
	
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectState extends State {
		
		public function DisplayObjectState() {
			super();
		}
		
		public function setValue(_value : DisplayObject) : void {
			value = _value;
		}
		
		public function getValue() : DisplayObject {
			return value;
		}
	}
}