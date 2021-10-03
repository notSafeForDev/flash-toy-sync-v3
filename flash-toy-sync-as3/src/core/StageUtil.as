package core {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	public class StageUtil {
		
		private static var stage : Stage;
		
		public static function initialize(_stage : Stage) : void {
			stage = _stage;
		}
		
		public static function setFrameRate(_frameRate : Number) : void {
			if (stage == null) {
				throw new Error("The StageUtil has to be initialized before any of it's other functions can be called");
			}
			stage.frameRate = _frameRate;
		}
		
		public static function makeWindowed() : void {
			if (stage == null) {
				throw new Error("The StageUtil has to be initialized before any of it's other functions can be called");
			}
			stage.displayState = "normal";
		}
		
		public static function makeFullscreen() : void {
			if (stage == null) {
				throw new Error("The StageUtil has to be initialized before any of it's other functions can be called");
			}
			stage.displayState = "fullScreenInteractive";
		}
		
		public static function isWindowed() : Boolean {
			if (stage == null) {
				throw new Error("The StageUtil has to be initialized before any of it's other functions can be called");
			}
			return stage.displayState == "normal";
		}
		
		public static function isFullscreen() : Boolean {
			if (stage == null) {
				throw new Error("The StageUtil has to be initialized before any of it's other functions can be called");
			}
			return stage.displayState != "normal";
		}
		
		public static function getWidth() : Number {
			if (stage == null) {
				throw new Error("The StageUtil has to be initialized before any of it's other functions can be called");
			}
			return stage.stageWidth;
		}
		
		public static function getHeight() : Number {
			if (stage == null) {
				throw new Error("The StageUtil has to be initialized before any of it's other functions can be called");
			}
			return stage.stageHeight;
		}
		
		public static function getMouseX() : Number {
			if (stage == null) {
				throw new Error("The StageUtil has to be initialized before any of it's other functions can be called");
			}
			return stage.mouseX;
		}
		
		public static function getMouseY() : Number {
			if (stage == null) {
				throw new Error("The StageUtil has to be initialized before any of it's other functions can be called");
			}
			return stage.mouseY;
		}
	}
}