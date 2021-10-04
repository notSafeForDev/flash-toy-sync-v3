package core {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class KeyboardManager {
		
		public var pressedKeys : Array = [];
		public var shortcuts : Vector.<KeyboardShortcut> = new Vector.<KeyboardShortcut>();
		
		public var onKeyPressed : Function;
		public var onKeyReleased : Function;
		
		function KeyboardManager(_child : MovieClip) {
			_child.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e : KeyboardEvent) : void {
				// Control and Shift are handled differently 
				// as certain combinations that includes those keys prevents keyboard events from getting triggered
				if (e.ctrlKey == true && isKeyPressed(Keyboard.CONTROL) == false) {
					pressedKeys.push(Keyboard.CONTROL);
				}
				if (e.shiftKey == true && isKeyPressed(Keyboard.SHIFT) == false) {
					pressedKeys.push(Keyboard.SHIFT);
				}
				
				if (isKeyPressed(e.keyCode) == false) {
					pressedKeys.push(e.keyCode);
				}
				
				for (var i : int = 0; i < shortcuts.length; i++) {
					if (shortcuts[i].enabled == false) {
						continue;
					}
					if (pressedKeys.toString() == shortcuts[i].keyCodes.toString()) {
						shortcuts[i].handler();
						break;
					}
				}
				
				if (onKeyPressed != null) {
					onKeyPressed(e.keyCode);
				}
			});
			
			_child.stage.addEventListener(KeyboardEvent.KEY_UP, function(e : KeyboardEvent) : void {
				var ctrlKeyIndex : int = pressedKeys.indexOf(Keyboard.CONTROL);
				if (ctrlKeyIndex >= 0 && e.ctrlKey == false) {
					pressedKeys.splice(ctrlKeyIndex, 1);
				}
				
				var shiftKeyIndex : int = pressedKeys.indexOf(Keyboard.SHIFT);
				if (shiftKeyIndex >= 0 && e.shiftKey == false) {
					pressedKeys.splice(shiftKeyIndex, 1);
				}
				
				var pressedKeyIndex : int = pressedKeys.indexOf(e.keyCode);
				if (pressedKeyIndex >= 0) {
					pressedKeys.splice(pressedKeyIndex, 1);
				}
				
				if (onKeyReleased != null) {
					onKeyReleased(e.keyCode);
				}
			});
		}
		
		public function isKeyPressed(_keyCode : Number) : Boolean {
			return pressedKeys.indexOf(_keyCode) >= 0;
		}
		
		/**
		 * Calls a function when a combination of keys are pressed
		 * Note: A shortcut starting with Control may not work depending on the combination
		 * @param	_keyCodes	An array of key codes, constants can be accessed through flash.ui.Keyboard
		 * @param	_handler	The function to call when the combination of keys are pressed
		 */
		public function addShortcut(_scope : *, _keyCodes : Array, _handler : Function) : KeyboardShortcut {
			var shortcut : KeyboardShortcut = new KeyboardShortcut(_keyCodes, _handler);
			shortcuts.push(shortcut);
			return shortcut;
		}
	}
}