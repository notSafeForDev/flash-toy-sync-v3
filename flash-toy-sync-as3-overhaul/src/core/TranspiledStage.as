package core {
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TranspiledStage {
		
		private static var stage : Stage;
		
		public static function init(_object : DisplayObject, _frameRate : Number) : void {
			stage = _object.stage;
			stage.frameRate = _frameRate;
		}
		
		public static function get stageWidth() : Number {
			return stage.stageWidth;
		}
		
		public static function get stageHeight() : Number {
			return stage.stageHeight;
		}
		
		public static function get frameRate() : Number {
			return stage.frameRate;
		}
		
		public static function set frameRate(_value : Number) : void {
			stage.frameRate = _value;
		}
	}
}