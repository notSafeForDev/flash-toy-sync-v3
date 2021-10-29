package controllers {
	
	import components.KeyboardInput;
	import flash.ui.Keyboard;
	import states.AnimationSizeStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationSizeController {
		
		private var animationSizeStates : AnimationSizeStates;
		
		public function AnimationSizeController(_animationSizeStates : AnimationSizeStates) {
			animationSizeStates = _animationSizeStates;
			
			KeyboardInput.addShortcut([Keyboard.S, Keyboard.LEFT], this, onIncreaseWidthShortcut, null);
			KeyboardInput.addShortcut([Keyboard.S, Keyboard.RIGHT], this, onDecreaseWidthShortcut, null);
			KeyboardInput.addShortcut([Keyboard.S, Keyboard.UP], this, onIncreaseHeightShortcut, null);
			KeyboardInput.addShortcut([Keyboard.S, Keyboard.DOWN], this, onDecreaseHeightShortcut, null);
		}
		
		public function update() : void {
			// Do nothing
		}
		
		private function onIncreaseWidthShortcut() : void {
			animationSizeStates._width.setValue(AnimationSizeStates.width.value + 5);
		}
		
		private function onDecreaseWidthShortcut() : void {
			animationSizeStates._width.setValue(AnimationSizeStates.width.value - 5);
		}
		
		private function onIncreaseHeightShortcut() : void {
			animationSizeStates._height.setValue(AnimationSizeStates.height.value + 5);
		}
		
		private function onDecreaseHeightShortcut() : void {
			animationSizeStates._height.setValue(AnimationSizeStates.height.value - 5);
		}
	}
}