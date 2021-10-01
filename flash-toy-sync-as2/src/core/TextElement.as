/**
 * ...
 * @author notSafeForDev
 */
class core.TextElement {
	
	public var element : TextField;
	
	public function TextElement(_parent : MovieClip, _value : String) {
		element = _parent.createTextField("TextField_" + _value, _parent.getNextHighestDepth(), 0, 0, 0, 0);
		element.text = _value;
		element.autoSize = "left";
		element.selectable = false;
	}
}