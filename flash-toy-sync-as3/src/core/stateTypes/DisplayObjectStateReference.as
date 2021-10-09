package core.stateTypes {

	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectStateReference {
		
		private var actualState : DisplayObjectState;
		
		public function DisplayObjectStateReference(_state : DisplayObjectState) {
			actualState = _state;
		}
		
		public function get state() : DisplayObject {
			return actualState.getState();
		}
	}
}