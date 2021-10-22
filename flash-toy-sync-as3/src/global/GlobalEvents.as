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
		public static var scenesMerged : CustomEvent;
		public static var sceneChanged : CustomEvent;
		public static var sceneLooped : CustomEvent;
		public static var sceneDeleted : CustomEvent;
		public static var finishedRecordingScript : CustomEvent;
		
		public static function init() : void {
			enterFrame = new CustomEvent();
			animationManualResize = new CustomEvent();
			childSelected = new CustomEvent();
			stopAtSceneStart = new CustomEvent();
			playFromSceneStart = new CustomEvent();
			scenesMerged = new CustomEvent();
			sceneChanged = new CustomEvent();
			sceneLooped = new CustomEvent();
			sceneDeleted = new CustomEvent();
			finishedRecordingScript = new CustomEvent();
		}
	}
}