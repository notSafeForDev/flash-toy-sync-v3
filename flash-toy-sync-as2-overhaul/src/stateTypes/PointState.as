/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON

import flash.geom.Point;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.PointState extends State {
	
	public function PointState(_defaultValue : Point) {
		super(_defaultValue, PointStateReference);
	}
	
	public function getValue() : Point {
		return value;
	}
	
	public function setValue(_value : Point) : Void {
		value = _value;
	}
}