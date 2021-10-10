package components {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import core.CustomEvent;
	import core.DisplayObjectUtil;
	import core.DraggableObject;
	import core.Fonts;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.TextElement;
	
	import config.TextStyles;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptMarker {
		public var onStopDrag : CustomEvent;
		
		public var isDragging : Boolean;
		
		public var movieClip : MovieClip;
		
		public function ScriptMarker(_parent : MovieClip, _color : Number, _text : String) {
			onStopDrag = new CustomEvent();
			
			movieClip = MovieClipUtil.create(_parent, _text.toLowerCase() + "Marker");
			movieClip.buttonMode = true;
			GraphicsUtil.beginFill(movieClip, _color, 0.5);
			GraphicsUtil.drawCircle(movieClip, 0, 0, 10);
			
			var text : TextElement = new TextElement(movieClip, _text, TextElement.AUTO_SIZE_LEFT);
			text.setAutoSize(TextElement.AUTO_SIZE_CENTER); // Setting it left and then center is required to make this work, for some reason
			text.setMouseEnabled(false);
			text.setY(-9);
			TextStyles.applyMarkerStyle(text);
			
			var draggable : DraggableObject = new DraggableObject(movieClip, movieClip);
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
			DisplayObjectUtil.setVisible(movieClip, _state);
		}
		
		public function setX(_x : Number) : void {
			DisplayObjectUtil.setX(movieClip, _x);
		}
		
		public function setY(_y : Number) : void {
			DisplayObjectUtil.setY(movieClip, _y);
		}
		
		public function getX() : Number {
			return DisplayObjectUtil.getX(movieClip);
		}
		
		public function getY() : Number {
			return DisplayObjectUtil.getY(movieClip);
		}
	}
}