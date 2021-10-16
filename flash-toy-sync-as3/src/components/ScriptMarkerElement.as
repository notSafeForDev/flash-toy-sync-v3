package components {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import core.CustomEvent;
	import core.DisplayObjectUtil;
	import core.DraggableObject;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.TextElement;
	
	import config.TextStyles;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptMarkerElement {
		public var onStopDrag : CustomEvent;
		
		public var isDragging : Boolean;
		
		public var element : MovieClip;
		
		public var draggable : DraggableObject;
		
		protected var color : Number;
		
		public function ScriptMarkerElement(_parent : MovieClip, _color : Number, _text : String) {
			onStopDrag = new CustomEvent();
			
			element = createMarker(_parent, _color, _text);
			updateDot();
			
			draggable = new DraggableObject(element, element);
			draggable.onStartDrag.listen(this, _onStartDrag);
			draggable.onStopDrag.listen(this, _onStopDrag);
			draggable.bringToFrontOnDrag = true;
		}
		
		private function createMarker(_parent : MovieClip, _color  : Number, _text : String) : MovieClip {
			color = _color;
			
			var dot : MovieClip = MovieClipUtil.create(_parent, _text.toLowerCase() + "Marker");
			dot.buttonMode = true;
			
			var text : TextElement = new TextElement(dot, _text, TextElement.AUTO_SIZE_LEFT);
			text.setAutoSize(TextElement.AUTO_SIZE_CENTER); // Setting it left and then center is required to make this work, for some reason
			text.setMouseEnabled(false);
			text.setY(-9);
			TextStyles.applyMarkerStyle(text);
			
			return dot;
		}
		
		protected function updateDot() : void {
			GraphicsUtil.clear(element);
			GraphicsUtil.beginFill(element, color, 0.5);
			GraphicsUtil.drawCircle(element, 0, 0, 10);
		}
		
		private function _onStartDrag() : void {
			isDragging = true;
		}
		
		private function _onStopDrag() : void {
			isDragging = false;
			onStopDrag.emit();
		}
		
		public function setVisible(_state : Boolean) : void {
			DisplayObjectUtil.setVisible(element, _state);
		}
		
		public function setPosition(_point : Point) : void {
			DisplayObjectUtil.setX(element, _point.x);
			DisplayObjectUtil.setY(element, _point.y);
		}
		
		public function getX() : Number {
			return DisplayObjectUtil.getX(element);
		}
		
		public function getY() : Number {
			return DisplayObjectUtil.getY(element);
		}
	}
}