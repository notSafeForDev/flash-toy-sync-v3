package core {
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPKeyboardInput {
		private var pressedKeys : Vector.<Number>;
		
		private var keyUpHandler : Function;
		
		private var stage : Stage;
		
		public function TPKeyboardInput(_object : TPDisplayObject, _keyDownHandler : Function, _keyUpHandler : Function) {
			pressedKeys = new Vector.<Number>();
			
			keyUpHandler = _keyUpHandler;
			
			stage = _object.sourceDisplayObject.stage;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e : KeyboardEvent) : void {
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
			
			stage.addEventListener(KeyboardEvent.KEY_UP, function(e : KeyboardEvent) : void {
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
			
			_object.sourceDisplayObject.stage.addEventListener(FocusEvent.FOCUS_OUT, onStageFocusLoss);
		}
		
		public function getPressedKeys() : Vector.<Number> {
			return pressedKeys.slice();
		}
		
		public function isKeyPressed(_key : Number) : Boolean {
			return TPArrayUtil.indexOf(pressedKeys, _key) >= 0;
		}
		
		// When the focus is lost for the stage, it doesn't detect key events, 
		// so to prevent keys from getting stuck as pressed, we release all currently pressed keys
		private function onStageFocusLoss(e : Event) : void {
			if (stage.focus != null) {
				return;
			}
			
			for (var i : Number = 0; i < pressedKeys.length; i++) {
				keyUpHandler(pressedKeys[i]);
			}
			
			pressedKeys.length = 0;
		}
	}
}