package core {
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPKeyboardInput {
		private var pressedKeys : Vector.<Number>;
		
		public function TPKeyboardInput(_object : DisplayObject, _keyDownHandler : Function, _keyUpHandler : Function) {
			pressedKeys = new Vector.<Number>();
			
			_object.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e : KeyboardEvent) : void {
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
				if (_keyDownHandler != null) {
					_keyDownHandler(e.keyCode);
				}
			});
			
			_object.stage.addEventListener(KeyboardEvent.KEY_UP, function(e : KeyboardEvent) : void {
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
				if (_keyUpHandler != null) {
					_keyUpHandler(e.keyCode);
				}
			});
		}
		
		public function getPressedKeys() : Vector.<Number> {
			return pressedKeys.slice();
		}
		
		public function isKeyPressed(_key : Number) : Boolean {
			return TPArrayUtil.indexOf(pressedKeys, _key) >= 0;
		}
	}
}