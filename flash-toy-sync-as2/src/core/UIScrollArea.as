/**
* The following class assumes that each element has it's registration point at the top left corner and that 0,0 is the top position
*/

import flash.geom.Point;
import flash.geom.Rectangle;

import core.DisplayObjectUtil;

class core.UIScrollArea {
	
	public var content : MovieClip;
	public var mask : MovieClip;
	public var handle : MovieClip;
	
	public var handleAlphaWhenNotScrollable : Number = 1;
	
	public var progress : Number = 0;
	
	private var stage : Stage;
	private var mouseDragOffset : Point;
	private var isMouseDown : Boolean = false;
	
	function UIScrollArea(_content : MovieClip, _mask : MovieClip, _handle : MovieClip) {
		content = _content;
		mask = _mask;
		handle = _handle;
		
		content.setMask(mask);
		
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
	
	public function isElementVisible(_child : MovieClip) : Boolean {
		var yInsideMask : Number = _child._y + content._y;
		return yInsideMask + _child._height >= 0 && yInsideMask <= mask._height;
	}
	
	public function isElementBoundsVisible(_child : MovieClip) : Boolean {
		var maskBounds : Rectangle = DisplayObjectUtil.getBounds(mask, content._parent);
		var childBounds : Rectangle = DisplayObjectUtil.getBounds(_child, content._parent);
		return maskBounds.intersects(childBounds);
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
		handle._alpha = handle._height >= mask._height ? (handleAlphaWhenNotScrollable * 100) : 100;
		
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