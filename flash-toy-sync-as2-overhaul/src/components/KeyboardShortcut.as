/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import components.*
import core.JSON

/**
 * ...
 * @author notSafeForDev
 */
class components.KeyboardShortcut {
	
	public var keys : Array;
	public var scope ;
	public var handler : Function;
	public var rest : Array;
	public var enabled : Boolean;
	
	public function KeyboardShortcut(_keys : Array, _scope , _handler : Function, _rest : Array) {
		keys = _keys;
		scope = _scope;
		handler = _handler;
		rest = _rest;
		
		enabled = true;
	}
}