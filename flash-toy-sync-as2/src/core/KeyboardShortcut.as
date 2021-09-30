/**
 * ...
 * @author notSafeForDev
 */
class core.KeyboardShortcut {
	
	public var keyCodes : Array;
	public var handler : Function;
	public var enabled : Boolean = true;
	
	public function KeyboardShortcut(_keyCodes : Array, _handler : Function) {
		keyCodes = _keyCodes;
		handler = _handler;
	}
}