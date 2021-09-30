import core.FunctionUtil;
import core.KeyboardShortcut;

class core.KeyboardManager {
	
	var pressedKeys : Array = [];
	var shortcuts : Array = [];
	
	var onKeyPressed : Function;
	var onKeyReleased : Function;
	
	function KeyboardManager(_child : MovieClip) {
		var self = this;
		var inputListener : Object = {};
		Key.addListener(inputListener);
		
		inputListener.onKeyDown = function() {
			if (self.isKeyPressed(Key.getCode()) == false) {
				self.pressedKeys.push(Key.getCode());
			}
			
			for (var i = 0; i < self.shortcuts.length; i++) {
				if (self.shortcuts[i].enabled == false) {
					continue;
				}
				if (self.pressedKeys.toString() == self.shortcuts[i].keyCodes.toString()) {
					self.shortcuts[i].handler();
				}
			}
			
			if (self.onKeyPressed != null) {
				self.onKeyPressed(Key.getCode());
			}
		}
		
		inputListener.onKeyUp = function() {
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