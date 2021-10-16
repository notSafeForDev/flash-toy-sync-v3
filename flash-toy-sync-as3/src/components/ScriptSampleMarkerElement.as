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
		
		private var isKeyframe : Boolean = false;
		private var isHighlighted : Boolean = false;
		
		public function ScriptSampleMarkerElement(_parent : MovieClip, _color : Number, _text : String) {
			super(_parent, _color, _text);
			
			onMouseDown = new CustomEvent();
			
			var uiButton : UIButton = new UIButton(element);
			uiButton.onMouseClick.listen(this, _onMouseDown);
		}
		
		protected override function updateDot() : void {
			var targetColor : Number = isKeyframe ? color : 0xFFFFFF;
			
			GraphicsUtil.clear(element);
			GraphicsUtil.beginFill(element, targetColor, isHighlighted ? 1 : 0);
			GraphicsUtil.setLineStyle(element, 1, targetColor);
			GraphicsUtil.drawCircle(element, 0, 0, 8);
		}
		
		private function _onMouseDown() : void {
			onMouseDown.emit();
		}
		
		public function displayAsKeyframe() : void {
			isKeyframe = true;
			updateDot();
		}
		
		public function displayAsInterpolated() : void {
			isKeyframe = false;
			updateDot();
		}
		
		public function highlight() : void {
			isHighlighted = true;
			updateDot();
		}
		
		public function clearHighlight() : void {
			isHighlighted = false;
			updateDot();
		}
	}
}