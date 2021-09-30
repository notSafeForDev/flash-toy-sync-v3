package core {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class UIButton {
		
		public var element : DisplayObject;
		public var onMouseDown : Function;
		public var onMouseUp : Function;
		
		function UIButton(_button : DisplayObject) {
			element = _button;
			
			_button.addEventListener(MouseEvent.MOUSE_DOWN, function(e : MouseEvent) {
				if (onMouseDown != null) {
					onMouseDown();
				}
			});
			
			_button.addEventListener(MouseEvent.MOUSE_UP, function(e : MouseEvent) {
				if (onMouseUp != null) {
					onMouseUp();
				}
			});
		}
	}
}