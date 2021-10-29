/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import ui.*
import core.JSON

import core.TranspiledDisplayObject;
import core.TranspiledTextField;

/**
 * ...
 * @author notSafeForDev
 */
class ui.TextElement {
	
	public static var AUTO_SIZE_LEFT : String = "left";
	public static var AUTO_SIZE_RIGHT : String = "right";
	public static var AUTO_SIZE_CENTER : String = "center";
	public static var AUTO_SIZE_NONE : String = "none";
	
	public static var ALIGN_LEFT : String = "left";
	public static var ALIGN_RIGHT : String = "right";
	public static var ALIGN_CENTER : String = "center";
	public static var ALIGN_JUSTIFY : String = "justify";
	
	public var element : TranspiledDisplayObject;
	public var textFormat : TextFormat;
	
	public var sourceTextField : TextField;
	
	public function TextElement(_parent : MovieClip) {
		sourceTextField = TranspiledTextField.create(_parent);
		
		sourceTextField.selectable = false;
		sourceTextField.mouseEnabled = false;
		
		element = new TranspiledDisplayObject(sourceTextField);
		textFormat = new TextFormat();
	}
	
	public function get text() : String {
		return sourceTextField.text;
	}
	
	public function set text(_value : String) : Void {
		if (sourceTextField.text == _value) {
			return;
		}
		
		sourceTextField.text = _value;
		sourceTextField.setTextFormat(textFormat);
	}
	
	public function setTextFormat(_textFormat : TextFormat) : Void {
		textFormat = _textFormat;
		sourceTextField.setTextFormat(textFormat);
	}
	
	/**
	 * setTextFormat has to be called to apply any changes made to the textFormat
	 * @return
	 */
	public function getTextFormat() : TextFormat {
		return textFormat;
	}
}