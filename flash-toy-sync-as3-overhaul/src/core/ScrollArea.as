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
	
	public class ScrollArea {
		
		public var content : DisplayObject;
		public var mask : DisplayObject;
		public var scrollBar : MovieClip;
		
		private var stage : Stage;
		
		private var progress : Number = 0;
		private var mouseDragOffset : Point;
		private var isMouseDown : Boolean = false;
		
		private var disabledHandleAlpha : Number = 0.5;
		
		function ScrollArea(_content : DisplayObject, _mask : DisplayObject, _scrollBar : MovieClip) : void {
			content = _content;
			mask = _mask;
			scrollBar = _scrollBar;
			
			scrollBar.buttonMode = true;
			
			content.mask = mask;
			
			stage = scrollBar.stage;
			
			scrollBar.addEventListener(MouseEvent.MOUSE_DOWN, onHandleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			scrollBar.addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
			mouseDragOffset = scrollBar.parent.globalToLocal(new Point(e.stageX, e.stageY));
			mouseDragOffset.x -= scrollBar.x;
			mouseDragOffset.y -= scrollBar.y;
			
			isMouseDown = true;
		}
		
		private function onStageMouseUp(e : MouseEvent) : void {
			isMouseDown = false;
		}
		
		private function onEnterFrame(e : Event) : void {
			scrollBar.height = mask.height * (mask.height / content.height);
			scrollBar.height = Math.min(scrollBar.height, mask.height);
			scrollBar.y = getHandleYAtProgress();
			scrollBar.alpha = scrollBar.height >= mask.height ? disabledHandleAlpha : 1;
			
			if (isMouseDown == false) {
				return;
			}
			
			var mousePosition : Point = scrollBar.parent.globalToLocal(new Point(stage.mouseX, stage.mouseY));
			
			scrollBar.y = mousePosition.y - mouseDragOffset.y;
			scrollBar.y = Math.max(scrollBar.y, 0);
			scrollBar.y = Math.min(scrollBar.y, mask.height - scrollBar.height);
			progress = scrollBar.y / (mask.height - scrollBar.height);
			content.y = -(content.height - mask.height) * progress;
		}
		
		private function getHandleYAtProgress() : Number {
			var range : Number = mask.height - scrollBar.height;
			return range * progress;
		}
	}
}