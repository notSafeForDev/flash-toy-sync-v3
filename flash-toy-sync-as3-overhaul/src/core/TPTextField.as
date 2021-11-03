package core {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPTextField {
		
		public static function create(_parent : TPMovieClip) : TextField {
			var textField : TextField = new TextField();
			_parent.sourceMovieClip.addChild(textField);
			return textField;
		}
		
		public static function addOnChangeListener(_textField : TextField, _scope : * , _handler : Function) : void {
			_textField.addEventListener(Event.CHANGE, function(e : Event) : void {
				_handler.apply(_scope, [_textField.text]);
			});
		}
		
		public static function hasFocusedTextElement() : Boolean {
			return false;
		}
	}
}