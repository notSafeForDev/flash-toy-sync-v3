/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON

import models.SceneModel;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.SceneState extends State {
	
	public function SceneState(_defaultValue : SceneModel) {
		super(_defaultValue, SceneStateReference);
	}
	
	public function getValue() : SceneModel {
		return value;
	}
	
	public function setValue(_value : SceneModel) : Void {
		value = _value;
	}
}