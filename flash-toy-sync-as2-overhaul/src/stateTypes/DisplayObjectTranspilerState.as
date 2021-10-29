/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON

import core.TranspiledDisplayObject;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.DisplayObjectTranspilerState extends State {
	
	public function DisplayObjectTranspilerState(_defaultValue : TranspiledDisplayObject) {
		super(_defaultValue, DisplayObjectTranspilerStateReference);
	}
	
	public function getValue() : TranspiledDisplayObject {
		return value;
	}
	
	public function setValue(_value : TranspiledDisplayObject) : Void {
		value = _value;
	}
}