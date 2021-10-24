package core {
	
	import flash.display.MovieClip;
	import flash.events.Event;
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
		
		public var onChange : CustomEvent;
		
		public var element : TextField;
	
		private var textFormat : TextFormat;
		
		public function TextElement(_parent : MovieClip, _value : String = "", _autoSize : String = "") {
			element = new TextField();
			element.name = "TextField_" + _value;
			// The autoSize property is a bit buggy when assigned after it have been initialized, so we do it in the constructor
			if (_autoSize != "") {
				element.autoSize = _autoSize;
			} else {
				element.width = 100;
			}
			element.height = 20;
			element.selectable = false;
			_parent.addChild(element);
			
			onChange = new CustomEvent();
			
			textFormat = new TextFormat();
			
			setText(_value);
			
			element.addEventListener(Event.CHANGE, function(e : Event) : void {
				onChange.emit(element.text);
				element.setTextFormat(textFormat);
			});
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
		
		public function setWidth(_value : Number) : void {
			element.width = _value;
		}
		
		public function setHeight(_value : Number) : void {
			element.height = _value;
		}
		
		public function setVisible(_value : Boolean) : void {
			element.visible = _value;
		}
		
		public function setText(_value : String) : void {
			if (element.text == _value) {
				return; // Important for performance when updating many texts frequently
			}
			element.text = _value;
			element.setTextFormat(textFormat);
		}
		
		public function getText() : String {
			return element.text;
		}
		
		public function setAutoSize(_value : String) : void {
			element.autoSize = _value;
		}
		
		public function setFont(_value : String, isEmbedded : Boolean) : void {
			if (isEmbedded == true) {
				element.embedFonts = true;
			}
			textFormat.font = _value;
			element.setTextFormat(textFormat);
		}
		
		public function setFontSize(_value : Number) : void {
			textFormat.size = _value;
			element.setTextFormat(textFormat);
		}
		
		public function setBold(_value : Boolean) : void {
			textFormat.bold = _value;
			element.setTextFormat(textFormat);
		}
		
		public function setItalic(_value : Boolean) : void {
			textFormat.italic = _value;
			element.setTextFormat(textFormat);
		}
		
		public function setAlign(_value : String) : void {
			textFormat.align = _value;
			element.setTextFormat(textFormat);
		}
		
		public function setUnderline(_value : Boolean) : void {
			textFormat.underline = _value;
			element.setTextFormat(textFormat);
		}
		
		public function setFilters(_filters : Array) : void {
			element.filters = _filters;
		}
		
		public function convertToInputField() : void {
			element.type = "input";
			setAutoSize(TextElement.AUTO_SIZE_NONE);
		}
	}
}