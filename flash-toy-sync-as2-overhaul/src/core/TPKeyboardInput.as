import core.TPArrayUtil;
import transpilers.ArrayTranspilerFunctions;
import transpilers.TranspiledKeyboardInput;

/**
 * ...
 * @author notSafeForDev
 */
class core.TPKeyboardInput {

	private var pressedKeys : Array;

	// To fix the double input issue, it seems like it requires some kind of object that is defined outside of the constructor
	private var blockPressInput : Array = [];
	private var blockReleaseInput : Array = [];

	public function TPKeyboardInput(_object : MovieClip, _keyDownHandler : Function, _keyUpHandler : Function) {
		pressedKeys = [];
		
		var self = this;
		
		var inputListener : Object = {};
		Key.addListener(inputListener);
		
		inputListener.onKeyDown = function() : Void {
			// This is very important as there's a bug that causes input events to trigger twice
			// So by checking if we have already added a value to the blockPressInput array, we prevent that
			// Could be related to: https://stackoverflow.com/questions/22012948/keydown-event-fires-twice
			if (self.blockPressInput.length > 0) {
				return;
			}
			
			self.blockPressInput.push(true);
			setTimeout(function() {
				self.blockPressInput = [];
			}, 0);

			if (self.isKeyPressed(Key.getCode()) == false) {
				self.pressedKeys.push(Key.getCode());
			}
			
			if (_keyDownHandler != null) {
				_keyDownHandler(Key.getCode());
			}
		}

		inputListener.onKeyUp = function() : Void {
			if (self.blockReleaseInput.length > 0) {
				return;
			}
			
			self.blockReleaseInput.push(true);
			setTimeout(function() {
				self.blockReleaseInput = [];
			}, 0);
			
			var pressedKeyIndex : Number = TPArrayUtil.indexOf(self.pressedKeys, Key.getCode());
			
			if (self.pressedKeyIndex >= 0) {
				self.pressedKeys.splice(pressedKeyIndex, 1);
			}
			
			if (_keyUpHandler != null) {
				_keyUpHandler(Key.getCode());
			}
		}
	}

	public function getPressedKeys() : Array {
		return pressedKeys.slice();
	}

	public function isKeyPressed(_key : Number) : Boolean {
		return TPArrayUtil.indexOf(pressedKeys, _key) >= 0;
	}
}