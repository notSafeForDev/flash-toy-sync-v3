/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import components.*
import core.JSON

import stateTypes.StateReference;

/**
 * ...
 * @author notSafeForDev
 */
class components.StateManagerListener {
	
	public var scope ;
	public var handler : Function;
	public var references : Array;
	
	public function StateManagerListener(_scope  , _handler : Function, _references : Array) {
		scope = _scope;
		handler = _handler;
		references = _references;
	}
}