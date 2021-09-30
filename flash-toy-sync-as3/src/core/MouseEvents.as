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
		
		public static function add(_scope : * , _target : MovieClip, _type : String, _handler : Function) : void {
			_target.addEventListener(_type, function(e : MouseEvent) {
				var nestedChildren : Array = MovieClipUtil.getNestedChildren(_target);
				var clickedChildren : Array = [];
				
				for (var i = 0; i < nestedChildren.length; i++) {
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