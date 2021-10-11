import core.FunctionUtil;
import core.KeyboardShortcut;

class core.KeyboardManager {
	
	var pressedKeys : Array = [];
	var shortcuts : Array = [];
	
	var onKeyPressed : Function;
	var onKeyReleased : Function;
	
	private var lastKeyDownEventTime : Number;
	private var lastKeyUpEventTime : Number;
	
	// To fix the double input issue, it seems like it requires some kind of object that is defined outside of the constructor
	private var blockPressInput : Array = [];
	private var blockReleaseInput : Array = [];
	
	function KeyboardManager(_child : MovieClip) {
		var self = this;
		var inputListener : Object = {};
		Key.addListener(inputListener);
		
		inputListener.onKeyDown = function() {
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
			
			for (var i = 0; i < self.shortcuts.length; i++) {
				if (self.shortcuts[i].enabled == false) {
					continue;
				}
				if (self.pressedKeys.toString() == self.shortcuts[i].keyCodes.toString()) {
					self.shortcuts[i].handler();
					break;
				}
			}
			
			if (self.onKeyPressed != null) {
				self.onKeyPressed(Key.getCode());
			}
		}
		
		inputListener.onKeyUp = function() {
			if (self.blockReleaseInput.length > 0) {
				return;
			}
			
			self.blockReleaseInput.push(true);
			setTimeout(function() {
				self.blockReleaseInput = [];
			}, 0);
			
			var pressedKeyIndex : Number = self.getPressedKeyIndex(Key.getCode());
			
			if (pressedKeyIndex >= 0) {
				self.pressedKeys.splice(pressedKeyIndex, 1);
			}
			
			if (self.onKeyReleased != null) {
				self.onKeyReleased(Key.getCode());
			}
		}
	}
	
	function isKeyPressed(_keyCode : Number) : Boolean {
		return getPressedKeyIndex(_keyCode) >= 0;
	}
	
	private function getPressedKeyIndex(_keyCode : Number) : Number {
		for (var i : Number = 0; i < pressedKeys.length; i++) {
			if (pressedKeys[i] == _keyCode) {
				return i;
			}
		}
		
		return -1;
	}
	
	/**
	 * Calls a function when a combination of keys are pressed
	 * Note: A shortcut starting with Control may not work depending on the combination
	 * @param	_keyCodes	An array of key codes, constants can be accessed through flash.ui.Keyboard
	 * @param	_handler	The function to call when the combination of keys are pressed
	 */
	public function addShortcut(_scope, _keyCodes : Array, _handler : Function) : KeyboardShortcut {
		var handler = FunctionUtil.bind(_scope, _handler);
		var shortcut = new KeyboardShortcut(_keyCodes, handler);
		shortcuts.push(shortcut);
		return shortcut;
	}
}