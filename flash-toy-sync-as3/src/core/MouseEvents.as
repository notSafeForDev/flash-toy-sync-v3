package core 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MouseEvents {
		
		public function MouseEvents() {
			
		}
		
		/**
		 * Calls a callback when the user clicks on an element
		 * @param	_scope		The owner of the handler, required for AS2 compatibility
		 * @param	_target		The movieClip to capture mouse events on
		 * @param	_handler	The callback, expects: (clickedChildren : []), each child of the target that is under the cursor gets passed to this function
		 */
		public static function addOnMouseDown(_scope : *, _target : MovieClip, _handler : Function, _arg : * = undefined) : void {
			add(_scope, _target, MouseEvent.MOUSE_DOWN, _handler, _arg);
		}
		
		private static function add(_scope : * , _target : MovieClip, _type : String, _handler : Function, _arg : * = undefined) : void {
			_target.addEventListener(_type, function(e : MouseEvent) : void {
				if (_arg != undefined) {
					_handler(_arg);
				} else {
					_handler();
				}
			});
		}
	}
}