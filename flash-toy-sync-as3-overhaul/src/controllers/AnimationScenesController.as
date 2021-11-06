package controllers {
	
	import models.SceneModel;
	import states.AnimationSceneStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationScenesController {
		
		protected var animationSceneStates : AnimationSceneStates;
		
		public function AnimationScenesController(_animationSceneStates : AnimationSceneStates) {
			animationSceneStates = _animationSceneStates;
		}
		
		public function update() : void {
			
		}
		
		public function getActiveScene() : SceneModel {
			var scenes : Array = AnimationSceneStates.scenes.value;
			
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