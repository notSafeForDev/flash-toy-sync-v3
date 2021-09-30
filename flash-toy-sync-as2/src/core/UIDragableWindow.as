import flash.geom.Point;
import flash.geom.Rectangle;

class core.UIDragableWindow {
	
	public var screenBounds : Rectangle;
	
	private var container : MovieClip;
	private var buttonMove : MovieClip;
	
	private var isMouseDown : Boolean = false;
	private var mouseDragOffset : Point;
	
	function UIDragableWindow(_container : MovieClip, _buttonMove : MovieClip) {
		var self = this;
		
		container = _container;
		buttonMove = _buttonMove;
		
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
		
		isMouseDown = true;
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
		isMouseDown = false;
	}
}