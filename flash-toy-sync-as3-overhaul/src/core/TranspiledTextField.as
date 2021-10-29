package core {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TranspiledTextField {
		
		public static function create(_parent : MovieClip) : TextField {
			var textField : TextField = new TextField();
			_parent.addChild(textField);
			return textField;
		}
		
		public static function addOnChangeListener(_textElement : TextField, _scope : * , _handler : Function) : void {
			_textElement.addEventListener(Event.CHANGE, function(e : Event) : void {
				_handler.apply(_scope);
			});
		}
	}
}