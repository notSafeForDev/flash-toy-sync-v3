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
		 * @param	_scope		The owner of the handler
		 * @param	_target		The element the user clicks through
		 * @param	_handler	The callback
		 */
		public static function addOnMouseDownPassThrough(_scope : * , _target : MovieClip, _handler : Function, ..._args) : void {
			_target.stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e : MouseEvent) : void {
				if (e.target is DisplayObjectContainer == false) {
					return;
				}
				
				var parents : Array = DisplayObjectUtil.getParents(DisplayObject(e.target));
				if (parents.indexOf(_target) < 0 && (e.target is MovieClip == false || MovieClip(e.target) != _target)) {
					return;
				}
				
				if (_args.length > 0) {
					_handler.apply(_scope, _args);
				} else {
					_handler();
				}
			});
		}
		
		/**
		 * Calls a callback when the user moves their mouse over an element, this blocks mouse input for any children behind or nested to the target
		 * @param	_scope		The owner of the handler
		 * @param	_target		The movieClip to capture mouse events on
		 * @param	_handler	The callback
		 */
		public static function addOnMouseOver(_scope : * , _target : MovieClip, _handler : Function, ..._args) : void {
			add(_scope, _target, MouseEvent.MOUSE_OVER, _handler, _args);
		}
		
		/**
		 * Calls a callback when the user presses down on an element, this blocks mouse input for any children behind or nested to the target
		 * @param	_scope		The owner of the handler
		 * @param	_target		The movieClip to capture mouse events on
		 * @param	_handler	The callback
		 */
		public static function addOnMouseDown(_scope : * , _target : MovieClip, _handler : Function, ..._args) : void {
			add(_scope, _target, MouseEvent.MOUSE_DOWN, _handler, _args);
		}
		
		/**
		 * Calls a callback when the user releases the mouse button on an element, this blocks mouse input for any children behind or nested to the target
		 * @param	_scope		The owner of the handler
		 * @param	_target		The movieClip to capture mouse events on
		 * @param	_handler	The callback
		 */
		public static function addOnMouseUp(_scope : * , _target : MovieClip, _handler : Function, ..._args) : void {
			add(_scope, _target, MouseEvent.MOUSE_UP, _handler, _args);
		}
		
		/**
		 * Calls a callback when the user moves the mouse over an element, this blocks mouse input for any children behind or nested to the target
		 * @param	_scope		The owner of the handler
		 * @param	_target		The movieClip to capture mouse events on
		 * @param	_handler	The callback
		 */
		public static function addOnMouseMove(_scope : * , _target : MovieClip, _handler : Function, ..._args) : void {
			add(_scope, _target, MouseEvent.MOUSE_MOVE, _handler, _args);
		}
		
		/**
		 * Calls a callback when the user moves their mouse off of an element, this blocks mouse input for any children behind or nested to the target
		 * @param	_scope		The owner of the handler
		 * @param	_target		The movieClip to capture mouse events on
		 * @param	_handler	The callback
		 */
		public static function addOnMouseOut(_scope : * , _target : MovieClip, _handler : Function, ..._args) : void {
			add(_scope, _target, MouseEvent.MOUSE_OUT, _handler, _args);
		}
		
		private static function add(_scope : * , _target : MovieClip, _type : String, _handler : Function, _args : Array) : void {
			_target.addEventListener(_type, function(e : MouseEvent) : void {
				if (_args.length > 0) {
					_handler.apply(_scope, _args);
				} else {
					_handler();
				}
			});
		}
	}
}