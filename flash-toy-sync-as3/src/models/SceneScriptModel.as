package models {
	
	import flash.geom.Point;
	import utils.ArrayUtil;
	import utils.SaveDataUtil;
	import utils.SceneScriptUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptModel {
		
		/** The scene this script is used for */
		protected var scene : SceneModel;
		
		/** The first recorded frame of the scene, which won't necessariliy be the same as the first inner frame of the scene */
		protected var firstRecordedInnerFrame : Number = -1;
		
		/** The screen position of the base of the "penis", on each frame in the scene */
		protected var basePositions : Vector.<Point>;
		/** The screen position where the stimulation takes place on the "penis", on each frame in the scene */
		protected var stimPositions : Vector.<Point>;
		/** The screen position of the tip of the "penis", on each frame in the scene */
		protected var tipPositions : Vector.<Point>;
		
		private var splitEventListener : Object;
		private var mergeEventListener : Object;
		
		public function SceneScriptModel(_scene : SceneModel) {
			scene = _scene;
			
			splitEventListener = scene.splitEvent.listen(this, onSceneSplit);
			mergeEventListener = scene.mergeEvent.listen(this, onSceneMerged);
			
			basePositions = new Vector.<Point>();
			tipPositions = new Vector.<Point>();
			stimPositions = new Vector.<Point>();
		}
		
		public function clone(_clonedScene : SceneModel) : SceneScriptModel {
			var clonedScript : SceneScriptModel = new SceneScriptModel(_clonedScene);
			
			clonedScript.firstRecordedInnerFrame = firstRecordedInnerFrame;
			clonedScript.basePositions = basePositions.slice();
			clonedScript.tipPositions = tipPositions.slice();
			clonedScript.stimPositions = stimPositions.slice();
			
			return clonedScript;
		}
		
		/**
		 * Adds a set of positions at a given frame to the script
		 * If a postion is null and there's already a position recorded for that frame, it won't overwrite the existing position
		 * @param	_frame	The current frame to record
		 * @param	_base	The base position for the "penis"
		 * @param	_stim	The position where the stimulation takes place on the "penis"
		 * @param	_tip	The tip position for the "penis"
		 */
		public function addPositions(_frame : Number, _base : Point, _stim : Point, _tip : Point) : void {			
			if (basePositions.length == 0) {
				for (var i : Number = 0; i < scene.getTotalInnerFrames(); i++) {
					basePositions.push(null);
					stimPositions.push(null);
					tipPositions.push(null);
				}
			}
			
			firstRecordedInnerFrame = scene.getInnerStartFrame();
			
			var lastFrameForPositions : Number = firstRecordedInnerFrame + (basePositions.length - 1);
			
			var totalFillBeginning : Number = Math.max(0, firstRecordedInnerFrame - scene.getInnerStartFrame());
			var totalFillEnd : Number = Math.max(0, scene.getInnerEndFrame() - lastFrameForPositions);
			
			fillInBlankPositionsAtBeginning(totalFillBeginning);
			fillInBlankPositionsAtEnd(totalFillEnd);
			
			var frameIndex : Number = _frame - firstRecordedInnerFrame;
			
			basePositions[frameIndex] = _base || basePositions[frameIndex];
			stimPositions[frameIndex] = _stim || stimPositions[frameIndex];
			tipPositions[frameIndex] = _tip || tipPositions[frameIndex];
		}
		
		public function trimPositions() : void {
			var start : Number = Math.max(0, scene.getInnerStartFrame() - firstRecordedInnerFrame);
			var end : Number = start + scene.getTotalInnerFrames();
			
			basePositions = basePositions.slice(start, end);
			stimPositions = stimPositions.slice(start, end);
			tipPositions = tipPositions.slice(start, end);
		}
		
		public function setBasePosition(_frame : Number, _position : Point) : void {
			var frameIndex : Number = _frame - firstRecordedInnerFrame;
			basePositions[frameIndex] = _position;
		}
		
		public function setStimPosition(_frame : Number, _position : Point) : void {
			var frameIndex : Number = _frame - firstRecordedInnerFrame;
			stimPositions[frameIndex] = _position;
		}
		
		public function setTipPosition(_frame : Number, _position : Point) : void {
			var frameIndex : Number = _frame - firstRecordedInnerFrame;
			tipPositions[frameIndex] = _position;
		}
		
		public function isComplete() : Boolean {
			var haveRecordedAllFrames : Boolean = firstRecordedInnerFrame == scene.getInnerStartFrame() && basePositions.length == scene.getTotalInnerFrames();
			if (haveRecordedAllFrames == false) {
				return false;
			}
			
			var totalNullBasePositions : Number = ArrayUtil.count(basePositions, null);
			var totalNullStimPositions : Number = ArrayUtil.count(stimPositions, null);
			var totalNullTipPositions : Number = ArrayUtil.count(tipPositions, null);
			
			var hasAtLeast1PositionOfEach : Boolean = totalNullBasePositions != basePositions.length && totalNullStimPositions != stimPositions.length && totalNullTipPositions != tipPositions.length;
			return hasAtLeast1PositionOfEach;
		}
		
		public function hasAnyRecordedPositions() : Boolean {
			return basePositions != null && basePositions.length > 0;
		}
		
		public function getBasePositions() : Vector.<Point> {
			return basePositions.slice();
		}
		
		public function getStimPositions() : Vector.<Point> {
			return stimPositions.slice();
		}
		
		public function getTipPositions() : Vector.<Point> {
			return tipPositions.slice();
		}
		
		public function isFrameWithinRecordedFrames(_frame : Number) : Boolean {
			var lastRecordedFrame : Number = firstRecordedInnerFrame + basePositions.length - 1;
			return basePositions.length > 0 && _frame >= firstRecordedInnerFrame && _frame <= lastRecordedFrame;
		}
		
		public function hasRecordedPositionOnFrame(_positions : Vector.<Point>, _frame : Number) : Boolean {
			var frameIndex : Number = _frame - firstRecordedInnerFrame;
			return _positions[frameIndex] != null;
		}
		
		public function getInterpolatedPosition(_positions : Vector.<Point>, _frame : Number) : Point {
			var frameIndex : Number = _frame - firstRecordedInnerFrame;
			return SceneScriptUtil.getInterpolatedPosition(_positions, frameIndex);
		}
		
		public function calculateDepths() : Vector.<Number> {
			var depths : Vector.<Number> = new Vector.<Number>();
			
			for (var i : Number = 0; i < basePositions.length; i++) {
				var base : Point = getInterpolatedPosition(basePositions, firstRecordedInnerFrame + i);
				var stim : Point = getInterpolatedPosition(stimPositions, firstRecordedInnerFrame + i);
				var tip : Point = getInterpolatedPosition(tipPositions, firstRecordedInnerFrame + i);
				var depth : Number = SceneScriptUtil.caclulateDepth(base, stim, tip);
				
				depths.push(depth);
			}
			
			return depths;
		}
		
		public function toSaveData() : Object {
			var saveData : Object = {};
			saveData.firstRecordedInnerFrame = firstRecordedInnerFrame;
			saveData.basePositions = SaveDataUtil.convertPointsToSaveData(basePositions);
			saveData.stimPositions = SaveDataUtil.convertPointsToSaveData(stimPositions);
			saveData.tipPositions = SaveDataUtil.convertPointsToSaveData(tipPositions);
			
			return saveData;
		}
		
		public static function fromSaveData(_saveData : Object, _scene : SceneModel) : SceneScriptModel {
			var script : SceneScriptModel = new SceneScriptModel(_scene);
			script.firstRecordedInnerFrame = _saveData.firstRecordedInnerFrame;
			script.basePositions = SaveDataUtil.getPointsFromSaveData(_saveData.basePositions);
			script.stimPositions = SaveDataUtil.getPointsFromSaveData(_saveData.stimPositions);
			script.tipPositions = SaveDataUtil.getPointsFromSaveData(_saveData.tipPositions);
			
			return script;
		}
		
		protected function destroy() : void {
			scene.mergeEvent.stopListening(mergeEventListener);
			scene.splitEvent.stopListening(splitEventListener);
		}
		
		private function onSceneSplit(_firstHalf : SceneModel) : void {
			if (basePositions.length == 0) {
				return;
			}
			
			firstRecordedInnerFrame = scene.getInnerStartFrame();
			trimPositions();
			
			var firstHalfScript : SceneScriptModel = _firstHalf.getPlugins().getScript();
			
			firstHalfScript.firstRecordedInnerFrame = _firstHalf.getInnerStartFrame();
			firstHalfScript.trimPositions();
		}
		
		private function onSceneMerged(_otherScene : SceneModel) : void {
			var otherScript : SceneScriptModel = _otherScene.getPlugins().getScript();
			if (otherScript.basePositions.length == 0) {
				return;
			}
			
			var totalFillBeginning : Number = Math.max(0, firstRecordedInnerFrame - _otherScene.getInnerStartFrame());
			
			fillInBlankPositionsAtBeginning(totalFillBeginning);
			
			if (otherScript.firstRecordedInnerFrame >= 0 && (otherScript.firstRecordedInnerFrame < firstRecordedInnerFrame || firstRecordedInnerFrame < 0)) {
				firstRecordedInnerFrame = otherScript.firstRecordedInnerFrame;
			}
			
			var i : Number;
			for (i = 0; i < totalFillBeginning; i++) {
				basePositions[i] = otherScript.basePositions[i];
				stimPositions[i] = otherScript.stimPositions[i];
				tipPositions[i] = otherScript.tipPositions[i];
			}
			
			var endFrame : Number = firstRecordedInnerFrame + basePositions.length - 1;
			var otherEndFrame : Number = otherScript.firstRecordedInnerFrame + otherScript.basePositions.length - 1;
			var totalFillEnd : Number = Math.max(0, otherEndFrame - endFrame);
			
			fillInBlankPositionsAtEnd(totalFillEnd);
			
			var startCopyFromFrame : Number = Math.max(endFrame + 1, otherScript.firstRecordedInnerFrame);
			var totalFramesToCopy : Number = (otherEndFrame - startCopyFromFrame) + 1;
			
			for (i = 0; i < totalFramesToCopy; i++) {
				var otherFrameIndex : Number = (startCopyFromFrame - otherScript.firstRecordedInnerFrame) + i;
				var frameIndex : Number = (startCopyFromFrame - firstRecordedInnerFrame) + i;
				
				basePositions[frameIndex] = otherScript.basePositions[otherFrameIndex];
				stimPositions[frameIndex] = otherScript.stimPositions[otherFrameIndex];
				tipPositions[frameIndex] = otherScript.tipPositions[otherFrameIndex];
			}
			
			otherScript.destroy();
		}
		
		private function fillInBlankPositionsAtBeginning(_totalBlankPositions : Number) : void {
			for (var i : Number = 0; i < _totalBlankPositions; i++) {
				basePositions.unshift(null);
				stimPositions.unshift(null);
				tipPositions.unshift(null);
			}
		}
		
		private function fillInBlankPositionsAtEnd(_totalBlankPositions : Number) : void {
			for (var i : Number = 0; i < _totalBlankPositions; i++) {
				basePositions.push(null);
				stimPositions.push(null);
				tipPositions.push(null);
			}
		}
	}
}