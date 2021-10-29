/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON
import stateTypes.ArrayState;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.ArrayStateReference extends StateReference {
	
	private var state : ArrayState;
	
	public function ArrayStateReference(_state : ArrayState) {
		super();
		state = _state;
	}
	
	public function get value() : Array {
		return state.getValue();
	}
}