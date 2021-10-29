/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.State {
	
	public var reference ;
	
	public var value ;
	
	public function State(_defaultValue , _referenceClass ) {
		value = _defaultValue;
		reference = new _referenceClass(this);
	}
	
	public function getRawValue()  {
		return value;
	}
}