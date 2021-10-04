package core {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
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
		
		public var element : TextField;
	
		private var textFormat : TextFormat;
		
		public function TextElement(_parent : MovieClip, _value : String = "") {
			element = new TextField();
			element.name = "TextField_" + _value;
			element.width = 0;
			element.height = 0;
			element.autoSize = AUTO_SIZE_LEFT;
			element.selectable = false;
			_parent.addChild(element);
			
			textFormat = new TextFormat();
			
			setText(_value);
		}
		
		public function setMouseEnabled(_value : Boolean) : void {
			element.mouseEnabled = _value;
		}
		
		public function setX(_value : Number) : void {
			element.x = _value;
		}
		
		public function setY(_value : Number) : void {
			element.y = _value;
		}
		
		public function setText(_value : String) : void {
			if (element.text == _value) {
				return; // Important for performance when updating many texts frequently
			}
			element.text = _value;
			element.setTextFormat(textFormat);
		}
		
		public function setAutoSize(_value : String) : void {
			element.autoSize = _value;
		}
		
		public function setFont(_value : String) : void {
			textFormat.font = _value;
			setText(element.text);
		}
		
		public function setFontSize(_value : Number) : void {
			textFormat.size = _value;
			setText(element.text);
		}
		
		public function setBold(_value : Boolean) : void {
			textFormat.bold = _value;
			setText(element.text);
		}
		
		public function setItalic(_value : Boolean) : void {
			textFormat.italic = _value;
			setText(element.text);
		}
		
		public function setAlign(_value : String) : void {
			textFormat.align = _value;
			setText(element.text);
		}
	}
}