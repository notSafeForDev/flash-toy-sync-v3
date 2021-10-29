/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import models.*
import core.JSON

import flash.geom.Point;

/**
 * ...
 * @author notSafeForDev
 */
class models.SceneScriptModel {
	
	/** The screen position of the base of the "penis", on each frame in the scene */
	private var basePositions : Array;
	/** The screen position of the tip of the "penis", on each frame in the scene */
	private var tipPositions : Array;
	/** The screen position where the stimulation takes place on the "penis", on each frame in the scene */
	private var stimPositions : Array;
	
	/** The "penetration" depth on each frame in the scene */
	private var depths : Array;
	
	/** The scene this script is used for */
	private var scene : SceneModel;
	
	public function SceneScriptModel() {
		basePositions = [];
		tipPositions = [];
		stimPositions = [];
		
		depths = [];
	}
	
	public function clone() : SceneScriptModel {
		var cloned : SceneScriptModel = new SceneScriptModel();
		
		cloned.basePositions = basePositions.slice();
		cloned.tipPositions = tipPositions.slice();
		cloned.stimPositions = stimPositions.slice();
		cloned.depths = depths.slice();
		
		return cloned;
	}
}