package core {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Stage;
	
	public class DraggableObject {
		
		public var screenBounds : Rectangle;
		
		public var bringToFrontOnDrag : Boolean;
		
		public var onStartDrag : CustomEvent;
		public var onStopDrag : CustomEvent;
		
		private var container : MovieClip;
		private var buttonMove : DisplayObject;
		
		private var isMouseDown : Boolean = false;
		private var mouseDragOffset : Point;
		
		function DraggableObject(_container : MovieClip, _buttonMove : DisplayObject) {
			container = _container;
			buttonMove = _buttonMove;
			
			onStartDrag = new CustomEvent();
			onStopDrag = new CustomEvent();
			
			_buttonMove.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMoveMouseDown);
			container.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			container.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onButtonMoveMouseDown(e : MouseEvent) : void {
			mouseDragOffset = container.parent.globalToLocal(new Point(e.stageX, e.stageY));
			mouseDragOffset.x -= container.x;
			mouseDragOffset.y -= container.y;
			
			if (bringToFrontOnDrag == true) {
				if (container.parent != null) {
					container.parent.setChildIndex(container, container.parent.numChildren - 1);
				}
			}
			
			isMouseDown = true;
			onStartDrag.emit();
		}
		
		private function onEnterFrame(e : Event) : void {
			if (isMouseDown == false) {
				return;
			}
			
			var mousePosition : Point = container.parent.globalToLocal(new Point(container.stage.mouseX, container.stage.mouseY));
			
			container.x = mousePosition.x - mouseDragOffset.x;
			container.y = mousePosition.y - mouseDragOffset.y;
			
			if (screenBounds != null) {
				container.x = Math.max(container.x, screenBounds.x);
				container.x = Math.min(container.x, screenBounds.x + screenBounds.width - container.width);
				container.y = Math.max(container.y, screenBounds.y);
				container.y = Math.min(container.y, screenBounds.y + screenBounds.height - buttonMove.height);
			}
		}
		
		private function onMouseUp(e : MouseEvent) : void {
			if (isMouseDown == false) {
				return;
			}
			
			isMouseDown = false;
			onStopDrag.emit();
		}
	}
}