/**
 * ...
 * @author notSafeForDev
 */
class core.TextElement {
	
	public var element : TextField;
	
	private var textFormat : TextFormat;
	
	public function TextElement(_parent : MovieClip, _value : String) {
		element = _parent.createTextField("TextField_" + _value, _parent.getNextHighestDepth(), 0, 0, 0, 0);
		element.text = _value;
		element.autoSize = "left";
		element.selectable = false;
		
		textFormat = new TextFormat();
		
		setText(_value);
	}
	
	public function setText(_value : String) : Void {
		element.text = _value;
		element.setTextFormat(textFormat);
	}
	
	public function setFont(_value : String) : Void {
		textFormat.font = _value;
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
	
	public function setFontSize(_value : Number) : Void {
		textFormat.size = _value;
		setText(element.text);
	}
}