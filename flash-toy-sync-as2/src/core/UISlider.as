import flash.geom.Point;
import flash.geom.Rectangle;

class core.UISlider {
	
	public var track : MovieClip;
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
	
	function UISlider(_track : MovieClip, _handle : MovieClip, _isHorizontal : Boolean) {
		track = _track;
		handle = _handle;
		isHorizontal = _isHorizontal != undefined ? _isHorizontal : true;
		
		var trackBounds : Object = track._parent.getBounds(track._parent);
		var handleBounds : Object = handle.getBounds(handle._parent);
		
		var handleCenterX : Number = handleBounds.xMin + (handleBounds.xMax - handleBounds.xMin) / 2;
		var handleCenterY : Number = handleBounds.yMin + (handleBounds.yMax - handleBounds.yMin) / 2;
		
		handleCenterOffset = new Point(handleCenterX - handle._x, handleCenterY - handle._y);
		handleRegistrationPointOffset = new Point(handle._x - handleBounds.xMin, handle._y - handleBounds.yMin);
		
		handleMinX = trackBounds.xMin + handleRegistrationPointOffset.x;
		handleMaxX = handleMinX + (trackBounds.xMax - trackBounds.xMin) - handle._width;
		
		handleMinY = trackBounds.yMin + handleRegistrationPointOffset.y;
		handleMaxY = handleMinY + (trackBounds.yMax - trackBounds.yMin) - handle._height;
		
		var self = this;
		
		track.onPress = function() {
			self.onMouseDown();
		}
		track._parent.onEnterFrame = function() {
			self.onEnterFrame();
		}
		track.onRelease = function() {
			self.onMouseUp();
		}
		track.onReleaseOutside = function () {
			self.onMouseUp();
		}
	}
	
	public function get value() : Number {
		if (isHorizontal == true) {
			return getPercentage(handle._x, handleMinX, handleMaxX);
		}
		else {
			return getPercentage(handle._y, handleMinY, handleMaxY);
		}
	}
	public function set value(_value : Number) {
		if (isHorizontal == true) {
			handle._x = lerp(handleMinX, handleMaxX, _value);
			handle._x = Math.max(handleMinX, handle._x);
			handle._x = Math.min(handleMaxX, handle._x);
		}
		else {
			handle._y = lerp(handleMinY, handleMaxY, _value);
			handle._y = Math.max(handleMinY, handle._y);
			handle._y = Math.min(handleMaxY, handle._y);
		}
	}
	
	private function onMouseDown() {
		isMouseDown = true;
		if (onStartDrag != null) {
			onStartDrag(value);
		}
		updateHandle();
	}
	
	private function onEnterFrame() {
		if (isMouseDown == false) {
			return;
		}
		
		updateHandle();
		if (onDragging != null) {
			onDragging(value);
		}
	}
	
	private function onMouseUp() {
		isMouseDown = false;
		if (onStopDrag != null) {
			onStopDrag(value);
		}
	}
	
	private function updateHandle() {
		if (isHorizontal == true) {
			handle._x = handle._parent._xmouse - handleCenterOffset.x;
			handle._x = Math.max(handleMinX, handle._x);
			handle._x = Math.min(handleMaxX, handle._x);
		}
		else {
			handle._y = handle._parent._ymouse - handleCenterOffset.y;
			handle._y = Math.max(handleMinY, handle._y);
			handle._y = Math.min(handleMaxY, handle._y);
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