/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import components.*
import core.JSON
import core.TranspiledKeyboardInput;

/**
 * ...
 * @author notSafeForDev
 */
class components.KeyboardInput {
	
	private static var transpiledKeyboardInput : TranspiledKeyboardInput;
	
	private static var shortcuts : Array;
	
	public static function init(_object ) : Void {
		transpiledKeyboardInput = new TranspiledKeyboardInput(_object, KeyboardInput.onKeyDown, null);
		
		shortcuts = [];
	}
	
	public static function addShortcut(_keys : Array, _scope , _handler : Function, _rest : Array) : KeyboardShortcut {
		var keys : Array = [];
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
	
	private static function onKeyDown(_key : Number) : Void {
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