package core {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	public class StageUtil {
		
		public static function makeWindowed(_child : MovieClip) {
			_child.stage.displayState = "normal";
		}
		
		public static function makeFullscreen(_child : MovieClip) {
			_child.stage.displayState = "fullScreenInteractive";
		}
		
		public static function isWindowed(_child : MovieClip) : Boolean {
			return _child.stage.displayState == "normal";
		}
		
		public static function isFullscreen(_child : MovieClip) : Boolean {
			return _child.stage.displayState != "normal";
		}
		
		public static function getWidth(_child : MovieClip) : Number {
			return _child.stage.stageWidth;
		}
		
		public static function getHeight(_child : MovieClip) : Number {
			return _child.stage.stageHeight;
		}
	}
}