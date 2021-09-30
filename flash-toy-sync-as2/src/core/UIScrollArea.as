/**
* The following class assumes that each element has it's registration point at the top left corner and that 0,0 is the top position
*/

import flash.geom.Point;

class core.UIScrollArea {
	
	public var content : MovieClip;
	public var mask : MovieClip;
	public var handle : MovieClip;
	
	public var progress : Number = 0;
	
	private var stage : Stage;
	private var mouseDragOffset : Point;
	private var isMouseDown : Boolean = false;
	
	function UIScrollArea(_content : MovieClip, _mask : MovieClip, _handle : MovieClip) {
		content = _content;
		mask = _mask;
		handle = _handle;
		
		stage = handle.stage;
		
		var self = this;
		
		handle.onPress = function() {
			self.onHandleMouseDown();
		}
		var previousOnEnterFrame : Function = handle._parent.onEnterFrame;
		handle._parent.onEnterFrame = function() {
			if (previousOnEnterFrame != null) {
				previousOnEnterFrame();
			}
			self.onEnterFrame();
		}
		handle.onRelease = function() {
			self.onMouseUp();
		}
		handle.onReleaseOutside = function() {
			self.onMouseUp();
		}
	}
	
	private function onHandleMouseDown() {
		mouseDragOffset = new Point(handle._root._xmouse, handle._root._ymouse);
		handle._parent.globalToLocal(mouseDragOffset);
		mouseDragOffset.x -= handle._x;
		mouseDragOffset.y -= handle._y;
		
		isMouseDown = true;
	}
	
	private function onMouseUp() {
		isMouseDown = false;
	}
	
	private function onEnterFrame() {
		handle._height = mask._height * (mask._height / content._height);
		handle._height = Math.min(handle._height, mask._height);
		handle._y = getHandleYAtProgress();
		
		if (isMouseDown == false) {
			return;
		}
		
		var mousePosition : Point = new Point(handle._root._xmouse, handle._root._ymouse);
		handle._parent.globalToLocal(mousePosition);
		
		handle._y = mousePosition.y - mouseDragOffset.y;
		handle._y = Math.max(handle._y, 0);
		handle._y = Math.min(handle._y, mask._height - handle._height);
		progress = handle._y / (mask._height - handle._height);
		content._y = -(content._height - mask._height) * progress;
	}
	
	private function getHandleYAtProgress() {
		var range : Number = mask._height - handle._height;
		return range * progress;
	}
}