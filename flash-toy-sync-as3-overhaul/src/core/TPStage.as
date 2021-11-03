package core {
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPStage {
		
		private static var _stage : Stage;
		
		private static var focusedInputTextField : TextField;
		
		public static function init(_object : DisplayObject, _frameRate : Number) : void {
			_stage = _object.stage;
			_stage.frameRate = _frameRate;
			
			_stage.addEventListener(MouseEvent.CLICK, onStageClick);
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
		
		public static function hasFocusedInputTextField() : Boolean {
			return focusedInputTextField != null;
		}
		
		private static function onStageClick(e : MouseEvent) : void {
			if (e.target is TextField) {
				var textField : TextField = e.target as TextField;
				if (textField.type == "input") {
					focusedInputTextField = textField;
					return;
				}
			}
			
			focusedInputTextField = null;
		}
	}
}