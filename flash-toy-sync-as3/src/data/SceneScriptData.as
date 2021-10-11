package data {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import core.DisplayObjectUtil;
	import core.MovieClipUtil;
	
	import global.GlobalState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptData {
		
		private var animationRootPath : Array = null;
		private var startRootFrame : Number = -1;
		/** An array where each index represtents a displayObject, from topParent down to and including the animationRoot. With each object storing the min and max frame where the scene takes place */
		private var frameRanges : Array = null;
		private var depthsAtFrames : Array = null;
		
		public function SceneScriptData(_topParent : MovieClip, _animationRootPath : Array) {
			animationRootPath = _animationRootPath;
		}
		
		public static function fromGlobalState(_topParent : MovieClip) : SceneScriptData {
			var animationRootPath : Array = DisplayObjectUtil.getChildPath(_topParent, GlobalState.selectedChild.state);
			return new SceneScriptData(_topParent, animationRootPath);
		}
		
		private function initializeNewScene(_topParent : MovieClip) : void {
			var animationRoot : DisplayObject = DisplayObjectUtil.getChildFromPath(_topParent, animationRootPath);
			var parents : Array = DisplayObjectUtil.getParents(animationRoot).slice(0, animationRootPath.length);
			
			depthsAtFrames = [];
			frameRanges = [];
			
			var childList : Array = getChildList(_topParent, MovieClipUtil.objectAsMovieClip(animationRoot));
			
			for (var i : Number = 0; i < childList.length; i++) {
				var currentFrame : Number = MovieClipUtil.getCurrentFrame(childList[i]);
				var frameRange : Object = {
					min: currentFrame,
					max: currentFrame
				}
				frameRanges.push(frameRange);
			}
		}
		
		/**
		 * Get a list of children, starting from the topParent, down to the animationRoot
		 * If both the topParent and animationRoot is the same, it will just return an array including the animationRoot
		 * @param	_topParent		The root of the external swf
		 * @param	_animationRoot	The movieClip that we get the scene start, current and end frame from
		 * @return	An array of children
		 */
		protected function getChildList(_topParent : MovieClip, _animationRoot : MovieClip) : Array {
			var childList : Array = [_animationRoot];
			
			var child : DisplayObject = _animationRoot;
			
			while (true) {
				if (child == _topParent) {
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
		
		public function initializeExistingScene(_startRootFrame : Number, _parentFrameRanges : Array, _depthsAtFrames : Array) : void {
			startRootFrame = _startRootFrame;
			frameRanges = _parentFrameRanges;
			depthsAtFrames = _depthsAtFrames;
		}
		
		public function updateRecording(_topParent : MovieClip, _depth : Number) : void {
			var animationRoot : MovieClip = GlobalState.selectedChild.state;
			var currentRootFrame : Number = MovieClipUtil.getCurrentFrame(animationRoot);
			if (startRootFrame == -1) {
				startRootFrame = currentRootFrame;
				initializeNewScene(_topParent);
			}
			
			if (currentRootFrame < startRootFrame) {
				var error : String = "Unable to update scene script recording, " + 
					"the current frame index of the animation root is less than the start frame index for the scene. " +
					"Make sure that the first time updateRecording is called, that it is on the first intended frame of the scene";
				throw new Error(error);
			}
			
			var frameIndex : Number = currentRootFrame - startRootFrame;
			if (frameIndex >= depthsAtFrames.length) {
				depthsAtFrames.push(_depth);
			} else {
				depthsAtFrames[frameIndex] = _depth;
			}
			
			var childList : Array = getChildList(_topParent, animationRoot);
			
			for (var i : Number = 0; i < childList.length; i++) {
				var currentFrame : Number = MovieClipUtil.getCurrentFrame(childList[i]);
				var frameRange : Object = frameRanges[i];
				if (currentFrame > frameRange.max) {
					frameRange.max = currentFrame;
				}
				if (currentFrame < frameRange.min) {
					frameRange.min = currentFrame;
				}
			}
		}
		
		public function isAtScene(_topParent : MovieClip) : Boolean {
			if (animationRootPath == null) {
				return false;
			}
			
			var animationRoot : DisplayObject = DisplayObjectUtil.getChildFromPath(_topParent, animationRootPath);
			if (animationRoot == null) {
				return false;
			}
			
			var childList : Array = getChildList(_topParent, MovieClipUtil.objectAsMovieClip(animationRoot));
			
			for (var i : Number = 0; i < childList.length; i++) {
				var frameRange : Object = frameRanges[i];
				var currentFrame : Number = MovieClipUtil.getCurrentFrame(childList[i]);
				if (currentFrame < frameRange.min || currentFrame > frameRange.max) {
					return false;
				}
			}
			
			return true;
		}
		
		public function getDepths() : Array {
			return depthsAtFrames.slice();
		}
		
		public function getStartRootFrame() : Number {
			return startRootFrame;
		}
	}
}