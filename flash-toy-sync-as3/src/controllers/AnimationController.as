package controllers {
	
	import core.DisplayObjectUtil;
	import core.KeyboardManager;
	import core.MovieClipUtil;
	import core.StageUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import global.GlobalEvents;
	import global.GlobalState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationController {
		
		private var globalState : GlobalState;
		
		private var panelContainer : MovieClip;
		private var animation : MovieClip;
		
		private var keyboardManager : KeyboardManager;
		
		// Additional states used for updating the global states
		private var selectedChildExpectedNextFrame : Number = -1;
		private var wasResumedAfterForceStop : Boolean = false;
		private var selectedChildParentChainLength : Number = -1;
		private var selectedChildPath : Array = null;
		
		public function AnimationController(_globalState : GlobalState, _panelContainer : MovieClip, _animation : MovieClip, _width : Number, _height : Number) {
			globalState = _globalState;
			panelContainer = _panelContainer;
			animation = _animation;
			
			keyboardManager = new KeyboardManager(_animation);
			
			keyboardManager.addShortcut(this, [Keyboard.ENTER], onForceStopShortcut);
			keyboardManager.addShortcut(this, [Keyboard.SPACE], onForceStopShortcut);
			keyboardManager.addShortcut(this, [Keyboard.SHIFT, Keyboard.LEFT], onGotoStartShortcut);
			keyboardManager.addShortcut(this, [Keyboard.SHIFT, Keyboard.RIGHT], onGotoEndShortcut);
			keyboardManager.addShortcut(this, [Keyboard.LEFT], onStepBackwardsShortcut);
			keyboardManager.addShortcut(this, [Keyboard.RIGHT], onStepForwardsShortcut);
			
			var isValidSize : Boolean = _width > 0 && _height > 0;
			var targetWidth : Number = isValidSize ? _width : StageUtil.getWidth();
			var targetHeight : Number = isValidSize ? _height : StageUtil.getHeight();
			
			globalState._animationWidth.setState(targetWidth);
			globalState._animationHeight.setState(targetHeight);
			
			if (isValidSize == false) {
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.RIGHT], onDecreaseSWFWidthShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.LEFT], onIncreaseSWFWidthShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.DOWN], onDecreaseSWFHeightShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.UP], onIncreaseSWFHeightShortcut);
			}
			
			GlobalEvents.childSelected.listen(this, onChildSelected);
		}
		
		public function onEnterFrame() : void {
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			var lastCurrentFrame : Number = GlobalState.currentFrame.state;
			
			if (selectedChild == null) {
				return;
			}
			
			// Handle when the selectedChild is no longer in the display list
			if (selectedChild != null && DisplayObjectUtil.getParents(selectedChild).length != selectedChildParentChainLength) {
				var childFromPath : DisplayObject = DisplayObjectUtil.getChildFromPath(animation, selectedChildPath);
				if (MovieClipUtil.isMovieClip(childFromPath) == true) {
					setSelectedChild(MovieClipUtil.objectAsMovieClip(childFromPath));
				} else {
					clearSelectedChild();
					return;
				}
			}
			
			var currentFrame : Number = selectedChild != null ? MovieClipUtil.getCurrentFrame(selectedChild) : -1;
			var isStopped : Boolean = currentFrame >= 0 && currentFrame == lastCurrentFrame;
			var isNotExpectedFrame : Boolean = selectedChildExpectedNextFrame >= 0 && currentFrame != lastCurrentFrame;
			var newIsPlayingState : Boolean = selectedChild != null && isStopped == false && GlobalState.isForceStopped.state == false;
			
			if (newIsPlayingState == false && GlobalState.isPlaying.state == true && GlobalState.isForceStopped.state == false) {
				globalState._stoppedAtFrame.setState(currentFrame);
			}
			
			globalState._isPlaying.setState(newIsPlayingState);
			
			if (lastCurrentFrame >= 0) {
				if (isNotExpectedFrame && currentFrame != selectedChildExpectedNextFrame && GlobalState.isForceStopped.state == false) {
					globalState._skippedFromFrame.setState(GlobalState.currentFrame.state);
					globalState._skippedToFrame.setState(currentFrame);
					globalState._stoppedAtFrame.setState(-1);
				}
				if (lastCurrentFrame == MovieClipUtil.getTotalFrames(selectedChild) && currentFrame == 1) {
					globalState._skippedFromFrame.setState(lastCurrentFrame);
					globalState._skippedToFrame.setState(currentFrame);
					globalState._stoppedAtFrame.setState(-1);
				}
			}
			
			globalState._currentFrame.setState(currentFrame);
			
			if (isStopped == true && wasResumedAfterForceStop == false) {
				selectedChildExpectedNextFrame = currentFrame;
			} else {
				selectedChildExpectedNextFrame = getNextPlayingFrame(selectedChild);
			}
			
			wasResumedAfterForceStop = false;
		}
		
		private function onChildSelected(_child : MovieClip) : void {
			setSelectedChild(_child);
		}
		
		private function onForceStopShortcut() : void {
			if (GlobalState.selectedChild.state == null) {
				return;
			}
			if (GlobalState.isForceStopped.state == false && GlobalState.isPlaying.state == false) {
				return;
			}
			
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			var wasForceStopped : Boolean = GlobalState.isForceStopped.state;
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(selectedChild);
			
			globalState._isForceStopped.setState(!wasForceStopped);
			
			if (wasForceStopped == true) {
				GlobalEvents.resumePlayingSelectedChild.emit();
				wasResumedAfterForceStop = true;
				selectedChildExpectedNextFrame = currentFrame + 1;
			} else {
				GlobalEvents.forceStopSelectedChild.emit();
				selectedChildExpectedNextFrame = currentFrame;
			}
		}
		
		private function onGotoEndShortcut() : void {
			var end : Number = Math.max(GlobalState.skippedFromFrame.state - 1, GlobalState.stoppedAtFrame.state);
			if (GlobalState.selectedChild.state == null || end < 0) {
				return;
			}
			
			globalState._isForceStopped.setState(true);
			selectedChildExpectedNextFrame = end;
			
			GlobalEvents.gotoFrame.emit(end);
		}
		
		private function onGotoStartShortcut() : void {
			if (GlobalState.selectedChild.state == null || GlobalState.skippedToFrame.state < 0) {
				return;
			}
			
			globalState._isForceStopped.setState(true);
			selectedChildExpectedNextFrame = GlobalState.skippedToFrame.state;
			
			GlobalEvents.gotoFrame.emit(GlobalState.skippedToFrame.state);
		}
		
		private function onStepBackwardsShortcut() : void {
			if (GlobalState.selectedChild.state == null) {
				return;
			}
			
			var currentFrame : Number = GlobalState.currentFrame.state;
			
			globalState._isForceStopped.setState(true);
			selectedChildExpectedNextFrame = currentFrame;
			
			if (currentFrame > 1) {
				GlobalEvents.stepFrames.emit(-1);
				selectedChildExpectedNextFrame = currentFrame - 1;
			}
		}
		
		private function onStepForwardsShortcut() : void {
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			if (selectedChild == null) {
				return;
			}
			
			var currentFrame : Number = GlobalState.currentFrame.state;
			var nextFrame : Number = getNextFrame(selectedChild);
			
			globalState._isForceStopped.setState(true);
			selectedChildExpectedNextFrame = currentFrame;
			
			if (currentFrame != nextFrame) {
				GlobalEvents.stepFrames.emit(1);
				selectedChildExpectedNextFrame = nextFrame;
			}
		}
		
		private function onDecreaseSWFWidthShortcut() : void {
			globalState._animationWidth.setState(GlobalState.animationWidth.state - 5);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onIncreaseSWFWidthShortcut() : void {
			globalState._animationWidth.setState(GlobalState.animationWidth.state + 5);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onDecreaseSWFHeightShortcut() : void {
			globalState._animationHeight.setState(GlobalState.animationHeight.state - 5);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onIncreaseSWFHeightShortcut() : void {
			globalState._animationHeight.setState(GlobalState.animationHeight.state + 5);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function clearSelectedChild() : void {
			globalState._selectedChild.setState(null);
			globalState._currentFrame.setState(-1);
			globalState._isPlaying.setState(false);
			globalState._isForceStopped.setState(false);
			globalState._skippedFromFrame.setState(-1);
			globalState._skippedToFrame.setState(-1);
			globalState._stoppedAtFrame.setState(-1);
			
			selectedChildExpectedNextFrame = -1;
			wasResumedAfterForceStop = false;
			selectedChildParentChainLength = -1;
			selectedChildPath = null;
		}
		
		private function setSelectedChild(_child : MovieClip) : void {
			clearSelectedChild();
			
			globalState._selectedChild.setState(_child);
			globalState._currentFrame.setState(MovieClipUtil.getCurrentFrame(_child));
			
			selectedChildParentChainLength = DisplayObjectUtil.getParents(_child).length;
			selectedChildPath = DisplayObjectUtil.getChildPath(animation, _child);
		}
		
		private function getNextFrame(_movieClip : MovieClip) : Number {
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(_movieClip);
			var totalFrames : Number = MovieClipUtil.getTotalFrames(_movieClip);
			return currentFrame == totalFrames ? totalFrames : currentFrame + 1;
		}
		
		private function getNextPlayingFrame(_movieClip : MovieClip) : Number {
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(_movieClip);
			var totalFrames : Number = MovieClipUtil.getTotalFrames(_movieClip);
			return currentFrame == totalFrames ? 1 : currentFrame + 1;
		}
	}
}