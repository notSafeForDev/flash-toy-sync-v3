package ui {
	
	import core.TPMovieClip;
	import core.MouseEvents;
	import core.CustomEvent;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class UIButton {
		
		public var element : TPMovieClip;
		
		/** Gets emitted when the user presses their mouse button */
		public var mouseDownEvent : CustomEvent;
		/** Gets emitted when the user releases their mouse button */
		public var mouseUpEvent : CustomEvent;
		/** Gets emitted when the user releases their mouse button without dragging */
		public var mouseClickEvent : CustomEvent;
		/** Gets emitted when the user first moves their mouse while it is pressed */
		public var startDragEvent : CustomEvent;
		
		public var isMouseDown : Boolean;
		public var isMouseOver : Boolean;
		public var isDragging : Boolean;
		
		public var disabledAlpha : Number = 0.5;
		
		private var defaultColorTransform : ColorTransform;
		private var overColorTransform : ColorTransform;
		private var downColorTransform : ColorTransform;
		private var disabledColorTransform : ColorTransform;
		
		function UIButton(_button : TPMovieClip) {
			element = _button;
			
			element.buttonMode = true;
			element.sourceMovieClip.mouseEnabled = true;
			
			defaultColorTransform = new ColorTransform();
			overColorTransform = new ColorTransform();
			disabledColorTransform = new ColorTransform();
			
			overColorTransform.redOffset = 100;
			overColorTransform.greenOffset = 100;
			overColorTransform.blueOffset = 100;
			
			disabledColorTransform.redMultiplier = 0.5;
			disabledColorTransform.greenMultiplier = 0.5;
			disabledColorTransform.blueMultiplier = 0.5;
			
			mouseDownEvent = new CustomEvent();
			mouseUpEvent = new CustomEvent();
			mouseClickEvent = new CustomEvent();
			startDragEvent = new CustomEvent();
			
			MouseEvents.addOnMouseOver(this, _button.sourceMovieClip, _onMouseOver);
			MouseEvents.addOnMouseOut(this, _button.sourceMovieClip, _onMouseOut);
			MouseEvents.addOnMouseDown(this, _button.sourceMovieClip, _onMouseDown);
			MouseEvents.addOnMouseUp(this, _button.sourceMovieClip, _onMouseUp);
			MouseEvents.addOnMouseMove(this, _button.sourceMovieClip, _onMouseMove);
		}
		
		private function _onMouseOver() : void {
			if (element.buttonMode == false) { // Needed for AS2
				return;
			}
			
			isMouseOver = true;
			
			element.colorTransform = overColorTransform;
		}
		
		private function _onMouseOut() : void {
			if (element.buttonMode == false) {
				return;
			}
			
			isMouseOver = false;
			isMouseDown = false;
			isDragging = false;
			
			element.colorTransform = defaultColorTransform;
		}
		
		private function _onMouseDown() : void {
			if (element.buttonMode == false) {
				return;
			}
			
			isMouseDown = true;
			isDragging = false;
			mouseDownEvent.emit();
			
			// Due to differences in mouse out behaviour from AS3 and AS2, 
			// we use the default colorTransform for mouse down, as opposed to a different one
			element.colorTransform = defaultColorTransform;
		}
		
		private function _onMouseUp() : void {
			if (element.buttonMode == false) {
				return;
			}
			
			var wasDragging : Boolean = isDragging;
			isMouseDown = false;
			isDragging = false;
			
			mouseUpEvent.emit();
			if (wasDragging == false) {
				mouseClickEvent.emit();
			}
			
			element.colorTransform = overColorTransform;
		}
		
		private function _onMouseMove() : void {
			if (element.buttonMode == false) {
				return;
			}
			
			if (isMouseDown == true && isDragging == false) {
				startDragEvent.emit();
				isDragging = true;
			}
		}
		
		public function enable() : void {
			element.buttonMode = true;
			element.sourceMovieClip.mouseEnabled = true;
			
			if (isMouseOver) {
				element.colorTransform = overColorTransform;
			} else {
				element.colorTransform = defaultColorTransform;
			}
		}
		
		public function disable() : void {
			element.buttonMode = false;
			element.sourceMovieClip.mouseEnabled = false;
			
			element.colorTransform = disabledColorTransform;
		}
		
		public function setEnabled(_enabled : Boolean) : void {
			if (_enabled == true) {
				enable();
			} else {
				disable();
			}
		}
	}
}