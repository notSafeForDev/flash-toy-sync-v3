package controllers {
	
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	
	import core.VersionUtil;
	import core.KeyboardManager;
	import core.StageUtil;
	
	import global.AnimationInfoState;
	import global.EditorState;
	import global.GlobalEvents;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationScalingController {
		
		private var animationInfoState : AnimationInfoState;
		
		private var keyboardManager : KeyboardManager;
		
		public function AnimationScalingController(_animationInfoState : AnimationInfoState, _animation : MovieClip, _width : Number, _height : Number) {
			animationInfoState = _animationInfoState;
			
			var isValidSize : Boolean = _width > 0 && _height > 0;
			var targetWidth : Number = isValidSize ? _width : StageUtil.getWidth();
			var targetHeight : Number = isValidSize ? _height : StageUtil.getHeight();
			
			animationInfoState._width.setValue(targetWidth);
			animationInfoState._height.setValue(targetHeight);
			
			keyboardManager = new KeyboardManager(_animation);
			
			// We only make it possible to resize it for AS2, as there doesn't seem to be a way to get an accurate stage for the animation in AS2
			if (VersionUtil.isActionscript3() == false && EditorState.isEditor.value == true) {
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.RIGHT], onDecreaseSWFWidthShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.LEFT], onIncreaseSWFWidthShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.DOWN], onDecreaseSWFHeightShortcut);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.UP], onIncreaseSWFHeightShortcut);
			}
		}
		
		private function onDecreaseSWFWidthShortcut() : void {
			animationInfoState._width.setValue(AnimationInfoState.width.value - 5);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onIncreaseSWFWidthShortcut() : void {
			animationInfoState._width.setValue(AnimationInfoState.width.value + 5);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onDecreaseSWFHeightShortcut() : void {
			animationInfoState._height.setValue(AnimationInfoState.height.value - 5);
			GlobalEvents.animationManualResize.emit();
		}
		
		private function onIncreaseSWFHeightShortcut() : void {
			animationInfoState._height.setValue(AnimationInfoState.height.value + 5);
			GlobalEvents.animationManualResize.emit();
		}
	}
}