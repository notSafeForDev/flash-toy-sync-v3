class core.StageUtil {
	
	// Only used to create parity with the AS3 version
	private static var initialized : Boolean = false;
	
	public static function initialize() : Void {
		initialized = true;
	}
	
	static function makeWindowed() : Void {
		if (initialized == false) {
			trace("The StageUtil has to be initialized before any of it's other functions can be called");
		}
		Stage.displayState = "normal";
	}
	
	static function makeFullscreen() : Void {
		if (initialized == false) {
			trace("The StageUtil has to be initialized before any of it's other functions can be called");
		}
		Stage.displayState = "fullscreen";
	}
	
	static function isWindowed() : Boolean {
		if (initialized == false) {
			trace("The StageUtil has to be initialized before any of it's other functions can be called");
		}
		return Stage.displayState == "normal";
	}
	
	static function isFullscreen() : Boolean {
		if (initialized == false) {
			trace("The StageUtil has to be initialized before any of it's other functions can be called");
		}
		return Stage.displayState != "normal";
	}
	
	static function getWidth() : Number {
		if (initialized == false) {
			trace("The StageUtil has to be initialized before any of it's other functions can be called");
		}
		return Stage.width;
	}
	
	static function getHeight() : Number {
		if (initialized == false) {
			trace("The StageUtil has to be initialized before any of it's other functions can be called");
		}
		return Stage.height;
	}
	
	public static function getMouseX() : Number {
		if (initialized == false) {
			trace("The StageUtil has to be initialized before any of it's other functions can be called");
		}
		return _root._xmouse;
	}
	
	public static function getMouseY() : Number {
		if (initialized == false) {
			trace("The StageUtil has to be initialized before any of it's other functions can be called");
		}
		return _root._ymouse;
	}
}