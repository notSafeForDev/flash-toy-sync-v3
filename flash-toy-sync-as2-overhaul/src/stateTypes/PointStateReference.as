/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON

import flash.geom.Point;
import stateTypes.PointState;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.PointStateReference extends StateReference {
	
	private var state : PointState;
	
	public function PointStateReference(_state : PointState) {
		super();
		state = _state;
	}
	
	public function get value() : Point {
		return state.getValue();
	}
}