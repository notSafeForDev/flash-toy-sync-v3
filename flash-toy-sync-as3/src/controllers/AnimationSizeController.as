package controllers {
	
	import components.KeyboardInput;
	import flash.ui.Keyboard;
	import states.AnimationSizeStates;
	import ui.Shortcuts;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationSizeController {
		
		private var animationSizeStates : AnimationSizeStates;
		
		public function AnimationSizeController(_animationSizeStates : AnimationSizeStates) {
			animationSizeStates = _animationSizeStates;
			
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.increaseAnimationWidth, this, onIncreaseWidthShortcut, null);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.decreaseAnimationWidth, this, onDecreaseWidthShortcut, null);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.increaseAnimationHeight, this, onIncreaseHeightShortcut, null);
			KeyboardInput.addShortcut(Shortcuts.EDITOR_ONLY, Shortcuts.decreaseAnimationHeight, this, onDecreaseHeightShortcut, null);
		}
		
		public function update() : void {
			// Do nothing
		}
		
		private function onIncreaseWidthShortcut() : void {
			animationSizeStates._width.setValue(AnimationSizeStates.width.value + 5);
			animationSizeStates._isUsingInitialSize.setValue(false);
		}
		
		private function onDecreaseWidthShortcut() : void {
			animationSizeStates._width.setValue(AnimationSizeStates.width.value - 5);
			animationSizeStates._isUsingInitialSize.setValue(false);
		}
		
		private function onIncreaseHeightShortcut() : void {
			animationSizeStates._height.setValue(AnimationSizeStates.height.value + 5);
			animationSizeStates._isUsingInitialSize.setValue(false);
		}
		
		private function onDecreaseHeightShortcut() : void {
			animationSizeStates._height.setValue(AnimationSizeStates.height.value - 5);
			animationSizeStates._isUsingInitialSize.setValue(false);
		}
	}
}