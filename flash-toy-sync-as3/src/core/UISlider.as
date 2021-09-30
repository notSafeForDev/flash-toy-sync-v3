package core {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class UISlider {
		
		public var track : DisplayObject;
		public var handle : MovieClip;
		
		public var isHorizontal : Boolean;
		
		public var onStartDrag : Function;
		public var onDragging : Function;
		public var onStopDrag : Function;
		
		private var isMouseDown : Boolean = false;
		
		private var handleCenterOffset : Point;
		private var handleRegistrationPointOffset : Point;
		
		private var handleMinX : Number;
		private var handleMaxX : Number;
		private var handleMinY : Number;
		private var handleMaxY : Number;
		
		function UISlider(_track : DisplayObject, _handle : MovieClip, _isHorizontal : Boolean = true) {
			track = _track;
			handle = _handle;
			isHorizontal = _isHorizontal;
			
			handle.mouseEnabled = false;
			
			if (_track is MovieClip) {
				MovieClip(track).buttonMode = true;
			}
			
			var trackBounds : Rectangle = track.getBounds(track.parent);
			var handleBounds : Rectangle = handle.getBounds(handle.parent);
			
			var handleCenterX : Number = handleBounds.x + handleBounds.width / 2;
			var handleCenterY : Number = handleBounds.y + handleBounds.height / 2;
			
			handleCenterOffset = new Point(handleCenterX - handle.x, handleCenterY - handle.y);
			handleRegistrationPointOffset = new Point(handle.x - handleBounds.x, handle.y - handleBounds.y);
			
			handleMinX = trackBounds.x + handleRegistrationPointOffset.x;
			handleMaxX = handleMinX + trackBounds.width - handle.width;
			
			handleMinY = trackBounds.y + handleRegistrationPointOffset.y;
			handleMaxY = handleMinY + trackBounds.height - handle.height;
			
			track.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			track.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			track.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function get value() : Number {
			if (isHorizontal == true) {
				return getPercentage(handle.x, handleMinX, handleMaxX);
			}
			else {
				return getPercentage(handle.y, handleMinY, handleMaxY);
			}
		}
		public function set value(_value : Number) {
			if (isHorizontal == true) {
				handle.x = lerp(handleMinX, handleMaxX, _value);
				handle.x = Math.max(handleMinX, handle.x);
				handle.x = Math.min(handleMaxX, handle.x);
			}
			else {
				handle.y = lerp(handleMinY, handleMaxY, _value);
				handle.y = Math.max(handleMinY, handle.y);
				handle.y = Math.min(handleMaxY, handle.y);
			}
		}
		
		private function onMouseDown(e : MouseEvent) {
			isMouseDown = true;
			if (onStartDrag != null) {
				onStartDrag(value);
			}
			updateHandle();
		}
		
		private function onEnterFrame(e : Event) {
			if (isMouseDown == false) {
				return;
			}
			
			updateHandle();
			if (onDragging != null) {
				onDragging(value);
			}
		}
		
		private function onMouseUp(e : MouseEvent) {
			if (isMouseDown == false) {
				return;
			}
			
			isMouseDown = false;
			if (onStopDrag != null) {
				onStopDrag(value);
			}
		}
		
		private function updateHandle() {
			if (isHorizontal == true) {
				handle.x = handle.parent.mouseX - handleCenterOffset.x;
				handle.x = Math.max(handleMinX, handle.x);
				handle.x = Math.min(handleMaxX, handle.x);
			}
			else {
				handle.y = handle.parent.mouseY - handleCenterOffset.y;
				handle.y = Math.max(handleMinY, handle.y);
				handle.y = Math.min(handleMaxY, handle.y);
			}
		}
		
		private function lerp(_from : Number, _to : Number, _progress : Number) : Number {
			return (1 - _progress) * _from + _progress * _to;
		}
		
		private function getPercentage(_value : Number, _from : Number, _to : Number) : Number {
			if (_value == _from) {
				return 0;
			}
			if (_from == _to) {
				throw "Unable to get percentage, both from and to values are the same";
			}
			
			return (_value - _from) / (_to - _from);
		}
	}
}