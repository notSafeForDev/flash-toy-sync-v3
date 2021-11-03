package components {
	
	import core.CustomEvent;
	import core.TPDisplayObject;
	import flash.display.DisplayObject;
	import core.TPKeyboardInput;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class KeyboardInput {
		
		public static var keyDownEvent : CustomEvent;
		public static var keyUpEvent : CustomEvent;
		
		private static var transpiledKeyboardInput : TPKeyboardInput;
		
		private static var shortcuts : Vector.<KeyboardShortcut>;
		
		public static function init(_object : TPDisplayObject) : void {
			transpiledKeyboardInput = new TPKeyboardInput(_object, KeyboardInput.onKeyDown, onKeyUp);
			
			keyDownEvent = new CustomEvent();
			keyUpEvent = new CustomEvent();
			
			shortcuts = new Vector.<KeyboardShortcut>();
		}
		
		public static function addShortcut(_keys : Array, _scope : *, _handler : Function, _rest : Array) : KeyboardShortcut {
			var keys : Vector.<Number> = new Vector.<Number>();
			for (var i : Number = 0; i < _keys.length; i++) {
				keys.push(_keys[i]);
			}
			
			var shortcut : KeyboardShortcut = new KeyboardShortcut(keys, _scope, _handler, _rest);
			KeyboardInput.shortcuts.push(shortcut);
			KeyboardInput.shortcuts.sort(function(_a : KeyboardShortcut, _b : KeyboardShortcut) : Number {
				return _b.keys.length - _a.keys.length;
			});
			
			return shortcut;
		}
		
		public static function isKeyPressed(_key : Number) : Boolean {
			return transpiledKeyboardInput.isKeyPressed(_key);
		}
		
		private static function onKeyDown(_key : Number) : void {
			for (var i : Number = 0; i < shortcuts.length; i++) {
				var shortcut : KeyboardShortcut = KeyboardInput.shortcuts[i];
				
				if (shortcut.enabled == false) {
					continue;
				}
				if (transpiledKeyboardInput.getPressedKeys().toString() == shortcut.keys.toString()) {
					shortcut.handler.apply(shortcut.scope, shortcut.rest);
					break;
				}
			}
			
			keyDownEvent.emit(_key);
		}
		
		private static function onKeyUp(_key : Number) : void {
			keyUpEvent.emit(_key);
		}
	}
}