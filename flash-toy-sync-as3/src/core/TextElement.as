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
		
		public var element : TextField;
	
		private var textFormat : TextFormat;
		
		public function TextElement(_parent : MovieClip, _value : String = "") {
			element = new TextField();
			element.name = "TextField_" + _value;
			element.width = 0;
			element.height = 0;
			element.autoSize = TextFieldAutoSize.LEFT;
			element.selectable = false;
			_parent.addChild(element);
			
			textFormat = new TextFormat();
			
			setText(_value);
		}
		
		public function setText(_value : String) : void {
			element.text = _value;
			element.setTextFormat(textFormat);
		}
		
		public function setFont(_value : String) : void {
			textFormat.font = _value;
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
		
		public function setFontSize(_value : Number) : void {
			textFormat.size = _value;
			setText(element.text);
		}
	}
}