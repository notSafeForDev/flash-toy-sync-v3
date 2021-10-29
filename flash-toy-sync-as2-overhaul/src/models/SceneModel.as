/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import models.*
import core.JSON

/**
 * ...
 * @author notSafeForDev
 */
class models.SceneModel {
	
	private var path : Array;
	
	private var startFrames : Array;
	private var endFrames : Array;
	
	private var script : SceneScriptModel;
	
	private var isForceStopped : Boolean;
	
	public function SceneModel(_path : Array) {
		path = _path;
	}
	
	public  function fromSaveData(_saveData : Object) : Void {
		path = _saveData.path;
		startFrames = _saveData.startFrames;
		endFrames = _saveData.endFrames;
	}
	
	public function toSaveData() : Object {
		return {};
	}
	
	public function update() : Void {
		
	}
	
	public function canEnter() : Boolean {
		return true;
	}
	
	public function enter() : Void {
		
	}
	
	public function exit() : Void {
		
	}
	
	public function play() : Void {
		
	}
	
	public function stop() : Void {
		
	}
	
	public function stepFrames() : Void {
		
	}
	
	public function gotoFrame() : Void {
		
	}
}