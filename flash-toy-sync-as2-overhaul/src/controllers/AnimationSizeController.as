/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import controllers.*
import core.JSON

import components.KeyboardInput;
import core.Keyboard;
import states.AnimationSizeStates;

/**
 * ...
 * @author notSafeForDev
 */
class controllers.AnimationSizeController {
	
	private var animationSizeStates : AnimationSizeStates;
	
	public function AnimationSizeController(_animationSizeStates : AnimationSizeStates) {
		animationSizeStates = _animationSizeStates;
		
		KeyboardInput.addShortcut([Keyboard.S, Keyboard.LEFT], this, onIncreaseWidthShortcut, null);
		KeyboardInput.addShortcut([Keyboard.S, Keyboard.RIGHT], this, onDecreaseWidthShortcut, null);
		KeyboardInput.addShortcut([Keyboard.S, Keyboard.UP], this, onIncreaseHeightShortcut, null);
		KeyboardInput.addShortcut([Keyboard.S, Keyboard.DOWN], this, onDecreaseHeightShortcut, null);
	}
	
	public function update() : Void {
		// Do nothing
	}
	
	private function onIncreaseWidthShortcut() : Void {
		animationSizeStates._width.setValue(AnimationSizeStates.width.value + 5);
	}
	
	private function onDecreaseWidthShortcut() : Void {
		animationSizeStates._width.setValue(AnimationSizeStates.width.value - 5);
	}
	
	private function onIncreaseHeightShortcut() : Void {
		animationSizeStates._height.setValue(AnimationSizeStates.height.value + 5);
	}
	
	private function onDecreaseHeightShortcut() : Void {
		animationSizeStates._height.setValue(AnimationSizeStates.height.value - 5);
	}
}