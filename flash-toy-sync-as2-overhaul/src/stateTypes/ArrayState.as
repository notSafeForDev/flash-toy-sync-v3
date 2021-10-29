/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.ArrayState extends State {
	
	public function ArrayState(_defaultValue : Array) {
		super(_defaultValue, ArrayStateReference);
	}
	
	public function getValue() : Array {
		return value;
	}
	
	public function setValue(_value : Array) : Void {
		value = _value.slice();
	}
}