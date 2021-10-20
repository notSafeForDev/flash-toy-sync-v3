package core.stateTypes {
	
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectStateReference extends StateReference {
		
		public function DisplayObjectStateReference(_state : State) {
			super(_state);
		}
		
		public function get value() : DisplayObject {
			return stateObject.getValue();
		}
	}
}