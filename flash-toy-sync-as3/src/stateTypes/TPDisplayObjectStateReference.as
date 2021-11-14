package stateTypes {
	
	import stateTypes.TPDisplayObjectState;
	import core.TPDisplayObject;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPDisplayObjectStateReference extends StateReference {
		
		private var state : TPDisplayObjectState;
		
		public function TPDisplayObjectStateReference(_state : TPDisplayObjectState) {
			super();
			state = _state;
		}
		
		public function get value() : TPDisplayObject {
			return state.getValue();
		}
	}
}