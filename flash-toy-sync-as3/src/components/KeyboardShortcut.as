package components {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class KeyboardShortcut {
		
		public var group : String;
		public var keys : Vector.<Number>;
		public var scope : *;
		public var handler : Function;
		public var rest : Array;
		public var enabled : Boolean;
		
		public function KeyboardShortcut(_group : String, _keys : Vector.<Number>, _scope : *, _handler : Function, _rest : Array) {
			group = _group;
			keys = _keys;
			scope = _scope;
			handler = _handler;
			rest = _rest;
			
			enabled = true;
		}
	}
}