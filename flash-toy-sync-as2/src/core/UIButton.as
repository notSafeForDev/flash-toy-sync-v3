class core.UIButton {
	
	public var element : MovieClip;
	public var onMouseDown : Function;
	public var onMouseUp : Function;
	
	function UIButton(_button : MovieClip) {
		var self = this;
		
		element = _button;
		
		_button.onPress = function() {
			if (self.onMouseDown != null) {
				self.onMouseDown();
			}
		}
		
		_button.onRelease = function() {
			if (self.onMouseUp != null) {
				self.onMouseUp();
			}
		}
	}
}