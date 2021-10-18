package controllers {
	
	import core.VersionUtil;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	
	import core.KeyboardManager;
	import core.StageUtil;
	
	import global.GlobalState;
	import global.GlobalEvents;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationScalingController {
		
		private var globalState : GlobalState;
		
		private var keyboardManager : KeyboardManager;
		
		public function AnimationScalingController(_globalState : GlobalState, _animation : MovieClip, _width : Number, _height : Number) {
			globalState = _globalState;
			
			var isValidSize : Boolean = _width > 0 && _height > 0;
			var targetWidth : Number = isValidSize ? _width : StageUtil.getWidth();
			var targetHeight : Number = isValidSize ? _height : StageUtil.getHeight();
			
			globalState._animationWidth.setState(targetWidth);
			globalState._animationHeight.setState(targetHeight);
			
			keyboardManager = new KeyboardManager(_animation);
			
			if (VersionUtil.isActionscript3() == false && GlobalState.isEditor.state == true) {
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.RIGHT], onDecreaseSWFWidthShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.LEFT], onIncreaseSWFWidthShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.DOWN], onDecreaseSWFHeightShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.UP], onIncreaseSWFHeightShortcut);
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
	}
}