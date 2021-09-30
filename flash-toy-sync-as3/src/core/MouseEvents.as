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
		public static function addOnMouseDown(_scope : * , _target : MovieClip, _handler : Function) : void {
			add(_scope, _target, MouseEvent.MOUSE_DOWN, _handler);
		}
		
		private static function add(_scope : *, _target : MovieClip, _type : String, _handler : Function) : void {
			_target.addEventListener(_type, function(e : MouseEvent) : void {
				var nestedChildren : Array = MovieClipUtil.getNestedChildren(_target);
				var clickedChildren : Array = [];
				
				for (var i : Number = 0; i < nestedChildren.length; i++) {
					var child : MovieClip = nestedChildren[i];
					var hitting : Boolean = child.hitTestPoint(e.stageX, e.stageY, true);
					if (hitting == true) {
						clickedChildren.push(child);
					}
				}
				
				_handler(clickedChildren);
			});
		}
	}
}