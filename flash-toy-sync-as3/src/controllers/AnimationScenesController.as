package controllers {
	
	import core.TPMovieClip;
	import models.SceneModel;
	import models.SceneScriptModel;
	import states.AnimationInfoStates;
	import states.AnimationSceneStates;
	import utils.HierarchyUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationScenesController {
		
		protected var animationSceneStates : AnimationSceneStates;
		
		public function AnimationScenesController(_animationSceneStates : AnimationSceneStates) {
			animationSceneStates = _animationSceneStates;
			
			AnimationInfoStates.isLoaded.listen(this, onAnimationLoadedStateChange);
		}
		
		public function update() : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			
			if (currentScene == null || currentScene.isActive() == false) {
				if (currentScene != null) {
					currentScene.exit();
				}
				
				currentScene = getActiveScene();
				
				if (currentScene != null) {
					currentScene.enter();
					
					var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
					var childAtPath : TPMovieClip = HierarchyUtil.getMovieClipFromPath(root, currentScene.getPath());
					
					animationSceneStates._activeChild.setValue(childAtPath);
					animationSceneStates._currentScene.setValue(currentScene);
					animationSceneStates._currentSceneLoopCount.setValue(0);
				}
			}
			
			if (currentScene == null) {
				animationSceneStates._currentScene.setValue(null);
				animationSceneStates._activeChild.setValue(null);
				return;
			}
			
			var updateStatus : String = currentScene.update();
			
			if (updateStatus == SceneModel.UPDATE_STATUS_LOOP_START) {
				var loopCount : Number = AnimationSceneStates.currentSceneLoopCount.value;
				animationSceneStates._currentSceneLoopCount.setValue(loopCount + 1);
			}
		}
		
		protected function getActiveScene() : SceneModel {
			var scenes : Array = AnimationSceneStates.scenes.value;
			
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : SceneModel = scenes[i];
				var script : SceneScriptModel = scene.getPlugins().getScript();
				if (scene.isActive() == true && script.isComplete() == true) {
					return scene;
				}
			}
			
			return null;
		}
		
		protected function onAnimationLoadedStateChange() : void {
			if (AnimationInfoStates.isLoaded.value == true) {
				return;
			}
			
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			if (currentScene != null) {
				currentScene.exit();
			}
		}
	}
}