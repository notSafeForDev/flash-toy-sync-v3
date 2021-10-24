package components {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import core.DisplayObjectUtil;
	import core.MovieClipUtil;
	
	import global.EditorState;
	
	/**
	 * A class for keeping track of the active frames for a nested child and it's parents
	 * A scene is intended to start on the frame that the child previously skipped to, such as when a button in the animation causes the child to go to a different frame
	 * It's intended to end on the last consecutive frame the child reached while playing normally
	 * It also provides ways of playing and stopping the child along with it's parents
	 * The animation should not be stopped or resumed from outside of this component, while this component is being used,
	 * as that is likely to break this component
	 * @author notSafeForDev
	 */
	public class Scene {
		
		protected var path : Array = null;
		protected var frameRanges : Array = null;
		protected var firstStopFrames : Array = null;
		protected var lastPlayedFrames : Array = null;
		
		protected var _isForceStopped : Boolean = false;
		
		private var topParent : MovieClip = null;
		private var nestedChild : MovieClip = null;
		
		public var isTemporary : Boolean = false;
		
		/**
		 * Requires init to be called as well
		 * @param	_topParent	The external swf
		 */
		public function Scene(_topParent : MovieClip, _nestedChildPath : Array) {
			topParent = _topParent;
			path = _nestedChildPath.slice();
			
			// It's important that these are set as empty arrays in the constructor, rather than before,
			// Otherwise all instances of this class shares the same array instances
			// TODO: Add a warning for this in the transpiler, so that mutable objects such as arrays can't be assigned before the constructor
			frameRanges = [];
			firstStopFrames = [];
			lastPlayedFrames = [];
			
			var totalElementsInPath : Number = path.length + 1; // The root is not included
			
			for (var i : Number = 0; i < totalElementsInPath; i++) {
				frameRanges.push({min: -1, max: -1});
				// We use -1 instead of the currentFrame, since update will be called on the same frame as init
				lastPlayedFrames.push(-1);
				firstStopFrames.push(-1);
			}
		}
		
		public function toSaveData() : Object {
			var saveFrameRanges : Array = [];
			for (var i : Number = 0; i < frameRanges.length; i++) {
				saveFrameRanges.push({min: frameRanges[i].min, max: frameRanges[i].max});
			}
			
			return {
				path: path.slice(),
				frameRanges: saveFrameRanges,
				firstStopFrames: firstStopFrames.slice(),
				lastPlayedFrames: lastPlayedFrames.slice()
			}
		}
		
		public static function fromSaveData(_topParent : MovieClip, _saveData : Object) : Scene {
			var scene : Scene = new Scene(_topParent, _saveData.path.slice());
			scene.firstStopFrames = _saveData.firstStopFrames.slice();
			scene.lastPlayedFrames = _saveData.lastPlayedFrames.slice();
			scene.frameRanges = [];
			
			for (var i : Number = 0; i < _saveData.frameRanges.length; i++) {
				scene.frameRanges.push({min: _saveData.frameRanges[i].min, max: _saveData.frameRanges[i].max});
			}
			
			return scene;
		}
		
		public function merge(_other : Scene) : void {
			for (var i : Number = 0; i < frameRanges.length; i++) {
				frameRanges[i].min = Math.min(frameRanges[i].min, _other.frameRanges[i].min);
				frameRanges[i].max = Math.max(frameRanges[i].max, _other.frameRanges[i].max);
				firstStopFrames[i] = Math.max(firstStopFrames[i], _other.firstStopFrames[i]);
			}
		}
		
		public function clone() : Scene {
			var cloned : Scene = new Scene(topParent, path.slice());
			
			cloned.firstStopFrames = firstStopFrames.slice();
			cloned.lastPlayedFrames = lastPlayedFrames.slice();
			cloned.frameRanges = [];
			
			for (var i : Number = 0; i < frameRanges.length; i++) {
				cloned.frameRanges.push({min: frameRanges[i].min, max: frameRanges[i].max});
			}
			
			return cloned;
		}
		
		public function intersects(_scene : Scene) : Boolean {
			if (path.join(",") != _scene.path.join(",")) {
				return false;
			}
			
			for (var i : Number = 0; i < frameRanges.length; i++) {
				if (rangesIntersects(frameRanges[i].min, frameRanges[i].max, _scene.frameRanges[i].min, _scene.frameRanges[i].max) == false) {
					return false;
				}
			}
			
			return true;
		}
		
		/**
		 * This should be called on each frame after the Scene have been initialized, 
		 * in order to accurately update information about the scene.
		 * The animation should not be be stopped or resumed from outside of this component
		 * @param	_nestedChild	The nested child within the external swf 
		 */
		public function update(_nestedChild : MovieClip) : void {
			if (_isForceStopped == true || EditorState.isEditor.value == false) {
				return;
			}
			
			var childList : Array = getChildList(_nestedChild);
			
			for (var i : Number = 0; i < childList.length; i++) {
				var currentFrame : Number = MovieClipUtil.getCurrentFrame(childList[i]);
				var frameRange : Object = frameRanges[i];
				var haveBeenInitialized : Boolean = frameRange.min >= 0;
				
				if (haveBeenInitialized == false) {
					frameRange.max = currentFrame;
					frameRange.min = currentFrame;
				}
				
				frameRange.max = Math.max(currentFrame, frameRange.max);
				frameRange.min = Math.min(currentFrame, frameRange.min);
				
				if (currentFrame == lastPlayedFrames[i] && firstStopFrames[i] < 0) {
					firstStopFrames[i] = currentFrame;
				}
				
				lastPlayedFrames[i] = currentFrame;
			}
		}
		
		public function isForceStopped() : Boolean {
			return _isForceStopped;
		}
		
		public function exitScene(_nestedChild : MovieClip) : void {
			var isInDisplayList : Boolean = DisplayObjectUtil.getChildPath(topParent, _nestedChild) != null;
			if (isInDisplayList == true && _isForceStopped == true) {
				setPlaying(_nestedChild, true);
			}
			_isForceStopped = false;
		}
		
		public function isStopped(_nestedChild : MovieClip) : Boolean {
			var stoppedFrame : Number = firstStopFrames[firstStopFrames.length - 1];
			return _isForceStopped || MovieClipUtil.getCurrentFrame(_nestedChild) == stoppedFrame;
		}
		
		public function isLoop() : Boolean {
			var stoppedFrame : Number = firstStopFrames[firstStopFrames.length - 1];
			return stoppedFrame < 0;
		}
		
		public function setFirstFrame(_frame : Number) : void {
			if (_frame > frameRanges[frameRanges.length - 1].max) {
				throw new Error("Unable to set first frame, the frame number has to be less or equal to the last frame");
			}
			frameRanges[frameRanges.length - 1].min = _frame;
		}
		
		public function setLastFrame(_frame : Number) : void {
			if (_frame < frameRanges[frameRanges.length - 1].min) {
				throw new Error("Unable to set last frame, the frame number has to be equal or greater than the first frame");
			}
			frameRanges[frameRanges.length - 1].max = _frame;
		}
		
		public function getFirstFrame() : Number {
			return frameRanges[frameRanges.length - 1].min;
		}
		
		public function getFirstFrames() : Array {
			var firstFrames : Array = [];
			for (var i : Number = 0; i < frameRanges.length; i++) {
				firstFrames.push(frameRanges[i].min);
			}
			return firstFrames;
		}
		
		public function getLastFrame() : Number {
			return frameRanges[frameRanges.length - 1].max;
		}
		
		public function getLastFrames() : Array {
			var lastFrames : Array = [];
			for (var i : Number = 0; i < frameRanges.length; i++) {
				lastFrames.push(frameRanges[i].max);
			}
			return lastFrames;
		}
		
		public function getCurrentHierarchyFrames(_nestedChild : MovieClip) : Array {
			var childList : Array = getChildList(_nestedChild);
			if (childList == null) {
				return null;
			}
			
			var hierarchyFrames : Array = [];
			for (var i : Number = 0; i < childList.length; i++) {
				hierarchyFrames.push(MovieClipUtil.getCurrentFrame(childList[i]));
			}
			
			return hierarchyFrames;
		}
		
		public function getPath() : Array {
			return path;
		}
		
		public function isFrameInScene(_path : Array, _frames : Array) : Boolean {
			if (_path.join(",") != path.join(",")) {
				return false;
			}
			
			for (var i : Number = 0; i < frameRanges.length; i++) {
				if (_frames[i] < frameRanges[i].min || _frames[i] > frameRanges[i].max) {
					return false;
				}
			}
			
			return true;
		}
		
		public function isAtScene(_nestedChild : MovieClip, _frameOffset : Number) : Boolean {
			var childList : Array = getChildList(_nestedChild);
			
			if (childList == null || childList.length != frameRanges.length) {
				return false;
			}
			
			for (var i : Number = 0; i < childList.length; i++) {
				var frameRange : Object = frameRanges[i];
				var currentFrame : Number = MovieClipUtil.getCurrentFrame(childList[i]);
				
				if (i == childList.length - 1) {
					currentFrame += _frameOffset;
				}
				if (currentFrame < frameRange.min || currentFrame > frameRange.max) {
					return false;
				}
			}
			
			return true;
		}
		
		public function isActive() : Boolean {
			var topParentCurrentFrame : Number = MovieClipUtil.getCurrentFrame(topParent);
			if (topParentCurrentFrame < frameRanges[0].min || topParentCurrentFrame > frameRanges[0].max) {
				return false;
			}
			
			var childFromPath : DisplayObject = DisplayObjectUtil.getChildFromPath(topParent, path);
			if (childFromPath == null) {
				return false;
			}
			
			return isAtScene(MovieClipUtil.objectAsMovieClip(childFromPath), 0);
		}
		
		/**
		 * Stop the nestedChild and all of it's parents
		 * Should only be called when it's currently playing this scene
		 * @param	_nestedChild	The nested child within the external swf 
		 */
		public function stop(_nestedChild : MovieClip) : void {
			setPlaying(_nestedChild, false);
		}
		
		/**
		 * Play the nested child and any of it's parents that are supposed to be playing at this point
		 * Should only be called when it's currently on a frame of this scene
		 * @param	_nestedChild	The nested child within the external swf 
		 */
		public function play(_nestedChild : MovieClip) : void {
			setPlaying(_nestedChild, true);
		}
		
		public function playFromStart() : void {
			gotoFrames(getFirstFrames(), true);
		}
		
		public function stopAtStart() : void {
			gotoFrames(getFirstFrames(), false);
		}
		
		public function playFromFrames(_frames : Array) : void {
			gotoFrames(_frames, true);
		}
		
		public function stopAtFrames(_frames : Array) : void {
			gotoFrames(_frames, false);
		}
		
		public function gotoAndPlay(_nestedChild : MovieClip, _frame : Number) : void {
			_nestedChild.gotoAndStop(_frame);
			// In case we went to a frame that includes code which changes the frame, 
			// make sure the child is still in the display list
			if (DisplayObjectUtil.getParent(_nestedChild) != null) { 
				setPlaying(_nestedChild, true);
			}
		}
		
		public function gotoAndStop(_nestedChild : MovieClip, _frame : Number) : void {
			_nestedChild.gotoAndStop(_frame);
			// In case we went to a frame that includes code which changes the frame, 
			// make sure the child is still in the display list
			if (DisplayObjectUtil.getParent(_nestedChild) != null) { 
				setPlaying(_nestedChild, false);
			}
		}
		
		private function setPlaying(_nestedChild : MovieClip, _shouldPlay : Boolean) : void {
			var childList : Array = getChildList(_nestedChild);
			
			for (var i : Number = 0; i < childList.length; i++) {
				var child : MovieClip = childList[i];
				var firstStopFrame : Number = firstStopFrames[i];
				var currentFrame : Number = MovieClipUtil.getCurrentFrame(child);
				
				// If we stop, step back 1 frame and play again, it may consider that to be the frame where the animation is supposed to be stopped,
				// so by clearing the lastPlayedFrame, we avoid issues like that
				lastPlayedFrames[i] = -1;
				
				if (_shouldPlay == false || currentFrame == firstStopFrame) { // TODO: Perhaps make it an array of stopped frames
					child.stop();
				} else {
					child.play();
				}
			}
			
			_isForceStopped = _shouldPlay == false;
		}
		
		private function gotoFrames(_frames : Array, _shouldPlay : Boolean) : void {			
			for (var i : Number = 0; i < frameRanges.length; i++) {
				var child : MovieClip;
				var frameRange : Object = frameRanges[i];
				var stopFrame : Number = firstStopFrames[i];
				
				if (_frames[i] < frameRange.min || _frames[i] > frameRange.max) {
					throw new Error("Unable to goto frames, the frame: " + _frames[i] + " is out of the range: min: " + frameRange.min + " and max: " + frameRange.max);
				}
				
				if (i == 0) {
					child = topParent;
				} else {
					var currentPath : Array = path.slice(0, i);
					var displayObject : DisplayObject = DisplayObjectUtil.getChildFromPath(topParent, currentPath);
					child = MovieClipUtil.objectAsMovieClip(displayObject);
				}
				
				if (_shouldPlay == false || frameRange.min == frameRange.max || _frames[i] == stopFrame) {
					child.gotoAndStop(_frames[i]);
				} else {
					child.gotoAndPlay(_frames[i]);
				}
			}
			
			_isForceStopped = _shouldPlay == false;
		}
		
		/**
		 * Get a list of children, starting from the root of the external swf
		 * If both the root and nestedChild is the same, it will just return an array including the nestedChild
		 * @param	_nestedChild	A nested child within the root
		 * @return	An array of children
		 */
		protected function getChildList(_nestedChild : MovieClip) : Array {
			var childList : Array = [_nestedChild];
			
			var child : DisplayObject = _nestedChild;
			
			while (true) {
				if (child == topParent) {
					break;
				}
				var parent : DisplayObjectContainer = DisplayObjectUtil.getParent(child);
				if (parent == null) {
					return null;
				}
				if (parent != null) {
					child = parent;
					childList.push(parent);
				}
			}
			
			childList.reverse();
			return childList;
		}
		
		private function rangesIntersects(_aMin : Number, _aMax : Number, _bMin : Number, _bMax : Number) : Boolean {
			return (
				(_aMin >= _bMin && _aMin <= _bMax) || 
				(_aMax >= _bMin && _aMax <= _bMax) || 
				(_bMin >= _aMin && _bMin <= _aMax) ||
				(_bMax >= _aMin && _bMax <= _aMax)
			);
		}
	}
}