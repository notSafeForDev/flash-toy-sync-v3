/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON
import stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.StringState extends State {
	
	public function StringState(_defaultValue : String) {
		super(_defaultValue, StringStateReference);
	}
	
	public function getValue() : String {
		return value;
	}
	
	public function setValue(_value : String) : Void {
		value = _value;
	}
}