package components {
	
	import core.GraphicsUtil;
	import flash.display.MovieClip;
	
	import core.CustomEvent;
	import core.DisplayObjectUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptSampleMarkerElement extends ScriptMarkerElement {
		
		public var onMouseDown : CustomEvent;
		
		public function ScriptSampleMarkerElement(_parent : MovieClip, _color : Number, _text : String) {
			super(_parent, _color, _text);
			
			var uiButton : UIButton = new UIButton(element);
			uiButton.onMouseClick.listen(this, _onMouseDown);
		}
		
		protected override function updateDot() : void {
			GraphicsUtil.clear(element);
			GraphicsUtil.beginFill(element, 0xFF0000, 0);
			GraphicsUtil.setLineStyle(element, 1, color);
			GraphicsUtil.drawCircle(element, 0, 0, 8);
		}
		
		private function _onMouseDown() : void {
			onMouseDown.emit();
		}
	}
}