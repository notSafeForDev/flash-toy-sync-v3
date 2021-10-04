package {
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import core.Debug;
	import core.KeyboardManager;
	import core.MovieClipUtil;
	import core.StageUtil;
	import core.MovieClipEvents;
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	import components.Borders;
	import components.HierarchyPanel;
	import components.ExternalSWF;
	import components.StageElementSelector;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Index {
		
		private var container : MovieClip;
		private var externalSWF : ExternalSWF;
		private var animation : MovieClip;
		private var stageElementSelector : StageElementSelector;
		private var animationContainer : MovieClip;
		private var borders : Borders;
		private var stageElementSelectorOverlay : MovieClip;
		private var hierarchyPanel : HierarchyPanel;
		private var keyboardManager : KeyboardManager;
		
		public function Index(_container : MovieClip, _animationPath : String) {
			if (_container == null) {
				throw new Error("Unable construct Index, the container is not valid");
			}
			
			GlobalState.init();
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
			
			GlobalState.animationWidth.setState(targetWidth);
			GlobalState.animationHeight.setState(targetHeight);
			
			// We add the onEnterFrame listener on the container, instead of the animation, for better compatibility with AS2
			// As the contents of _swf can be replaced by the loaded swf file
			MovieClipEvents.addOnEnterFrame(this, container, onEnterFrame);
		}
		
		private function onHierarchyPanelSelectChild(_child : MovieClip) : void {
			if (GlobalState.selectedChild.getState() == _child) {
				return;
			}
			
			GlobalState.selectedChild.setState(_child);
			GlobalState.selectedChildCurrentFrame.setState(MovieClipUtil.getCurrentFrame(_child));
			GlobalState.isForceStopped.setState(false);
		}
		
		private function onForceStopShortcut() : void {
			if (GlobalState.selectedChild.getState() != null) {
				var isForceStopped : Boolean = GlobalState.isForceStopped.getState();
				GlobalState.isForceStopped.setState(!isForceStopped);
				if (isForceStopped == true ) {
					GlobalEvents.resumePlayingSelectedChild.emit();
				} else {
					GlobalEvents.forceStopSelectedChild.emit();
				}
			}
		}
		
		private function onStepFrameBackwardsShortcut() : void {
			if (GlobalState.selectedChild.getState() != null) {
				GlobalState.isForceStopped.setState(true);
				GlobalEvents.stepFrameBackwards.emit();
			}
		}
		
		private function onStepFrameForwardsShortcut() : void {
			if (GlobalState.selectedChild.getState() != null) {
				GlobalState.isForceStopped.setState(true);
				GlobalEvents.stepFrameForwards.emit();
			}
		}
		
		private function onDecreaseSWFWidthShortcut() : void {
			GlobalState.animationWidth.setState(GlobalState.animationWidth.getState() - 10);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onIncreaseSWFWidthShortcut() : void {
			GlobalState.animationWidth.setState(GlobalState.animationWidth.getState() + 10);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onDecreaseSWFHeightShortcut() : void {
			GlobalState.animationHeight.setState(GlobalState.animationHeight.getState() - 10);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onIncreaseSWFHeightShortcut() : void {
			GlobalState.animationHeight.setState(GlobalState.animationHeight.getState() + 10);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onSWFError(_error : Error) : void {
			trace(_error);
		}
		
		private function onEnterFrame() : void {
			GlobalEvents.enterFrame.emit();
			
			var selectedChild : MovieClip = GlobalState.selectedChild.getState();
			var currentFrame : Number = selectedChild != null ? MovieClipUtil.getCurrentFrame(selectedChild) : -1;
			GlobalState.selectedChildCurrentFrame.setState(currentFrame);
			
			var startTime : Number = Debug.getTime();
			GlobalState.notifyListeners();
			var endTime : Number = Debug.getTime();
			// trace(endTime - startTime);
		}
	}
}