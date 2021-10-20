package components {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.CustomEvent;
	import core.DisplayObjectUtil;
	import core.stateTypes.DisplayObjectState;
	import core.stateTypes.PointState;
	
	import ui.ScriptMarkerElement;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptMarker {
		
		public var onStartDrag : CustomEvent;
		public var onStopDrag : CustomEvent;
		
		public var element : ScriptMarkerElement;
		public var attachedToState : DisplayObjectState;
		public var pointState : PointState;
		
		private var animation : MovieClip;
		
		private var attachedToReference : DisplayObjectReference;
		
		public function ScriptMarker(_animation : MovieClip, _element : ScriptMarkerElement, _attachedToState : DisplayObjectState, _pointState : PointState) {
			onStartDrag = new CustomEvent();
			onStopDrag = new CustomEvent();
			
			animation = _animation;
			element = _element;
			attachedToState = _attachedToState;
			pointState = _pointState;
			
			element.draggable.onStartDrag.listen(this, onElementStartDrag);
			element.onStopDrag.listen(this, onElementStopDrag);
		}
		
		public function attachTo(_child : DisplayObject, _keepPosition : Boolean) : void {
			var point : Point = DisplayObjectUtil.globalToLocal(_child, element.getX(), element.getY());
			
			if (_keepPosition == false) {
				var parent : DisplayObjectContainer = DisplayObjectUtil.getParent(element.element);
				var bounds : Rectangle = DisplayObjectUtil.getBounds(_child, parent);
				var centerX : Number = bounds.x + bounds.width / 2;
				var centerY : Number = bounds.y + bounds.height / 2;
				
				point = DisplayObjectUtil.globalToLocal(_child, centerX, centerY);
			}
			
			attachedToState.setValue(_child);
			pointState.setValue(point);
			attachedToReference = new DisplayObjectReference(animation, _child);
		}
		
		public function update() : void {
			if (attachedToState.getValue() == null && element.isDragging == false) {
				element.setVisible(false);
				return;
			}
			
			if (attachedToState.getValue() != null) {
				attachedToReference.update();
			
				if (DisplayObjectUtil.isNested(animation, attachedToState.getValue()) == false) {
					var replacement : DisplayObject = attachedToReference.getObject();
					if (replacement != null) {
						attachedToState.setValue(replacement);
					} else {
						attachedToState.setValue(null);
						pointState.setValue(null);
						attachedToReference = null;
						return;
					}
				}
			}
			
			element.setVisible(true);
			
			if (element.isDragging == true) {
				return;
			}
			
			var globalPoint : Point = DisplayObjectUtil.localToGlobal(attachedToState.getValue(), pointState.getValue().x, pointState.getValue().y);
			element.setPosition(globalPoint);
		}
		
		public function startDrag() : void {
			element.draggable.moveToCursor();
			element.draggable.startDrag();
		}
		
		public function detatch() : void {
			attachedToState.setValue(null);
			pointState.setValue(null);
			attachedToReference = null;
		}
		
		private function onElementStartDrag() : void {
			onStartDrag.emit();
		}
		
		private function onElementStopDrag() : void {
			if (attachedToState.getValue() != null) {
				var point : Point = DisplayObjectUtil.globalToLocal(attachedToState.getValue(), element.getX(), element.getY());
				pointState.setValue(point);
			}
			
			onStopDrag.emit();
		}
	}
}