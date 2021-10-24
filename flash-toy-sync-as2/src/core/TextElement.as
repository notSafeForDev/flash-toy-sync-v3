import core.CustomEvent;
import core.FunctionUtil;
import core.TextElement;

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
	
	public var onChange : CustomEvent;
	
	private var textFormat : TextFormat;
	
	private var x : Number = 0;
	
	public function TextElement(_parent : MovieClip, _value : String, _autoSize : String) {
		element = _parent.createTextField("TextField", _parent.getNextHighestDepth(), 0, 0, 1, 20);
		element.text = _value;
		if (_autoSize != undefined) {
			element.autoSize = _autoSize;
		} else {
			element._width = 100;
		}
		element.selectable = false;
		
		textFormat = new TextFormat();
		
		onChange = new CustomEvent();
		
		setText(_value);
		
		element.onChanged = FunctionUtil.bind(this, onChanged);
	}
	
	private function onChanged() {
		onChange.emit(element.text);
		element.setTextFormat(textFormat);
	}
	
	public function setMouseEnabled(_value : Boolean) : Void {
		// Mouse enabled isn't available in AS2
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
	
	public function setWidth(_value : Number) : Void {
		element._width = _value;
	}
	
	public function setHeight(_value : Number) : Void {
		element._height = _value;
	}
	
	public function setVisible(_value : Boolean) : Void {
		element._visible = _value;
	}
	
	public function setText(_value : String) : Void {
		if (element.text == _value) {
			return; // Important for performance when updating many texts frequently
		}
		element.text = _value;
		element.setTextFormat(textFormat);
		updateX();
	}
	
	public function getText() : String {
		return element.text;
	}
	
	public function setAutoSize(_value : String) : Void {
		element.autoSize = _value;
	}
	
	public function setFont(_value : String, _isEmbedded : Boolean) : Void {
		if (_isEmbedded == true) {
			element.embedFonts = true;
		}
		textFormat.font = _value;
		element.setTextFormat(textFormat);
	}
	
	public function setFontSize(_value : Number) : Void {
		textFormat.size = _value;
		element.setTextFormat(textFormat);
	}
	
	public function setBold(_value : Boolean) : Void {
		textFormat.bold = _value;
		element.setTextFormat(textFormat);
	}
	
	public function setItalic(_value : Boolean) : Void {
		textFormat.italic = _value;
		element.setTextFormat(textFormat);
	}
	
	public function setAlign(_value : String) : Void {
		textFormat.align = _value;
		element.setTextFormat(textFormat);
	}
	
	public function setUnderline(_value : Boolean) : Void {
		textFormat.underline = _value;
		element.setTextFormat(textFormat);
	}
	
	public function setFilters(_filters : Array) : Void {
		element.filters = _filters;
	}
	
	public function convertToInputField() : Void {
		element.type = "input";
		setAutoSize(TextElement.AUTO_SIZE_NONE);
	}
}