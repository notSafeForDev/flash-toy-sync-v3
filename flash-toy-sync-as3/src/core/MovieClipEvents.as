package core 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MovieClipEvents {
		
		private static var listeners : Array = [];
		
		public function MovieClipEvents() {
			
		}
		
		public static function addOnEnterFrame(_scope : * , _movieClip : MovieClip, _handler : Function) : void {
			var eventCallback : Function = function (e : Event) : void {
				_handler();
			}
			
			_movieClip.addEventListener(Event.ENTER_FRAME, eventCallback);
			
			listeners.push({event: Event.ENTER_FRAME, eventCallback: eventCallback, object: _movieClip, handler: _handler, scope: _scope});
		}
		
		public static function remove(_scope : * , _movieClip : MovieClip, _handler : Function) : void {
			for (var i : int = 0; i < listeners.length; i++) {
				if (listeners[i].scope == _scope && listeners[i].object == _movieClip && listeners[i].handler == _handler) {
					trace("Found listener to remove");
					_movieClip.removeEventListener(listeners[i].event, listeners[i].eventCallback);
					listeners.splice(i, 1);
					break;
				}
			}
		}
	}
}