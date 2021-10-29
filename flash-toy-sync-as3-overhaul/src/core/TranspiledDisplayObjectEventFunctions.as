package core {
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TranspiledDisplayObjectEventFunctions {
		
		public static function addEnterFrameEventListener(_object : DisplayObject, _scope : *, _handler : Function, _rest : Array) : void {
			addEventListener(_object, Event.ENTER_FRAME, _scope, _handler, _rest);
		}
		
		private static function addEventListener(_object : DisplayObject, _event : String, _scope : * , _handler : Function, _rest : Array) : void {
			var handler : Function = function() : void {
				_handler.apply(_scope, _rest);
			}
			
			_object.addEventListener(_event, handler);
		}
	}
}