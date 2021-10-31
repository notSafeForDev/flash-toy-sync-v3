package stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StateReference {
		
		public var listeners : Array;
		
		public function StateReference() {
			listeners = [];
		}
		
		public function listen(_scope : *, _handler : Function) : void {
			var listener : Function = function() : void {
				_handler.apply(_scope);
			}
			
			listeners.push(listener);
		}
	}
}