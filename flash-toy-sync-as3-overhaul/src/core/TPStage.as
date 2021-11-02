package core {
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPStage {
		
		private static var _stage : Stage;
		
		public static function init(_object : DisplayObject, _frameRate : Number) : void {
			_stage = _object.stage;
			_stage.frameRate = _frameRate;
		}
		
		public static function get stageWidth() : Number {
			return _stage.stageWidth;
		}
		
		public static function get stageHeight() : Number {
			return _stage.stageHeight;
		}
		
		public static function get mouseX() : Number {
			return _stage.mouseX;
		}
		
		public static function get mouseY() : Number {
			return _stage.mouseY;
		}
		
		public static function get frameRate() : Number {
			return _stage.frameRate;
		}
		
		public static function set frameRate(_value : Number) : void {
			_stage.frameRate = _value;
		}
		
		public static function get stage() : Stage {
			return _stage;
		}
	}
}