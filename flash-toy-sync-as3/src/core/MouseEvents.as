package core 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
		 * Calls a callback when the user clicks: on, through, or anywhere around the target element, without blocking mouse input for children behind the target
		 * Note: Doesn't function identical to the AS2 version of addOnMouseDownPassThrough
		 * @param	_scope		The owner of the handler, required for AS2 compatibility
		 * @param	_target		The element the user clicks through
		 * @param	_handler	The callback
		 */
		public static function addOnMouseDownPassThrough(_scope : * , _target : MovieClip, _handler : Function, _arg : * = undefined) : void {
			_target.stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e : MouseEvent) : void {
				if (e.target is DisplayObjectContainer == false) {
					return;
				}
				
				var parents : Array = DisplayObjectUtil.getParents(DisplayObject(e.target));
				if (parents.indexOf(_target) < 0 && (e.target is MovieClip == false || MovieClip(e.target) != _target)) {
					return;
				}
				
				if (_arg != undefined) {
					_handler(_arg);
				} else {
					_handler();
				}
			});
		}
		
		/**
		 * Calls a callback when the user moves their mouse over an element, this blocks mouse input for any children behind or nested to the target
		 * @param	_scope		The owner of the handler, required for AS2 compatibility
		 * @param	_target		The movieClip to capture mouse events on
		 * @param	_handler	The callback
		 */
		public static function addOnMouseOver(_scope : * , _target : MovieClip, _handler : Function, _arg : * = undefined) : void {
			add(_scope, _target, MouseEvent.MOUSE_OVER, _handler, _arg);
		}
		
		/**
		 * Calls a callback when the user clicks on an element, this blocks mouse input for any children behind or nested to the target
		 * @param	_scope		The owner of the handler, required for AS2 compatibility
		 * @param	_target		The movieClip to capture mouse events on
		 * @param	_handler	The callback
		 */
		public static function addOnMouseDown(_scope : * , _target : MovieClip, _handler : Function, _arg : * = undefined) : void {
			add(_scope, _target, MouseEvent.MOUSE_DOWN, _handler, _arg);
		}
		
		/**
		 * Calls a callback when the user moves their mouse off of an element, this blocks mouse input for any children behind or nested to the target
		 * @param	_scope		The owner of the handler, required for AS2 compatibility
		 * @param	_target		The movieClip to capture mouse events on
		 * @param	_handler	The callback
		 */
		public static function addOnMouseOut(_scope : * , _target : MovieClip, _handler : Function, _arg : * = undefined) : void {
			add(_scope, _target, MouseEvent.MOUSE_OUT, _handler, _arg);
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