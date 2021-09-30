class core.StageUtil {
	
	static function makeWindowed(_child : MovieClip) {
		Stage.displayState = "normal";
	}
	
	static function makeFullscreen(_child : MovieClip) {
		Stage.displayState = "fullscreen";
	}
	
	static function isWindowed(_child : MovieClip) : Boolean {
		return Stage.displayState == "normal";
	}
	
	static function isFullscreen(_child : MovieClip) : Boolean {
		return Stage.displayState != "normal";
	}
	
	static function getWidth(_child : MovieClip) : Number {
		return Stage.width;
	}
	
	static function getHeight(_child : MovieClip) : Number {
		return Stage.height;
	}
}