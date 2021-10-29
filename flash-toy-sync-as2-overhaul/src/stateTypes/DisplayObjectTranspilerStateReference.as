/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON

import stateTypes.DisplayObjectTranspilerState;
import core.TranspiledDisplayObject;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.DisplayObjectTranspilerStateReference extends StateReference {
	
	private var state : DisplayObjectTranspilerState;
	
	public function DisplayObjectTranspilerStateReference(_state : DisplayObjectTranspilerState) {
		super();
		state = _state;
	}
	
	public function get value() : TranspiledDisplayObject {
		return state.getValue();
	}
}