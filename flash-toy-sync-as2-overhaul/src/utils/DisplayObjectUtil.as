/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import utils.*
import core.JSON

import core.TranspiledDisplayObject;
import core.TranspiledDisplayObjectFunctions;

/**
 * ...
 * @author notSafeForDev
 */
class utils.DisplayObjectUtil {
	
	public static function getParents(_object ) : Array {
		var parents : Array = [];
		
		var parent  = TranspiledDisplayObjectFunctions.getParent(_object);
		while (parent != null) {
			parents.push(parent);
			parent = TranspiledDisplayObjectFunctions.getParent(parent);
		}
		
		return parents;
	}
}