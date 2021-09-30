/**
* The following class assumes that each element has it's registration point at the top left corner and that 0,0 is the top position
*/

package core {
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.Stage;
	
	public class UIScrollArea {
		
		public var content : DisplayObject;
		public var mask : DisplayObject;
		public var handle : DisplayObject;
		
		public var progress : Number = 0;
		
		private var stage : Stage;
		private var mouseDragOffset : Point;
		private var isMouseDown : Boolean = false;
		
		function UIScrollArea(_content : DisplayObject, _mask : DisplayObject, _handle : DisplayObject) {
			content = _content;
			mask = _mask;
			handle = _handle;
			
			stage = handle.stage;
			
			handle.addEventListener(MouseEvent.MOUSE_DOWN, onHandleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			handle.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onHandleMouseDown(e : MouseEvent) {
			mouseDragOffset = handle.parent.globalToLocal(new Point(e.stageX, e.stageY));
			mouseDragOffset.x -= handle.x;
			mouseDragOffset.y -= handle.y;
			
			isMouseDown = true;
		}
		
		private function onStageMouseUp(e : MouseEvent) {
			isMouseDown = false;
		}
		
		private function onEnterFrame(e : Event) {
			handle.height = mask.height * (mask.height / content.height);
			handle.height = Math.min(handle.height, mask.height);
			handle.y = getHandleYAtProgress();
			
			if (isMouseDown == false) {
				return;
			}
			
			var mousePosition : Point = handle.parent.globalToLocal(new Point(stage.mouseX, stage.mouseY));
			
			handle.y = mousePosition.y - mouseDragOffset.y;
			handle.y = Math.max(handle.y, 0);
			handle.y = Math.min(handle.y, mask.height - handle.height);
			progress = handle.y / (mask.height - handle.height);
			content.y = -(content.height - mask.height) * progress;
		}
		
		private function getHandleYAtProgress() {
			var range : Number = mask.height - handle.height;
			return range * progress;
		}
	}
}