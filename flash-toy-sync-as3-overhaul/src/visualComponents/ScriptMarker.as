package visualComponents {
	
	import core.CustomEvent;
	import core.DraggableObject;
	import core.TPMovieClip;
	import flash.geom.Point;
	import ui.TextElement;
	import ui.TextStyles;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptMarker {
		
		public var startDragEvent : CustomEvent;
		public var stopDragEvent : CustomEvent;
		
		protected var element : TPMovieClip;
		protected var text : TextElement;
		
		protected var draggable : DraggableObject;
		
		public function ScriptMarker(_parent : TPMovieClip, _text : String) {
			element = TPMovieClip.create(_parent, "scriptMarker");
			element.buttonMode = true;
			
			text = new TextElement(element, _text);
			
			TextStyles.applyMarkerStyle(text);
			
			text.element.x = -text.element.width / 2;
			text.element.y = -9;
			
			startDragEvent = new CustomEvent();
			stopDragEvent = new CustomEvent();
			
			draggable = new DraggableObject(element);
			draggable.bringToFrontOnDrag = true;
			
			draggable.startDragEvent.listen(startDragEvent, startDragEvent.emit);
			draggable.stopDragEvent.listen(stopDragEvent, stopDragEvent.emit);
			draggable.dragEvent.listen(this, onDrag);
		}
		
		protected function onDrag() : void {
			// Override
		}
		
		public function hide() : void {
			element.visible = false;
		}
		
		public function show() : void {
			element.visible = true;
		}
		
		public function isVisible() : Boolean {
			return element.visible;
		}
		
		public function moveToCursor() : void {
			draggable.moveToCursor();
		}
		
		public function startDrag() : void {
			draggable.startDrag();
		}
		
		public function stopDrag() : void {
			draggable.stopDrag();
		}
		
		public function isDragging() : Boolean {
			return draggable.isDragging();
		}
		
		public function getPosition() : Point {
			return new Point(element.x, element.y);
		}
	}
}