import core.CustomEvent;

/**
 * ...
 * @author notSafeForDev
 */
class core.FrameEvents{
	
	public static var enterFrameEvent : CustomEvent;
	public static var processFrameEvent : CustomEvent;
	
	public static function init(_object : MovieClip) : Void {
		enterFrameEvent = new CustomEvent();
		processFrameEvent = new CustomEvent();
		
		var originalFunction = _object.onEnterFrame;
		
		// We need local copies in order to call them in the function below, without getting compiler warnings
		var enterFrameEventCopy : CustomEvent = enterFrameEvent;
		var processFrameEventCopy : CustomEvent = processFrameEvent;
		
		_object.onEnterFrame = function() {
			if (originalFunction != undefined) {
				originalFunction();
			}
			
			enterFrameEventCopy.emit();
			processFrameEventCopy.emit();
		}
	}
}