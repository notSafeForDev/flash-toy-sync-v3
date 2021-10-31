package controllers {
	
	import models.SceneModel;
	import states.AnimationPlaybackStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationPlaybackController {
		
		protected var animationPlaybackStates : AnimationPlaybackStates;
		
		public function AnimationPlaybackController(_animationPlaybackStates : AnimationPlaybackStates) {
			animationPlaybackStates = _animationPlaybackStates;
		}
		
		public function update() : void {
			
		}
		
		public function getActiveScene() : SceneModel {
			var scenes : Array = AnimationPlaybackStates.scenes.value;
			
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : SceneModel = scenes[i];
				if (scene.isActive() == true) {
					return scene;
				}
			}
			
			return null;
		}
	}
}