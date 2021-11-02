/**
 * ...
 * @author notSafeForDev
 */
class core.TPStage {
	
	private static var _stage : MovieClip;
	private static var _frameRate : Number;
		
	public static function init(_object : MovieClip, _frameRate : Number) : Void {
		_stage = _root;
		_frameRate = _frameRate;
	}
	
	public static function get stageWidth() : Number {
		return Stage.width;
	}
	
	public static function get stageHeight() : Number {
		return Stage.height
	}
	
	public static function get mouseX() : Number {
		return _stage._xmouse;
	}
	
	public static function get mouseY() : Number {
		return _stage._ymouse;
	}
	
	public static function get frameRate() : Number {
		return _frameRate;
	}
	
	public static function set frameRate(_value : Number) : Void {
		trace("Error: Unable to set frameRate, it's not supported in AS2");
	}
	
	static function get stage() {
		return _stage;
	}
}