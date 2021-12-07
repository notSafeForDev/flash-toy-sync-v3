package core {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**	 
	 * 
	 * @author notSafeForDev
	 */
	public class FrameEvents {
		
		/** 
		 * Emitted every frame. 
		 */
		public static var enterFrameEvent : CustomEvent;
		
		/** 
		 * Emitted every frame. 
		 * In AS3 it's always emitted after frame code have been executed. 
		 * In AS2 it depends on which element it's attached to, passing the root will ensure it gets emitted after any nested element's frame code gets executed
		 * So no frame dependent code should be attached to the root.
		 */
		public static var processFrameEvent : CustomEvent;
		
		/**
		 * Initializes the Frame Event Manager
		 * @param	_object			The object to attach the frame event listeners to
		 */
		public static function init(_object : DisplayObject) : void {
			if (enterFrameEvent != null || processFrameEvent != null) {
				throw new Error("Unable to initialize Frame Event Manager, it have already been initialized");
			}
			
			enterFrameEvent = new CustomEvent();
			processFrameEvent = new CustomEvent();
			
			_object.addEventListener(Event.ENTER_FRAME, function(e : Event) : void {
				enterFrameEvent.emit();
			});
			
			_object.addEventListener(Event.EXIT_FRAME, function(e : Event) : void {
				processFrameEvent.emit();
			});
		}
	}
}