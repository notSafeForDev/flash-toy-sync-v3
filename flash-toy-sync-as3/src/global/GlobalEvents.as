package global {
	
	import core.CustomEvent;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class GlobalEvents {
		
		public static var enterFrame : CustomEvent;
		public static var animationManualResize : CustomEvent;
		
		public static function init() : void {
			enterFrame = new CustomEvent;
			animationManualResize = new CustomEvent;
		}
	}
}