package core {
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SimpleDraggableObject {
		
		public var dragBounds : Rectangle;
		public var bringToFrontOnDrag : Boolean;
		
		private var element : TPMovieClip;
		private var hitArea : TPMovieClip;
		
		private var isDragging : Boolean = false;
		
		public function SimpleDraggableObject(_element : TPMovieClip, _hitArea : TPMovieClip = null) {
			element = _element
			hitArea = _hitArea || _element;
			
			hitArea.sourceDisplayObject.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			element.sourceDisplayObject.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		private function onMouseDown(e : MouseEvent) : void {
			startDrag();
		}
		
		private function onStageMouseUp(e : MouseEvent) : void {
			stopDrag();
		}
		
		public function startDrag() : void {
			element.sourceMovieClip.startDrag(false, dragBounds);
			isDragging = true;
			
			if (bringToFrontOnDrag == true && element.parent != null) {
				var parent : DisplayObjectContainer = element.parent;
				parent.setChildIndex(element.sourceDisplayObject, parent.numChildren - 1);
			}
		}
		
		public function stopDrag() : void {
			element.sourceMovieClip.stopDrag();
			isDragging = false;
		}
	}
}