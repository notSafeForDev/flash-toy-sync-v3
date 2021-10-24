package components {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import utils.SaveDataUtil;
	
	import core.ArrayUtil;
	import core.DisplayObjectUtil;
	import core.MathUtil;
	
	import global.ScenesState;
	import global.ScriptingState;
	
	import components.Scene;
	import components.SceneScript;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MarkerSceneScript extends SceneScript {
		
		public static var sceneScriptType : String = "MARKER_SCENE_SCRIPT";
		
		public var stimulationPositions : Array = null;
		public var basePositions : Array = null;
		public var tipPositions : Array = null;
		
		public function MarkerSceneScript(_scene : Scene) {
			super(_scene);
			
			stimulationPositions = [];
			basePositions = [];
			tipPositions = [];
		}
		
		public override function toSaveData() : Object {
			var saveData : Object = super.toSaveData();
			
			saveData.type = getType();
			saveData.stimulationPositions = SaveDataUtil.convertPointsToSaveData(stimulationPositions);
			saveData.basePositions = SaveDataUtil.convertPointsToSaveData(basePositions);
			saveData.tipPositions = SaveDataUtil.convertPointsToSaveData(tipPositions);
			
			return saveData;
		}
		
		public static function fromSaveData(_saveData : Object) : MarkerSceneScript {
			var scenes : Array = ScenesState.scenes.value;
			var scene : Scene;
			for (var i : Number = 0; i < scenes.length; i++) {
				scene = scenes[i];
				if (scene.isFrameInScene(_saveData.scenePath, _saveData.sceneFirstFrames) == true) {
					break;
				}
			}
			
			var sceneScript : MarkerSceneScript = new MarkerSceneScript(scene);
			sceneScript.depthsAtFrames = _saveData.depthsAtFrames.slice();
			sceneScript.startRootFrame = _saveData.startRootFrame;
			
			sceneScript.stimulationPositions = SaveDataUtil.getPointsFromSaveData(_saveData.stimulationPositions);
			sceneScript.basePositions = SaveDataUtil.getPointsFromSaveData(_saveData.basePositions);
			sceneScript.tipPositions = SaveDataUtil.getPointsFromSaveData(_saveData.tipPositions);
			
			return sceneScript;
		}
		
		public override function clone() : SceneScript {
			var cloned : MarkerSceneScript = new MarkerSceneScript(scene);
			cloned.depthsAtFrames = depthsAtFrames.slice();
			cloned.startRootFrame = startRootFrame;
			cloned.stimulationPositions = clonePointsArray(stimulationPositions);
			cloned.basePositions = clonePointsArray(basePositions);
			cloned.tipPositions = clonePointsArray(tipPositions);
			
			return cloned;
		}
		
		private function clonePointsArray(_points : Array) : Array {
			var clonedPoints : Array = [];
			for (var i : Number = 0; i < _points.length; i++) {
				var point : Point = _points[i];
				clonedPoints.push(point.clone());
			}
			return clonedPoints;
		}
		
		public static function fromCurrentState(_topParent : MovieClip) : MarkerSceneScript {
			var currentScene : Scene = ScenesState.currentScene.value;
			var markerSceneScript : MarkerSceneScript = new MarkerSceneScript(currentScene);
			
			return markerSceneScript;
		}
		
		public static function asMarkerSceneScript(_sceneScript : SceneScript) : MarkerSceneScript {
			if (_sceneScript == null || _sceneScript.getType() != sceneScriptType) {
				return null;
			}
			
			var script : * = _sceneScript;
			return script;
		}
		
		protected override function addBlankDataToBeginning() : void {
			super.addBlankDataToBeginning();
			stimulationPositions.unshift(null);
			basePositions.unshift(null);
			tipPositions.unshift(null);
		}
		
		protected override function addBlankDataToEnd() : void {
			super.addBlankDataToEnd();
			stimulationPositions.push(null);
			basePositions.push(null);
			tipPositions.push(null);
		}
		
		protected override function removeDataFromBeginning(_amount : Number) : void {
			super.removeDataFromBeginning(_amount);
			stimulationPositions = stimulationPositions.slice(_amount);
			basePositions = basePositions.slice(_amount);
			tipPositions = tipPositions.slice(_amount);
		}
		
		protected override function removeDataFromEnd(_amount : Number) : void {
			super.removeDataFromEnd(_amount);
			stimulationPositions.length = stimulationPositions.length - _amount;
			basePositions.length = basePositions.length - _amount;
			tipPositions.length = tipPositions.length - _amount;
		}
		
		protected override function addDataForCurrentFrame(_index : Number, _depth : Number) : void {
			var stimulation : Point = getMarkerPosition(ScriptingState.stimulationMarkerAttachedTo.value, ScriptingState.stimulationMarkerPoint.value);
			var base : Point = getMarkerPosition(ScriptingState.baseMarkerAttachedTo.value, ScriptingState.baseMarkerPoint.value);
			var tip : Point = getMarkerPosition(ScriptingState.tipMarkerAttachedTo.value, ScriptingState.tipMarkerPoint.value);
			
			if (_index >= stimulationPositions.length) {
				stimulationPositions.push(stimulation);
				basePositions.push(base);
				tipPositions.push(tip);
			} else {
				stimulationPositions[_index] = stimulation;
				basePositions[_index] = base;
				tipPositions[_index] = tip;
			}
			
			var depth : Number = calculateDepthFromPositions(stimulation, base, tip);
			
			super.addDataForCurrentFrame(_index, depth);
		}
		
		public override function getType() : String {
			return sceneScriptType;
		}
		
		public override function canRecord() : Boolean {
			var dependencies : Array = [
				ScriptingState.stimulationMarkerAttachedTo.value,
				ScriptingState.stimulationMarkerPoint.value,
				ScriptingState.baseMarkerAttachedTo.value,
				ScriptingState.baseMarkerPoint.value,
				ScriptingState.tipMarkerAttachedTo.value,
				ScriptingState.tipMarkerPoint.value
			];
			
			return ArrayUtil.indexOf(dependencies, null) < 0;
		}
		
		/**
		 * Get the position at a specific frame, if it has a recorded position on that frame, then it returns that, otherwise it interpolates the position
		 * @param	_positions	The positions to read from
		 * @param	_frameIndex	The index of the frame, will be 0 at the first frame of the scene, regardless of which frame the scene starts on
		 * @return
		 */
		public function getInterpolatedPosition(_positions : Array, _frameIndex : Number) : Point {
			_frameIndex = MathUtil.clamp(_frameIndex, 0, _positions.length - 1);
			if (_positions[_frameIndex] != null) {
				return _positions[_frameIndex];
			}
			
			var positionBefore : Point;
			var positionAfter : Point;
			var offsetBefore : Number;
			var offsetAfter : Number;
			var i : Number;
			var frameIndex : Number;
			
			for (i = _frameIndex - 1; i >= _frameIndex - _positions.length; i--) {
				frameIndex = i >= 0 ? i : i + _positions.length;
				if (_positions[frameIndex] != null) {
					positionBefore = _positions[frameIndex];
					offsetBefore = i - _frameIndex;
					break;
				}
			}
			
			for (i = _frameIndex + 1; i < _frameIndex + _positions.length; i++) {
				frameIndex = i < _positions.length ? i : i - _positions.length;
				if (_positions[frameIndex] != null) {
					positionAfter = _positions[frameIndex];
					offsetAfter = i - _frameIndex;
					break;
				}
			}
			
			if (positionAfter == null) {
				return null;
			}
			
			var percentage : Number = MathUtil.getPercentage(0, offsetBefore, offsetAfter);
			var x : Number = MathUtil.lerp(positionBefore.x, positionAfter.x, percentage);
			var y : Number = MathUtil.lerp(positionBefore.y, positionAfter.y, percentage);
			
			return new Point(x, y);
		}
		
		public override function calculateDepth(_frameIndex : Number) : Number {
			var stimulation : Point = getInterpolatedPosition(stimulationPositions, _frameIndex);
			var base : Point = getInterpolatedPosition(basePositions, _frameIndex);
			var tip : Point = getInterpolatedPosition(tipPositions, _frameIndex);
			
			return calculateDepthFromPositions(stimulation, base, tip);
		}
		
		private function calculateDepthFromPositions(_stimulation : Point, _base : Point, _tip : Point) : Number {
			var angle : Number = MathUtil.angleBetween(_base, _tip);
			
			// We rotate the tip and stimulation points so that the tip is to the right of the base, at the same y position
			var rotatedTip : Point = MathUtil.rotatePoint(_tip, -angle, _base);
			var rotatedStimulation : Point = MathUtil.rotatePoint(_stimulation, -angle, _base);
			
			// Then we check where along the x axis the rotated stimulation point is, and use that get the "penetration" depth
			var depth : Number = MathUtil.getPercentage(rotatedStimulation.x, rotatedTip.x, _base.x);
			depth = Math.floor(depth * 1000) / 1000; // Reduces the number of decimals to 3
			return MathUtil.clamp(depth, 0, 1);
		}
		
		private function getMarkerPosition(_attachedTo : DisplayObject, _point : Point) : Point {
			return DisplayObjectUtil.localToGlobal(_attachedTo, _point.x, _point.y);
		}
	}
}