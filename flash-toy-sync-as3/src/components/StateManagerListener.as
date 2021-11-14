package components {
	
	import stateTypes.StateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StateManagerListener {
		
		public var scope : *;
		public var handler : Function;
		public var references : Vector.<StateReference>;
		
		public function StateManagerListener(_scope : * , _handler : Function, _references : Vector.<StateReference>) {
			scope = _scope;
			handler = _handler;
			references = _references;
		}
	}
}