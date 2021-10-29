/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON

import models.SceneModel;
import stateTypes.SceneState;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.SceneStateReference extends StateReference {
	
	private var state : SceneState;
	
	public function SceneStateReference(_state : SceneState) {
		super();
		state = _state;
	}
	
	public function get value() : SceneModel {
		return state.getValue();
	}
}