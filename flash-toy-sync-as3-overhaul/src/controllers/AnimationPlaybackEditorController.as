package controllers {
	import core.TPMovieClip;
	import models.SceneModel;
	import states.AnimationInfoStates;
	import states.AnimationPlaybackStates;
	import states.HierarchyStates;
	import ui.ScenesPanel;
	import utils.ArrayUtil;
	import utils.HierarchyUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class AnimationPlaybackEditorController extends AnimationPlaybackController {
		
		private var scenesPanel : ScenesPanel;
		
		private var previousFrameForActiveChild : Number = -1;
		
		public function AnimationPlaybackEditorController(_animationPlaybackStates : AnimationPlaybackStates, _scenesPanel : ScenesPanel) {
			super(_animationPlaybackStates);
			
			scenesPanel = _scenesPanel;
			
			scenesPanel.sceneSelectedEvent.listen(this, onScenesPanelSceneSelected);
			
			HierarchyStates.selectedChild.listen(this, onHierarchySelectedChildStateChange);
		}
		
		public override function update() : void {
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			var activeChild : TPMovieClip = AnimationPlaybackStates.activeChild.value;
			
			if (activeChild == null && currentScene != null) {
				currentScene.exit();
			}
			
			if (activeChild == null) {
				return;
			}
			
			var sceneForActiveChild : SceneModel = getActiveSceneForChild(activeChild);
			
			// Create a new scene
			if (currentScene == null && sceneForActiveChild == null) {
				currentScene = enterNewScene();
			}
			
			// Enter an existing scene when we're not at a scene
			if (currentScene == null && sceneForActiveChild != null) {
				animationPlaybackStates._currentScene.setValue(sceneForActiveChild);
				currentScene = sceneForActiveChild;
				currentScene.enter();
			}
			
			// Either switch or merge scenes
			if (currentScene != null && sceneForActiveChild != null && currentScene != sceneForActiveChild) {
				var scenes : Array = AnimationPlaybackStates.scenes.value;
				var shouldMerge : Boolean = sceneForActiveChild.isTemporary == true && activeChild.currentFrame == previousFrameForActiveChild + 1;
				
				if (shouldMerge == true) {
					currentScene.merge(sceneForActiveChild);
					ArrayUtil.remove(scenes, sceneForActiveChild);
					animationPlaybackStates._scenes.setValue(scenes);
				} else {
					animationPlaybackStates._currentScene.setValue(sceneForActiveChild);
					currentScene.exit();
					currentScene = sceneForActiveChild;
					currentScene.enter();
				}
			}
			
			if (currentScene == null) {
				return;
			}
			
			var updateStatus : String = currentScene.update();
			
			if (updateStatus == SceneModel.UPDATE_STATUS_EXIT) {
				currentScene = enterNewScene();
			}
			
			scenesPanel.update();
			
			previousFrameForActiveChild = activeChild.currentFrame;
		}
		
		private function onHierarchySelectedChildStateChange() : void {
			var activeChild : TPMovieClip = HierarchyStates.selectedChild.value;
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			var scenes : Array = AnimationPlaybackStates.scenes.value;
			var canDiscardCurrentScene : Boolean = currentScene != null && currentScene.getTotalInnerFrames() == 1;
			
			animationPlaybackStates._activeChild.setValue(activeChild);
			previousFrameForActiveChild = -1;

			if (canDiscardCurrentScene == true) {
				ArrayUtil.remove(scenes, currentScene);
				animationPlaybackStates._scenes.setValue(scenes);
			}
			
			if (activeChild == null && currentScene != null) {
				currentScene.exit();
			}
			
			if (activeChild == null) {
				return;
			}
			
			var sceneForActiveChild : SceneModel = getActiveSceneForChild(activeChild);
			
			if (currentScene != null && currentScene != sceneForActiveChild) {
				animationPlaybackStates._currentScene.setValue(null);
				currentScene.exit();
			}
			
			if (sceneForActiveChild == null) {
				var scene : SceneModel = enterNewScene();
				scene.isTemporary = true;
			}
		}
		
		private function onScenesPanelSceneSelected(_scene : SceneModel) : void {
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			if (currentScene != null) {
				currentScene.exit();
			}
			
			animationPlaybackStates._currentScene.setValue(_scene);
			previousFrameForActiveChild = -1;
			
			_scene.gotoAndPlay(_scene.getStartFrames());
			_scene.enter();
		}
		
		private function enterNewScene() : SceneModel {
			var activeChild : TPMovieClip = AnimationPlaybackStates.activeChild.value;
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var path : Vector.<String> = HierarchyUtil.getChildPath(root, activeChild);
			var scenes : Array = AnimationPlaybackStates.scenes.value;
			var scene : SceneModel = new SceneModel(path);
			
			scene.enter();
			
			scenes.push(scene);
			sortScenes(scenes);
			
			animationPlaybackStates._scenes.setValue(scenes);
			animationPlaybackStates._currentScene.setValue(scene);
			
			return scene;
		}
		
		private function sortScenes(_scenes : Array) : void {
			_scenes.sort(function(_a : SceneModel, _b : SceneModel) : Number {
				var aStartFrames : Vector.<Number> = _a.getStartFrames();
				var bStartFrames : Vector.<Number> = _b.getStartFrames();
				
				var maxLength : Number = Math.max(aStartFrames.length, bStartFrames.length);
				
				for (var i : Number = 0; i < maxLength; i++) {
					var aFrame : Number = aStartFrames.length > i ? aStartFrames[i] : -1;
					var bFrame : Number = bStartFrames.length > i ? bStartFrames[i] : -1;
					if (aFrame > bFrame) {
						return 1;
					}
					if (bFrame > aFrame) {
						return -1;
					}
				}
				
				return 0;
			});
		}
		
		private function getActiveSceneForChild(_child : TPMovieClip) : SceneModel {
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var path : Vector.<String> = HierarchyUtil.getChildPath(root, _child);
			var pathString : String = path.join(",");
			var scenes : Array = AnimationPlaybackStates.scenes.value;
			
			for (var i : Number = 0; i < scenes.length; i++) {
				var scene : SceneModel = scenes[i];
				if (scene.getPath().join(",") == pathString && scene.isActive() == true) {
					return scene;
				}
			}
			
			return null;
		}
	}
}