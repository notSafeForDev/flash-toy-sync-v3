/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON
import stateTypes.BooleanState;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.BooleanStateReference extends StateReference {
	
	private var state : BooleanState;
	
	public function BooleanStateReference(_state : BooleanState) {
		super();
		state = _state;
	}
	
	public function get value() : Boolean {
		return state.getValue();
	}
}