package global {
	
	import core.CustomEvent;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class GlobalEvents {
		
		public static var enterFrame : CustomEvent;
		public static var animationManualResize : CustomEvent;
		public static var forceStopSelectedChild : CustomEvent;
		public static var resumePlayingSelectedChild : CustomEvent;
		public static var stepFrameBackwards : CustomEvent;
		public static var stepFrameForwards : CustomEvent;
		
		public static function init() : void {
			enterFrame = new CustomEvent();
			animationManualResize = new CustomEvent();
			forceStopSelectedChild = new CustomEvent();
			resumePlayingSelectedChild = new CustomEvent();
			stepFrameBackwards = new CustomEvent();
			stepFrameForwards = new CustomEvent();
		}
	}
}