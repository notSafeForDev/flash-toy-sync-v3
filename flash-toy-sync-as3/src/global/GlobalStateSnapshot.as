package global {
	
	import flash.display.MovieClip;
	import global.GlobalState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class GlobalStateSnapshot {
		
		public var animationWidth : Number;
		public var animationHeight : Number;
		public var selectedChild : MovieClip;
		public var selectedChildCurrentFrame : Number;
		public var isForceStopped : Boolean;
		
		public function GlobalStateSnapshot() {
			animationWidth = GlobalState.animationWidth.getState();
			animationHeight = GlobalState.animationHeight.getState();
			selectedChild = GlobalState.selectedChild.getState();
			selectedChildCurrentFrame = GlobalState.selectedChildCurrentFrame.getState();
			isForceStopped = GlobalState.isForceStopped.getState();
		}
	}
}