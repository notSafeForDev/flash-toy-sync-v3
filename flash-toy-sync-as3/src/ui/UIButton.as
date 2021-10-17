package ui {
	
	import flash.display.MovieClip;
	
	import core.DisplayObjectUtil;
	import core.MouseEvents;
	import core.CustomEvent;
	
	public class UIButton {
		
		public var element : MovieClip;
		
		/** Gets emitted when the user presses their mouse button */
		public var onMouseDown : CustomEvent;
		/** Gets emitted when the user releases their mouse button */
		public var onMouseUp : CustomEvent;
		/** Gets emitted when the user releases their mouse button without dragging */
		public var onMouseClick : CustomEvent;
		/** Gets emitted when the user first moves their mouse while it is pressed */
		public var onStartDrag : CustomEvent;
		
		public var isMouseDown : Boolean;
		public var isMouseOver : Boolean;
		public var isDragging : Boolean;
		
		public var disabledAlpha : Number = 1;
		
		function UIButton(_button : MovieClip) {
			element = _button;
			
			element.buttonMode = true;
			element.mouseEnabled = true;
			
			onMouseDown = new CustomEvent();
			onMouseUp = new CustomEvent();
			onMouseClick = new CustomEvent();
			onStartDrag = new CustomEvent();
			
			MouseEvents.addOnMouseOver(this, element, _onMouseOver);
			MouseEvents.addOnMouseOut(this, element, _onMouseOut);
			MouseEvents.addOnMouseDown(this, element, _onMouseDown);
			MouseEvents.addOnMouseUp(this, element, _onMouseUp);
			MouseEvents.addOnMouseMove(this, element, _onMouseMove);
		}
		
		private function _onMouseOver() : void {
			isMouseOver = true;
		}
		
		private function _onMouseOut() : void {
			isMouseOver = false;
			isMouseDown = false;
			isDragging = false;
		}
		
		private function _onMouseDown() : void {
			isMouseDown = true;
			isDragging = false;
			onMouseDown.emit();
		}
		
		private function _onMouseUp() : void {
			var wasDragging : Boolean = isDragging;
			isMouseDown = false;
			isDragging = false;
			
			onMouseUp.emit();
			if (wasDragging == false) {
				onMouseClick.emit();
			}
		}
		
		private function _onMouseMove() : void {
			if (isMouseDown == true && isDragging == false) {
				onStartDrag.emit();
				isDragging = true;
			}
		}
		
		public function enable() : void {
			element.buttonMode = true;
			element.mouseEnabled = true;
			DisplayObjectUtil.setAlpha(element, 1);
		}
		
		public function disable() : void {
			element.buttonMode = false;
			element.mouseEnabled = false;
			DisplayObjectUtil.setAlpha(element, disabledAlpha);
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