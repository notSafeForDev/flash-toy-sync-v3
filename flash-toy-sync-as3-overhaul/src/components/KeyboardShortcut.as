package components {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class KeyboardShortcut {
		
		public var keys : Vector.<Number>;
		public var scope : *;
		public var handler : Function;
		public var rest : Array;
		public var enabled : Boolean;
		
		public function KeyboardShortcut(_keys : Vector.<Number>, _scope : *, _handler : Function, _rest : Array) {
			keys = _keys;
			scope = _scope;
			handler = _handler;
			rest = _rest;
			
			enabled = true;
		}
	}
}