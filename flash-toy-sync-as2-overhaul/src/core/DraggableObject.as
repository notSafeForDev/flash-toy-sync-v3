import core.TPDisplayObject;
import flash.geom.Point;
import flash.geom.Rectangle;
import utils.MathUtil;

import core.CustomEvent;

class core.DraggableObject {
	
	public var dragBounds : Rectangle;
	
	public var bringToFrontOnDrag : Boolean;
	
	public var startDragEvent : CustomEvent;
	public var stopDragEvent : CustomEvent;
	public var dragEvent : CustomEvent;
	
	private var container : MovieClip;
	private var hitArea : MovieClip;
	
	private var _isDragging : Boolean = false;
	private var mouseDragOffset : Point;
	
	function DraggableObject(_container : TPDisplayObject, _hitArea : TPDisplayObject) {
		var self = this;
		
		container = _container.sourceDisplayObject;
		hitArea = _hitArea != undefined ? _hitArea.sourceDisplayObject : container;
		
		startDragEvent = new CustomEvent();
		stopDragEvent = new CustomEvent();
		dragEvent = new CustomEvent();
		
		hitArea.onPress = function() {
			self.onButtonMoveMouseDown();
		}
		var previousOnEnterFrame : Function = container.onEnterFrame;
		container.onEnterFrame = function() {
			if (previousOnEnterFrame != null) {
				previousOnEnterFrame();
			}
			self.onEnterFrame();
		}
		hitArea.onMouseUp = function() {
			self.onMouseUp();
		}
	}
	
	public function moveToCursor() : Void {
		container._x = container._parent._xmouse;
		container._y = container._parent._ymouse;
	}
	
	public function startDrag() : Void {
		mouseDragOffset = new Point(container._root._xmouse, container._root._ymouse);
		container._parent.globalToLocal(mouseDragOffset);
		mouseDragOffset.x -= container._x;
		mouseDragOffset.y -= container._y;
		
		if (bringToFrontOnDrag == true) {
			if (container._parent != null) {
				// TODO: Fix so that the depth doesn't shift around time this is called
				container.swapDepths(container._parent.getNextHighestDepth());
			}
		}
		
		_isDragging = true;
		startDragEvent.emit();
	}
	
	public function stopDrag() : Void {
		if (_isDragging == false) {
			return;
		}
		
		_isDragging = false;
		stopDragEvent.emit();
	}
	
	public function isDragging() : Boolean {
		return _isDragging;
	}
	
	private function onButtonMoveMouseDown() : Void {
		startDrag();
	}
	
	private function onMouseUp() : Void {
		stopDrag();
	}
	
	private function onEnterFrame() : Void {
		if (_isDragging == false) {
			return;
		}
		
		var mousePosition : Point = new Point(container._root._xmouse, container._root._ymouse);
		container._parent.globalToLocal(mousePosition);
		
		container._x = mousePosition.x - mouseDragOffset.x;
		container._y = mousePosition.y - mouseDragOffset.y;
		
		if (dragBounds != null) {
			container._x = MathUtil.clamp(container._x, dragBounds.left, dragBounds.right);
			container._y = MathUtil.clamp(container._y, dragBounds.top, dragBounds.bottom);
		}
		
		dragEvent.emit();
	}
}