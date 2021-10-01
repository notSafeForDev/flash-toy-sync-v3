package core {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TextElement {
		
		public var element : TextField;
		
		public function TextElement(_parent : MovieClip, _value : String = "") {
			element = new TextField();
			element.name = "TextField_" + _value;
			element.text = _value;
			element.width = 0;
			element.height = 0;
			element.autoSize = TextFieldAutoSize.LEFT;
			element.selectable = false;
			_parent.addChild(element);
		}
	}
}