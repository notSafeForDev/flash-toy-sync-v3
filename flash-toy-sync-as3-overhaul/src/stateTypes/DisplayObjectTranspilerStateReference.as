package stateTypes {
	
	import stateTypes.DisplayObjectTranspilerState;
	import core.TranspiledDisplayObject;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectTranspilerStateReference extends StateReference {
		
		private var state : DisplayObjectTranspilerState;
		
		public function DisplayObjectTranspilerStateReference(_state : DisplayObjectTranspilerState) {
			super();
			state = _state;
		}
		
		public function get value() : TranspiledDisplayObject {
			return state.getValue();
		}
	}
}