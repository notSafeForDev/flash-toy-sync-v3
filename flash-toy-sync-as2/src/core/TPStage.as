/**
 * ...
 * @author notSafeForDev
 */
class core.TPStage {
	
	private static var _stage : MovieClip;
	private static var fps : Number;
		
	public static function init(_object : MovieClip, _frameRate : Number) : Void {
		_stage = _root;
		fps = _frameRate;
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
		return fps;
	}
	
	public static function set frameRate(_value : Number) : Void {
		trace("Error: Unable to set frameRate, it's not supported in AS2");
	}
	
	public static function get quality() : String {
		return _stage._quality;
	}
		
	public static function set quality(_value : String) : Void {
		_stage._quality = _value;
	}
	
	public static function get stage() {
		return _stage;
	}
	
	public static function hasFocusedInputTextField() : Boolean {
		return Selection.getFocus() != undefined;
	}
}