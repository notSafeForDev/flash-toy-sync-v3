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
		public static var stepFrames : CustomEvent;
		public static var gotoFrame : CustomEvent;
		
		public static function init() : void {
			enterFrame = new CustomEvent();
			animationManualResize = new CustomEvent();
			forceStopSelectedChild = new CustomEvent();
			resumePlayingSelectedChild = new CustomEvent();
			stepFrames = new CustomEvent();
			gotoFrame = new CustomEvent();
		}
	}
}