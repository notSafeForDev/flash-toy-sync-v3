/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON
import stateTypes.NumberState;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.NumberStateReference extends StateReference {
	
	private var state : NumberState;
	
	public function NumberStateReference(_state : NumberState) {
		super();
		state = _state;
	}
	
	public function get value() : Number {
		return state.getValue();
	}
}