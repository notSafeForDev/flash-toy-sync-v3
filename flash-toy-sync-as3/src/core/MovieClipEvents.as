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
		
		public static function addOnEnterFrame(_scope : * , _movieClip : MovieClip, _handler : Function) : void {
			_movieClip.addEventListener(Event.ENTER_FRAME, function (e : Event) : void {
				_handler();
			});
		}
	}
}