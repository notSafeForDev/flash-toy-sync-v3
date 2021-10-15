package components {
	
	import flash.display.MovieClip;
	
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
		
		public function ScriptMarkerElement(_parent : MovieClip, _color : Number, _text : String) {
			onStopDrag = new CustomEvent();
			
			element = MovieClipUtil.create(_parent, _text.toLowerCase() + "Marker");
			element.buttonMode = true;
			GraphicsUtil.beginFill(element, _color, 0.5);
			GraphicsUtil.drawCircle(element, 0, 0, 10);
			
			var text : TextElement = new TextElement(element, _text, TextElement.AUTO_SIZE_LEFT);
			text.setAutoSize(TextElement.AUTO_SIZE_CENTER); // Setting it left and then center is required to make this work, for some reason
			text.setMouseEnabled(false);
			text.setY(-9);
			TextStyles.applyMarkerStyle(text);
			
			var draggable : DraggableObject = new DraggableObject(element, element);
			draggable.onStartDrag.listen(this, _onStartDrag);
			draggable.onStopDrag.listen(this, _onStopDrag);
			draggable.bringToFrontOnDrag = true;
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
		
		public function setX(_x : Number) : void {
			DisplayObjectUtil.setX(element, _x);
		}
		
		public function setY(_y : Number) : void {
			DisplayObjectUtil.setY(element, _y);
		}
		
		public function getX() : Number {
			return DisplayObjectUtil.getX(element);
		}
		
		public function getY() : Number {
			return DisplayObjectUtil.getY(element);
		}
	}
}