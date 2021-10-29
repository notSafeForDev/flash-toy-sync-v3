package controllers {
	
	import states.AnimationPlaybackStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationPlaybackController {
		
		private var states : AnimationPlaybackStates;
		
		public function AnimationPlaybackController(_states : AnimationPlaybackStates) {
			states = _states;
		}
		
		public function update() : void {
			
		}
	}
}