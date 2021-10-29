/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import states.*
import core.JSON

import components.StateManager;
import stateTypes.BooleanState;
import stateTypes.BooleanStateReference;
import stateTypes.StringState;
import stateTypes.StringStateReference;

/**
 * ...
 * @author notSafeForDev
 */
class states.EditorStates {
	
	private static var stateManager : StateManager;
	
	public var _isEditor : BooleanState;
	public static var isEditor : BooleanStateReference;
	
	public var _mouseSelectFilter : StringState;
	public static var mouseSelectFilter : StringStateReference;
	
	public function EditorStates(_stateManager : StateManager) {
		if (stateManager != null) {
			var returnValue; trace("Error: " + "Unable to create new instance, there can only be one instance"); return returnValue;
		}
		
		_isEditor = _stateManager.addState(BooleanState, false);
		isEditor = _isEditor.reference;
		
		stateManager = _stateManager;
	}
	
	public static function listen(_scope  , _handler : Function, _stateReferences : Array) : Void {
		stateManager.listen(_scope, _handler, _stateReferences);
	}
}