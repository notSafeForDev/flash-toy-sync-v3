package core {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Stage;
	import utils.MathUtil;
	
	public class DraggableObject {
		
		public var dragBounds : Rectangle;
		
		public var bringToFrontOnDrag : Boolean;
		
		public var startDragEvent : CustomEvent;
		public var stopDragEvent : CustomEvent;
		public var dragEvent : CustomEvent;
		
		private var container : DisplayObject;
		private var hitArea : DisplayObject;
		
		private var _isDragging : Boolean = false;
		private var mouseDragOffset : Point;
		
		function DraggableObject(_container : TPDisplayObject, _hitArea : TPDisplayObject = null) {
			container = _container.sourceDisplayObject;
			hitArea = _hitArea != null ? _hitArea.sourceDisplayObject : container;
			
			startDragEvent = new CustomEvent();
			stopDragEvent = new CustomEvent();
			dragEvent = new CustomEvent();
			
			hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMoveMouseDown);
			container.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			container.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function moveToCursor() : void {
			container.x = container.parent.mouseX;
			container.y = container.parent.mouseY;
		}
		
		public function startDrag() : void {
			mouseDragOffset = container.parent.globalToLocal(new Point(container.stage.mouseX, container.stage.mouseY));
			mouseDragOffset.x -= container.x;
			mouseDragOffset.y -= container.y;
			
			if (bringToFrontOnDrag == true && container.parent) {
				container.parent.setChildIndex(container, container.parent.numChildren - 1);
			}
			
			_isDragging = true;
			startDragEvent.emit();
		}
		
		public function stopDrag() : void {
			if (isDragging == false) {
				return;
			}
			
			_isDragging = false;
			stopDragEvent.emit();
		}
		
		public function isDragging() : Boolean {
			return _isDragging;
		}
		
		private function onButtonMoveMouseDown(e : MouseEvent) : void {
			startDrag();
		}
		
		private function onMouseUp(e : MouseEvent) : void {
			stopDrag();
		}
		
		private function onEnterFrame(e : Event) : void {
			if (_isDragging == true) {
				var mousePosition : Point = container.parent.globalToLocal(new Point(container.stage.mouseX, container.stage.mouseY));
				container.x = mousePosition.x - mouseDragOffset.x;
				container.y = mousePosition.y - mouseDragOffset.y;
			}
			
			if (dragBounds != null) {
				container.x = MathUtil.clamp(container.x, dragBounds.left, dragBounds.right);
				container.y = MathUtil.clamp(container.y, dragBounds.top, dragBounds.bottom);
			}
			
			if (_isDragging == true) {
				dragEvent.emit();
			}
		}
	}
}