package components {
	
	import core.CustomEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import core.Timeout;
	import core.KeyboardManager;
	import core.StageUtil;
	import core.GraphicsUtil;
	import core.MouseEvents;
	import core.DisplayObjectUtil;

	import global.GlobalEvents;
	import global.GlobalState;

	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StageElementSelector {
		
		public var onSelectChild : CustomEvent;
		
		private var container : MovieClip;
		private var overlay : MovieClip;
		
		private var keyboardManager : KeyboardManager;
		
		private var highlightSelectedChildTimeout : Number;
		private var shouldHighlightSelectedChild : Boolean;
		
		private var childAtCursor : DisplayObject;
		
		private var tempRef : DisplayObjectReference;
		
		public function StageElementSelector(_container : MovieClip, _overlay : MovieClip) {
			container = _container;
			overlay = _overlay;
			
			onSelectChild = new CustomEvent();
			
			keyboardManager = new KeyboardManager(_container);
			highlightSelectedChildTimeout = -1;
			
			MouseEvents.addOnMouseDownPassThrough(this, container, onMouseDown);
			GlobalEvents.enterFrame.listen(this, onEnterFrame);
			GlobalState.listen(this, onSelectedChildChanged, [GlobalState.selectedChild]);
		}
		
		private function onEnterFrame() : void {
			GraphicsUtil.clear(overlay);
			
			if (keyboardManager.isKeyPressed(Keyboard.E) == true) {
				childAtCursor = getChildAtMousePosition(GlobalState.selectedChild.state || container);
				drawBoundsForObject(GlobalState.selectedChild.state || container);
				if (childAtCursor != null) {
					drawBoundsForObject(childAtCursor);
				}
			} else {
				childAtCursor = null;
			}
			
			if (shouldHighlightSelectedChild == true) {
				drawBoundsForObject(GlobalState.selectedChild.state);
			}
			
			if (tempRef != null) {
				drawBounds(tempRef.getBounds(overlay), DisplayObjectUtil.isShape(tempRef.getObject()));
			}
		}
		
		private function onSelectedChildChanged() : void {
			if (GlobalState.selectedChild.state == null) {
				shouldHighlightSelectedChild = false;
				return;
			}
		
			Timeout.clear(highlightSelectedChildTimeout);
			shouldHighlightSelectedChild = true;
			highlightSelectedChildTimeout = Timeout.set(this, stopHighlightingSelectedChild, 500);
		}
		
		private function stopHighlightingSelectedChild() : void {
			shouldHighlightSelectedChild = false;
		}
		
		private function onMouseDown() : void {
			if (keyboardManager.isKeyPressed(Keyboard.E) == false) {
				return;
			}
			
			if (childAtCursor != null) {
				onSelectChild.emit(childAtCursor);
				tempRef = new DisplayObjectReference(childAtCursor);
			}
		}
		
		private function getChildAtMousePosition(_topParent : DisplayObjectContainer) : DisplayObject {
			var child : DisplayObject = _topParent;
			var children : Array = DisplayObjectUtil.getChildren(_topParent);
			var bounds : Rectangle = null;
			var isFirstIteration : Boolean = true;
			var isDone : Boolean = false;
			var stageMousePoint : Point = new Point(StageUtil.getMouseX(), StageUtil.getMouseY());
			
			while (isDone == false) {
				var closestChild : DisplayObject = null;
				var closestChildDistance : Number = -1;
				var closestChildBounds : Rectangle = null;
				
				// We iterate from the last child to the first, as they are ordered from highest to lowest depth
				for (var i : Number = children.length - 1; i >= 0; i--) {
					var childBounds : Rectangle = DisplayObjectUtil.getBounds(children[i], DisplayObjectUtil.getParent(container));
					if (childBounds.containsPoint(stageMousePoint) == false) {
						continue;
					}
					if (childBounds.width >= StageUtil.getWidth() && childBounds.height >= StageUtil.getHeight()) {
						continue;
					}
					if (isFirstIteration == true && DisplayObjectUtil.hitTest(children[i], stageMousePoint.x, stageMousePoint.y, true) == true) {
						closestChild = children[i];
						break;
					} else if (isFirstIteration == true) {
						continue;
					}
					if (DisplayObjectUtil.isShape(children[i]) == true && getBoundsDifferences(childBounds, bounds) < 10) {
						continue;
					}
					var boundsCenterPoint : Point = new Point(childBounds.x + childBounds.width / 2, childBounds.y + childBounds.height / 2);
					var distance : Number = Point.distance(stageMousePoint, boundsCenterPoint);
					if (closestChild == null || distance < closestChildDistance) {
						closestChild = children[i];
						closestChildDistance = distance;
						closestChildBounds = childBounds;
					}
				}
				if (closestChild != null) {
					child = closestChild;
					children = DisplayObjectUtil.getChildren(child);
					bounds = DisplayObjectUtil.getBounds(child, DisplayObjectUtil.getParent(container));
				} else {
					isDone = true;
				}
				isFirstIteration = false;
			}
			
			return child;
		}
		
		private function getBoundsDifferences(_a : Rectangle, _b : Rectangle) : Number {
			return Math.abs(_a.width - _b.width) + Math.abs(_a.height - _b.height) + Math.abs(_a.x - _b.x) + Math.abs(_a.y - _b.y);
		}
		
		private function drawBoundsForObject(_object : DisplayObject) : void {
			if (_object != null) {
				drawBounds(DisplayObjectUtil.getBounds(_object, overlay), DisplayObjectUtil.isShape(_object));
			}
		}
		
		private function drawBounds(_bounds : Rectangle, _isShape : Boolean) : void {
			if (_isShape == true) {
				GraphicsUtil.setLineStyle(overlay, 2, 0xFFFF00);
			} else {
				GraphicsUtil.setLineStyle(overlay, 4, 0x00FF00);
			}
			
			GraphicsUtil.drawRect(overlay, _bounds.x, _bounds.y, _bounds.width, _bounds.height);
		}
	}
}