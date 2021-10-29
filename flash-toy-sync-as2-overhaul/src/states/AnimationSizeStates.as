/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import states.*
import core.JSON

import components.StateManager;
import stateTypes.NumberState;
import stateTypes.NumberStateReference;

/**
 * ...
 * @author notSafeForDev
 */
class states.AnimationSizeStates {
	
	private static var stateManager : StateManager;
	
	public var _width : NumberState;
	public static var width : NumberStateReference;
	
	public var _height : NumberState;
	public static var height : NumberStateReference;
	
	public function AnimationSizeStates(_stateManager : StateManager) {
		if (stateManager != null) {
			var returnValue; trace("Error: " + "Unable to create new instance, there can only be one instance"); return returnValue;
		}
		
		_width = _stateManager.addState(NumberState, 1280);
		width = _width.reference;
		
		_height = _stateManager.addState(NumberState, 720);
		height = _height.reference;
		
		stateManager = _stateManager;
	}
	
	public static function listen(_scope  , _handler : Function, _stateReferences : Array) : Void {
		stateManager.listen(_scope, _handler, _stateReferences);
	}
}