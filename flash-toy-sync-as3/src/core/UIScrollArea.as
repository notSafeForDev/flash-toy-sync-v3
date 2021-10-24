/**
* The following class assumes that each element has it's registration point at the top left corner and that 0,0 is the top position
*/

package core {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	public class UIScrollArea {
		
		public var content : DisplayObject;
		public var mask : DisplayObject;
		public var handle : MovieClip;
		
		public var disabledHandleAlpha : Number = 1;
		
		public var progress : Number = 0;
		
		private var stage : Stage;
		private var mouseDragOffset : Point;
		private var isMouseDown : Boolean = false;
		
		function UIScrollArea(_content : DisplayObject, _mask : DisplayObject, _handle : MovieClip) : void {
			content = _content;
			mask = _mask;
			handle = _handle;
			
			handle.buttonMode = true;
			
			content.mask = mask;
			
			stage = handle.stage;
			
			handle.addEventListener(MouseEvent.MOUSE_DOWN, onHandleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			handle.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Checks if an element is inside the mask vertically, assuming it's origin is at the top
		 * @param	_child		A child of the content container
		 * @return	Whether it's visible or not
		 */
		public function isElementVisible(_child : DisplayObject) : Boolean {
			var yInsideMask : Number = _child.y + content.y;
			return yInsideMask + _child.height >= 0 && yInsideMask <= mask.height;
		}
		
		/**
		 * Checks if an element bounds is visible inside the mask, should only be used when isElementVisible isn't sufficient as this is significantly slower
		 * @param	_child		A child of the content container
		 * @return 	Whether it's visible or not
		 */
		public function isElementBoundsVisible(_child : DisplayObject) : Boolean {
			var maskBounds : Rectangle = mask.getBounds(content.parent);
			var childBounds : Rectangle = _child.getBounds(content.parent);
			return maskBounds.intersects(childBounds);
		}
		
		/**
		 * Makes the scroll area snap to a child in order to make it visible
		 * @param	_child
		 */
		public function scrollTo(_child : DisplayObject) : void {
			if (content.height <= mask.height) {
				return;
			}
			
			var yInsideMask : Number = _child.y + content.y;
			var offset : Number = 0;
			if (yInsideMask > mask.height - _child.height) {
				offset = yInsideMask - mask.height + _child.height;
			}
			if (yInsideMask < 0) {
				offset = yInsideMask;
			}
			var extraContentHeight : Number = (content.height - mask.height);
			progress += offset / extraContentHeight;
			content.y = -extraContentHeight * progress;
		}
		
		private function onHandleMouseDown(e : MouseEvent) : void {
			mouseDragOffset = handle.parent.globalToLocal(new Point(e.stageX, e.stageY));
			mouseDragOffset.x -= handle.x;
			mouseDragOffset.y -= handle.y;
			
			isMouseDown = true;
		}
		
		private function onStageMouseUp(e : MouseEvent) : void {
			isMouseDown = false;
		}
		
		private function onEnterFrame(e : Event) : void {
			handle.height = mask.height * (mask.height / content.height);
			handle.height = Math.min(handle.height, mask.height);
			handle.y = getHandleYAtProgress();
			handle.alpha = handle.height >= mask.height ? disabledHandleAlpha : 1;
			
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
		
		private function getHandleYAtProgress() : Number {
			var range : Number = mask.height - handle.height;
			return range * progress;
		}
	}
}