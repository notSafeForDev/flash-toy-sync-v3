import flash.geom.Point;
import flash.geom.Rectangle;

import core.CustomEvent;

class core.DraggableObject {
	
	public var screenBounds : Rectangle;
	
	public var bringToFrontOnDrag : Boolean;
	
	public var onStartDrag : CustomEvent;
	public var onStopDrag : CustomEvent;
	
	private var container : MovieClip;
	private var buttonMove : MovieClip;
	
	private var isMouseDown : Boolean = false;
	private var mouseDragOffset : Point;
	
	function DraggableObject(_container : MovieClip, _buttonMove : MovieClip) {
		var self = this;
		
		container = _container;
		buttonMove = _buttonMove;
		
		onStartDrag = new CustomEvent();
		onStopDrag = new CustomEvent();
		
		_buttonMove.onPress = function() {
			self.onButtonMoveMouseDown();
		}
		var previousOnEnterFrame : Function = _container.onEnterFrame;
		_container.onEnterFrame = function() {
			if (previousOnEnterFrame != null) {
				previousOnEnterFrame();
			}
			self.onEnterFrame();
		}
		_buttonMove.onRelease = function() {
			self.onMouseUp();
		}
		_buttonMove.onReleaseOutside = function() {
			self.onMouseUp();
		}
	}
	
	function onButtonMoveMouseDown() {
		mouseDragOffset = new Point(container._root._xmouse, container._root._ymouse);
		container._parent.globalToLocal(mouseDragOffset);
		mouseDragOffset.x -= container._x;
		mouseDragOffset.y -= container._y;
		
		if (bringToFrontOnDrag == true) {
			if (container._parent != null) {
				container.swapDepths(container._parent.getNextHighestDepth());
			}
		}
		
		isMouseDown = true;
		onStartDrag.emit();
	}
	
	function onEnterFrame() {
		if (isMouseDown == false) {
			return;
		}
		
		var mousePosition : Point = new Point(container._root._xmouse, container._root._ymouse);
		container._parent.globalToLocal(mousePosition);
		
		container._x = mousePosition.x - mouseDragOffset.x;
		container._y = mousePosition.y - mouseDragOffset.y;
		
		if (screenBounds != null) {
			container._x = Math.max(container._x, screenBounds.x);
			container._x = Math.min(container._x, screenBounds.x + screenBounds.width - container._width);
			container._y = Math.max(container._y, screenBounds.y);
			container._y = Math.min(container._y, screenBounds.y + screenBounds.height - buttonMove._height);
		}
	}
	
	function onMouseUp() {
		if (isMouseDown == false) {
			return;
		}
		
		isMouseDown = false;
		onStopDrag.emit();
	}
}