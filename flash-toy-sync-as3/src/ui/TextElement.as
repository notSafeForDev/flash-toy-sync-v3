package ui {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import core.TPTextField;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TextElement {
		
		public static var AUTO_SIZE_LEFT : String = "left";
		public static var AUTO_SIZE_RIGHT : String = "right";
		public static var AUTO_SIZE_CENTER : String = "center";
		public static var AUTO_SIZE_NONE : String = "none";
		
		public static var ALIGN_LEFT : String = "left";
		public static var ALIGN_RIGHT : String = "right";
		public static var ALIGN_CENTER : String = "center";
		public static var ALIGN_JUSTIFY : String = "justify";
		
		public var element : TPDisplayObject;
		public var textFormat : TextFormat;
		
		public var sourceTextField : TextField;
		
		private var onChangeHandler : Function;
		
		public function TextElement(_parent : TPMovieClip, _text : String) {
			sourceTextField = TPTextField.create(_parent);
			
			sourceTextField.selectable = false;
			sourceTextField.mouseEnabled = false;
			sourceTextField.text = _text;
			
			element = new TPDisplayObject(sourceTextField);
			textFormat = new TextFormat();
		}
		
		public function get text() : String {
			return sourceTextField.text;
		}
		
		public function set text(_value : String) : void {
			if (sourceTextField.text == _value) {
				return;
			}
			
			sourceTextField.text = _value;
			sourceTextField.setTextFormat(textFormat);
		}
		
		public function get wordWrap() : Boolean {
			return sourceTextField.wordWrap;
		}
		
		public function set wordWrap(_value : Boolean) : void {
			sourceTextField.wordWrap = _value;
		}
		
		public function setTextFormat(_textFormat : TextFormat) : void {
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
		
		public function convertToInputField(_scope : * , _onChangeHandler : Function) : void {
			onChangeHandler = function(_text : String) : void {
				_onChangeHandler.apply(_scope, [_text]);
			}
			
			sourceTextField.type = "input";
			sourceTextField.selectable = true;
			sourceTextField.mouseEnabled = true;
			TPTextField.addOnChangeListener(sourceTextField, this, onInputTextChange);
		}
		
		private function onInputTextChange(_text : String) : void {
			setTextFormat(textFormat);
			onChangeHandler(_text);
		}
	}
}