package components {
	import config.TextStyles;
	import core.TextElement;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ToyPanel extends Panel {
		
		public function ToyPanel(_parent : MovieClip) {
			super(_parent, "Toy", 150, 150);
			
			var keyInputText : TextElement = new TextElement(content, "connectionKey..."); // Uses a non empty string, as in AS2 it doesn't work otherwise
			TextStyles.applyInputStyle(keyInputText);
			keyInputText.setX(10);
			keyInputText.setY(10);
			keyInputText.setWidth(130);
			keyInputText.element.type = "input";
			keyInputText.setAutoSize(TextElement.AUTO_SIZE_NONE);
			keyInputText.onChange.listen(this, onConnectionKeyChange);
		}
		
		private function onConnectionKeyChange(_key : String) : void {
			trace(_key);
		}
	}
}