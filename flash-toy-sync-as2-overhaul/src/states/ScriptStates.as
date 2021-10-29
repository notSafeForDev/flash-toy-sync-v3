/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import states.*
import core.JSON

import components.StateManager;
import flash.geom.Point;
import stateTypes.DisplayObjectTranspilerState;
import stateTypes.DisplayObjectTranspilerStateReference;
import stateTypes.PointState;
import stateTypes.PointStateReference;

/**
 * ...
 * @author notSafeForDev
 */
class states.ScriptStates {
	
	private static var stateManager : StateManager;
	
	public var _baseTrackerPoint : PointState;
	public static var baseTrackerPoint : PointStateReference;
	
	public var _tipTrackerPoint : PointState;
	public static var tipTrackerPoint : PointStateReference;
	
	public var _stimTrackerPoint : PointState;
	public static var stimTrackerPoint : PointStateReference;
	
	public var _baseTrackerAttachedTo : DisplayObjectTranspilerState;
	public static var baseTrackerAttachedTo : DisplayObjectTranspilerStateReference;
	
	public var _tipTrackerAttachedTo : DisplayObjectTranspilerState;
	public static var tipTrackerAttachedTo : DisplayObjectTranspilerStateReference;
	
	public var _stimTrackerAttachedTo : DisplayObjectTranspilerState;
	public static var stimTrackerAttachedTo : DisplayObjectTranspilerStateReference;
	
	public function ScriptStates(_stateManager : StateManager) {
		if (stateManager != null) {
			var returnValue; trace("Error: " + "Unable to create new instance, there can only be one instance"); return returnValue;
		}
		
		_baseTrackerPoint = _stateManager.addState(PointState, null);
		baseTrackerPoint = _baseTrackerPoint.reference;
		
		_tipTrackerPoint = _stateManager.addState(PointState, null);
		tipTrackerPoint = _tipTrackerPoint.reference;
		
		_stimTrackerPoint = _stateManager.addState(PointState, null);
		stimTrackerPoint = _stimTrackerPoint.reference;
		
		_baseTrackerAttachedTo = _stateManager.addState(DisplayObjectTranspilerState, null);
		baseTrackerAttachedTo = _baseTrackerAttachedTo.reference;
		
		_tipTrackerAttachedTo = _stateManager.addState(DisplayObjectTranspilerState, null);
		tipTrackerAttachedTo = _tipTrackerAttachedTo.reference;
		
		_stimTrackerAttachedTo = _stateManager.addState(DisplayObjectTranspilerState, null);
		stimTrackerAttachedTo = _stimTrackerAttachedTo.reference;
		
		stateManager = _stateManager;
	}
	
	public static function listen(_scope  , _handler : Function, _stateReferences : Array) : Void {
		stateManager.listen(_scope, _handler, _stateReferences);
	}
}