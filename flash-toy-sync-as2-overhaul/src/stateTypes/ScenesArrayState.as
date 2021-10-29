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
class stateTypes.ScenesArrayState extends State {
	
	public function ScenesArrayState(_defaultValue : Array) {
		super(_defaultValue, ScenesArrayStateReference);
	}
	
	public function getValue() : Array {
		return value;
	}
	
	public function setValue(_value : Array) : Void {
		value = _value;
	}
}