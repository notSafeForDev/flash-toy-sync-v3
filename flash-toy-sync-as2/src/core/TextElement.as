/**
 * ...
 * @author notSafeForDev
 */
class core.TextElement {
	
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
	
	private var x : Number = 0;
	
	public function TextElement(_parent : MovieClip, _value : String) {
		element = _parent.createTextField("TextField_" + _value, _parent.getNextHighestDepth(), 0, 0, 0, 0);
		element.text = _value;
		element.autoSize = AUTO_SIZE_LEFT;
		element.selectable = false;
		
		textFormat = new TextFormat();
		
		setText(_value);
	}
	
	private function updateX() : Void {
		if (element.autoSize == AUTO_SIZE_RIGHT) {
			element._x = x - element.textWidth;
		} else if (element.autoSize == AUTO_SIZE_CENTER) {
			element._x = x - element.textWidth * 0.5;
		} else {
			element._x = x;
		}
	}
	
	public function setX(_value : Number) : Void {
		x = _value;
		updateX();
	}
	
	public function setY(_value : Number) : Void {
		element._y = _value;
	}
	
	public function setText(_value : String) : Void {
		if (element.text == _value) {
			return; // Important for performance when updating many texts frequently
		}
		element.text = _value;
		element.setTextFormat(textFormat);
		updateX();
	}
	
	public function setAutoSize(_value : String) : Void {
		element.autoSize = _value;
	}
	
	public function setFont(_value : String) : Void {
		textFormat.font = _value;
		setText(element.text);
	}
	
	public function setFontSize(_value : Number) : Void {
		textFormat.size = _value;
		setText(element.text);
	}
	
	public function setBold(_value : Boolean) : Void {
		textFormat.bold = _value;
		setText(element.text);
	}
	
	public function setItalic(_value : Boolean) : Void {
		textFormat.italic = _value;
		setText(element.text);
	}
	
	public function setAlign(_value : String) : Void {
		textFormat.align = _value;
		setText(element.text);
	}
}