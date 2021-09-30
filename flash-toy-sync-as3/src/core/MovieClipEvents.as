package core 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MovieClipEvents {
		
		public function MovieClipEvents() {
			
		}
		
		public static function addOnEnterFrame(_scope : * , _movieClip : MovieClip, _handler : Function) {
			_movieClip.addEventListener(Event.ENTER_FRAME, function (e : Event) {
				_handler();
			});
		}
		
		public static function addOnExitFrame(_scope : * , _movieClip : MovieClip, _handler : Function) {
			_movieClip.addEventListener(Event.EXIT_FRAME, function (e : Event) {
				_handler();
			});
		}
	}
}