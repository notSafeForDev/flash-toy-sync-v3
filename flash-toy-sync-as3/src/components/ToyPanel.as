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
			super(_parent, "Toy", 150, -1);
			
			addInputText("connectionKey...", this, onConnectionKeyChange);
		}
		
		private function onConnectionKeyChange(_key : String) : void {
			trace(_key);
		}
	}
}