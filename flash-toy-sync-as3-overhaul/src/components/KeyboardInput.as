package components {
	import flash.display.DisplayObject;
	import core.TPKeyboardInput;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class KeyboardInput {
		
		private static var transpiledKeyboardInput : TPKeyboardInput;
		
		private static var shortcuts : Vector.<KeyboardShortcut>;
		
		public static function init(_object : DisplayObject) : void {
			transpiledKeyboardInput = new TPKeyboardInput(_object, KeyboardInput.onKeyDown, null);
			
			shortcuts = new Vector.<KeyboardShortcut>();
		}
		
		public static function addShortcut(_keys : Array, _scope : *, _handler : Function, _rest : Array) : KeyboardShortcut {
			var keys : Vector.<Number> = new Vector.<Number>();
			for (var i : Number = 0; i < _keys.length; i++) {
				keys.push(_keys[i]);
			}
			
			var shortcut : KeyboardShortcut = new KeyboardShortcut(keys, _scope, _handler, _rest);
			KeyboardInput.shortcuts.push(shortcut);
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
		}
	}
}