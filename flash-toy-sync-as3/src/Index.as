package {
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.ui.Keyboard;

	import core.StateManager;
	import core.Debug;
	import core.KeyboardManager;
	import core.MovieClipUtil;
	import core.StageUtil;
	import core.MovieClipEvents;
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	import components.Borders;
	import components.ExternalSWF;
	import components.StageElementSelector;
	import components.HierarchyPanel;
	import components.DebugPanel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Index {
		
		private var globalStateManager : StateManager;
		private var globalState : GlobalState;
		
		private var container : MovieClip;
		private var externalSWF : ExternalSWF;
		private var animation : MovieClip;
		private var stageElementSelector : StageElementSelector;
		private var animationContainer : MovieClip;
		private var borders : Borders;
		private var stageElementSelectorOverlay : MovieClip;
		private var hierarchyPanel : HierarchyPanel;
		private var debugPanel : DebugPanel;
		private var keyboardManager : KeyboardManager;
	
		// Additional states used for updating the global states
		private var selectedChildExpectedNextFrame : Number = -1;
		private var wasResumedAfterForceStop : Boolean = false;
		private var frameWhenChildWasSelected : Number = -1;
		
		public function Index(_container : MovieClip, _animationPath : String) {
			if (_container == null) {
				throw new Error("Unable construct Index, the container is not valid");
			}
			
			globalStateManager = new StateManager();
			globalState = new GlobalState(globalStateManager);
			
			GlobalEvents.init();
			
			container = _container;
			animationContainer = MovieClipUtil.create(_container, "animationContainer");
			borders = new Borders(_container, 0x000000);
			stageElementSelectorOverlay = MovieClipUtil.create(_container, "stageElementSelectorOverlay");
			
			keyboardManager = new KeyboardManager(container);
			
			externalSWF = new ExternalSWF(_animationPath, animationContainer);
			externalSWF.onLoaded.listen(this, onSWFLoaded);
			externalSWF.onError.listen(this, onSWFError);
		}
		
		private function onSWFLoaded(_swf : MovieClip, _width : Number, _height : Number, _fps : Number) : void {
			StageUtil.setFrameRate(_fps);
			
			animation = _swf;
			
			stageElementSelector = new StageElementSelector(_swf, stageElementSelectorOverlay);
			
			hierarchyPanel = new HierarchyPanel(container, _swf);
			hierarchyPanel.excludeChildrenWithoutNestedAnimations = true;
			hierarchyPanel.onSelectChild.listen(this, onHierarchyPanelSelectChild);
			
			debugPanel = new DebugPanel(container);
			debugPanel.setPosition(700, 0);
			
			var isValidSize : Boolean = _width > 0 && _height > 0;
			var targetWidth : Number = isValidSize ? _width : StageUtil.getWidth();
			var targetHeight : Number = isValidSize ? _height : StageUtil.getHeight();
			
			if (isValidSize == false) {
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.RIGHT], onDecreaseSWFWidthShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.LEFT], onIncreaseSWFWidthShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.DOWN], onDecreaseSWFHeightShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.UP], onIncreaseSWFHeightShortcut);
			}
			
			// animation.gotoAndStop(1910); // midna-3x-pleasure before cum scene
			// animation.gotoAndStop(1230); // pleasure-bonbon before cum scene
			keyboardManager.addShortcut(this, [Keyboard.ENTER], onForceStopShortcut);
			keyboardManager.addShortcut(this, [Keyboard.LEFT], onStepFrameBackwardsShortcut);
			keyboardManager.addShortcut(this, [Keyboard.RIGHT], onStepFrameForwardsShortcut);
			
			globalState._animationWidth.setState(targetWidth);
			globalState._animationHeight.setState(targetHeight);
			
			// We add the onEnterFrame listener on the container, instead of the animation, for better compatibility with AS2
			// As the contents of _swf can be replaced by the loaded swf file
			MovieClipEvents.addOnEnterFrame(this, container, onEnterFrame);
		}
		
		private function onEnterFrame() : void {
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			var lastCurrentFrame : Number = GlobalState.currentFrame.state;
			
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
			if (selectedChild != null) {
				selectedChildExpectedNextFrame = (isStopped == true && wasResumedAfterForceStop == false) ? currentFrame : getNextPlayingFrame(selectedChild);
			}
			
			wasResumedAfterForceStop = false;
			
			var startTime : Number = Debug.getTime();
			globalStateManager.notifyListeners();
			var endTime : Number = Debug.getTime();
			// trace(endTime - startTime);
			
			GlobalEvents.enterFrame.emit();
		}
		
		private function onHierarchyPanelSelectChild(_child : MovieClip) : void {
			if (GlobalState.selectedChild.state == _child) {
				return;
			}
			
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(_child);
			
			globalState._selectedChild.setState(_child);
			globalState._currentFrame.setState(currentFrame);
			globalState._isPlaying.setState(false);
			globalState._isForceStopped.setState(false);
			globalState._skippedFromFrame.setState(-1);
			globalState._skippedToFrame.setState(-1);
			globalState._stoppedAtFrame.setState(-1);
			
			selectedChildExpectedNextFrame = -1; // Expect nothing, since we don't know if it's stopped or not
			frameWhenChildWasSelected = currentFrame;
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
		
		private function onStepFrameBackwardsShortcut() : void {
			if (GlobalState.selectedChild.state == null) {
				return;
			}
			
			var currentFrame : Number = GlobalState.currentFrame.state;
			
			globalState._isForceStopped.setState(true);
			selectedChildExpectedNextFrame = currentFrame;
			
			if (currentFrame > 1) {
				GlobalEvents.stepFrameBackwards.emit();
				selectedChildExpectedNextFrame = currentFrame - 1;
			}
		}
		
		private function onStepFrameForwardsShortcut() : void {
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			if (selectedChild == null) {
				return;
			}
			
			var currentFrame : Number = GlobalState.currentFrame.state;
			var nextFrame : Number = getNextFrame(selectedChild);
			
			globalState._isForceStopped.setState(true);
			selectedChildExpectedNextFrame = currentFrame;
			
			if (currentFrame != nextFrame) {
				GlobalEvents.stepFrameForwards.emit();
				selectedChildExpectedNextFrame = nextFrame;
			}
		}
		
		private function onDecreaseSWFWidthShortcut() : void {
			globalState._animationWidth.setState(GlobalState.animationWidth.state - 10);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onIncreaseSWFWidthShortcut() : void {
			globalState._animationWidth.setState(GlobalState.animationWidth.state + 10);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onDecreaseSWFHeightShortcut() : void {
			globalState._animationHeight.setState(GlobalState.animationHeight.state - 10);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onIncreaseSWFHeightShortcut() : void {
			globalState._animationHeight.setState(GlobalState.animationHeight.state + 10);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onSWFError(_error : Error) : void {
			trace(_error);
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