package global {
	
	import core.CustomEvent;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class GlobalEvents {
		
		public static var enterFrame : CustomEvent;
		public static var animationManualResize : CustomEvent;
		public static var childSelected : CustomEvent;
		public static var stopAtSceneStart : CustomEvent;
		public static var playFromSceneStart : CustomEvent;
		
		public static function init() : void {
			enterFrame = new CustomEvent();
			animationManualResize = new CustomEvent();
			childSelected = new CustomEvent();
			stopAtSceneStart = new CustomEvent();
			playFromSceneStart = new CustomEvent();
		}
	}
}