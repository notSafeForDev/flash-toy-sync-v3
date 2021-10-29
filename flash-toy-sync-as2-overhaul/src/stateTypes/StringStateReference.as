/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON
import stateTypes.StateReference;
import stateTypes.StringState;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.StringStateReference extends StateReference {
	
	private var state : StringState;
	
	public function StringStateReference(_state : StringState) {
		super();
		state = _state;
	}
	
	public function get value() : String {
		return state.getValue();
	}
}