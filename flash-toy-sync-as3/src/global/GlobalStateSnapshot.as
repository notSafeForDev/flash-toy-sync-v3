package global {
	
	import global.GlobalState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class GlobalStateSnapshot {
		
		public var animationWidth : Number;
		public var animationHeight : Number;
		
		public function GlobalStateSnapshot() {
			animationWidth = GlobalState.animationWidth.getState();
			animationHeight = GlobalState.animationHeight.getState();
		}
	}
}