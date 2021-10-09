package {
	
	import core.VersionUtil;
	import core.stateTypes.DisplayObjectState;
	import core.stateTypes.PointState;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	import core.DisplayObjectUtil;
	import core.StateManager;
	import core.Debug;
	import core.KeyboardManager;
	import core.MovieClipUtil;
	import core.StageUtil;
	import core.MovieClipEvents;
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	import components.ScriptMarkers;
	import components.ScriptingPanel;
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
		// Remove extra s later
		/* [Embed(source = "../assets/Monoid-Regular.ttf", fontName = "MonoidRegular", embedAsCFF = "false", mimeType="application/x-font")]
		private var monoidRegular : Classs;
		
		[Embed(source = "../assets/Monoid-Bold.ttf", fontName = "MonoidBold", embedAsCFF = "false", mimeType="application/x-font")]
		private var monoidBold : Classs; */
		
		private var globalStateManager : StateManager;
		private var globalState : GlobalState;
		
		private var container : MovieClip;
		private var externalSWF : ExternalSWF;
		private var animation : MovieClip;
		private var stageElementSelector : StageElementSelector;
		private var animationContainer : MovieClip;
		private var borders : Borders;
		private var stageElementSelectorOverlay : MovieClip;
		private var scriptMarkers : ScriptMarkers;
		private var hierarchyPanel : HierarchyPanel;
		private var debugPanel : DebugPanel;
		private var scriptingPanel : ScriptingPanel;
		private var keyboardManager : KeyboardManager;
	
		// Additional states used for updating the global states
		private var selectedChildExpectedNextFrame : Number = -1;
		private var wasResumedAfterForceStop : Boolean = false;
		private var frameWhenChildWasSelected : Number = -1;
		private var selectedChildParentChainLength : Number = -1;
		private var clickedChildParentChainLength : Number = -1;
		
		public function Index(_container : MovieClip, _animationPath : String) {
			if (_container == null) {
				throw new Error("Unable construct Index, the container is not valid");
			}
			
			GlobalEvents.init();
			
			// MovieClipEvents.addOnEnterFrame(this, _container, onEnterFrame);
			
			globalStateManager = new StateManager();
			globalState = new GlobalState(globalStateManager);
			
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
			stageElementSelector.onSelectChild.listen(this, onStageElementSelectorSelectChild);
			
			scriptMarkers = new ScriptMarkers(container);
			scriptMarkers.onMovedStimulationMarker.listen(this, onMovedStimulationScriptMarker);
			scriptMarkers.onMovedBaseMarker.listen(this, onMovedBaseScriptMarker);
			scriptMarkers.onMovedTipMarker.listen(this, onMovedTipScriptMarker);
			
			hierarchyPanel = new HierarchyPanel(container, _swf);
			hierarchyPanel.excludeChildrenWithoutNestedAnimations = true;
			hierarchyPanel.onSelectChild.listen(this, onHierarchyPanelSelectChild);
			
			debugPanel = new DebugPanel(container);
			debugPanel.setPosition(700, 0);
			
			scriptingPanel = new ScriptingPanel(container);
			scriptingPanel.setPosition(700, 300);
			scriptingPanel.onAttachStimulationMarker.listen(this, onScriptingPanelAttachStimulationMarker);
			scriptingPanel.onAttachBaseMarker.listen(this, onScriptingPanelAttachBaseMarker);
			scriptingPanel.onAttachTipMarker.listen(this, onScriptingPanelAttachTipMarker);
			
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
			// animation.gotoAndStop(256); // midna-3x-pleasure menu
			
			keyboardManager.addShortcut(this, [Keyboard.ENTER], onForceStopShortcut);
			keyboardManager.addShortcut(this, [Keyboard.SPACE], onForceStopShortcut);
			
			keyboardManager.addShortcut(this, [Keyboard.SHIFT, Keyboard.LEFT], onGotoStartShortcut);
			keyboardManager.addShortcut(this, [Keyboard.SHIFT, Keyboard.RIGHT], onGotoEndShortcut);
			keyboardManager.addShortcut(this, [Keyboard.LEFT], onStepBackwardsShortcut);
			keyboardManager.addShortcut(this, [Keyboard.RIGHT], onStepForwardsShortcut);
			
			globalState._animationWidth.setState(targetWidth);
			globalState._animationHeight.setState(targetHeight);
			
			// We add the onEnterFrame listener on the container, instead of the animation, for better compatibility with AS2
			// As the contents of _swf can be replaced by the loaded swf file
			MovieClipEvents.addOnEnterFrame(this, container, onEnterFrame);
		}
		
		public function onEnterFrame() : void {
			if (animation == null) {
				return;
			}
			
			updateSelectedChildStates();
			
			var clickedChild : DisplayObject = GlobalState.clickedChild.state;
			
			if (clickedChild != null && DisplayObjectUtil.getParent(clickedChild) == null) {
				globalState._clickedChild.setState(null);
			}
			
			wasResumedAfterForceStop = false;
			
			var startTime : Number = Debug.getTime();
			globalStateManager.notifyListeners();
			GlobalEvents.enterFrame.emit();
			var endTime : Number = Debug.getTime();
			// trace(endTime - startTime);
		}
		
		private function updateSelectedChildStates() : void {
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			var lastCurrentFrame : Number = GlobalState.currentFrame.state;
			
			if (selectedChild == null) {
				return;
			}
			
			if (selectedChild != null && DisplayObjectUtil.getParent(selectedChild) == null) {
				globalState._selectedChild.setState(null);
				globalState._currentFrame.setState(-1);
				globalState._skippedFromFrame.setState(-1);
				globalState._skippedToFrame.setState(-1);
				globalState._stoppedAtFrame.setState(-1);
				return;
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
		}
		
		private function onScriptingPanelAttachStimulationMarker() : void {
			attachScriptMarker(globalState._stimulationMarkerAttachedTo, globalState._stimulationMarkerPoint);
		}
		
		private function onScriptingPanelAttachBaseMarker() : void {
			attachScriptMarker(globalState._baseMarkerAttachedTo, globalState._baseMarkerPoint);
		}
		
		private function onScriptingPanelAttachTipMarker() : void {
			attachScriptMarker(globalState._tipMarkerAttachedTo, globalState._tipMarkerPoint);
		}
		
		private function attachScriptMarker(_attachedToState : DisplayObjectState, _pointState : PointState) : void {
			var child : DisplayObject = GlobalState.clickedChild.state || GlobalState.selectedChild.state;
			if (child == null) {
				return;
			}
			
			var bounds : Rectangle = DisplayObjectUtil.getBounds(child, container);
			var centerX : Number = bounds.x + bounds.width / 2;
			var centerY : Number = bounds.y + bounds.height / 2;
			var point : Point = DisplayObjectUtil.globalToLocal(child, centerX, centerY);
			
			_attachedToState.setState(child);
			_pointState.setState(point);
		}
		
		private function onMovedStimulationScriptMarker(_point : Point) : void {
			globalState._stimulationMarkerPoint.setState(_point);
		}
		
		private function onMovedBaseScriptMarker(_point : Point) : void {
			globalState._baseMarkerPoint.setState(_point);
		}
		
		private function onMovedTipScriptMarker(_point : Point) : void {
			globalState._tipMarkerPoint.setState(_point);
		}
		
		private function onStageElementSelectorSelectChild(_child : DisplayObject) : void {
			var parents : Array = DisplayObjectUtil.getParents(_child);
			clickedChildParentChainLength = parents.length;
			globalState._clickedChild.setState(_child);
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
			selectedChildParentChainLength = DisplayObjectUtil.getParents(_child).length;
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