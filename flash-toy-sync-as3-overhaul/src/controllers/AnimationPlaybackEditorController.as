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
		
		/** Used for determining if we can merge two scenes */
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
			var scenes : Array;
			
			if (activeChild == null && currentScene != null) {
				currentScene.exit();
				currentScene = null;
			}
			
			if (activeChild == null) {
				return;
			}
			
			var sceneForActiveChild : SceneModel = getActiveSceneForChild(activeChild);
			
			// If no scene is available, Create a new scene
			if (currentScene == null && sceneForActiveChild == null) {
				currentScene = enterNewScene();
			}
			
			// If we reach a new scene and the current scene haven't been set, enter it
			if (currentScene == null && sceneForActiveChild != null) {
				animationPlaybackStates._currentScene.setValue(sceneForActiveChild);
				currentScene = sceneForActiveChild;
				currentScene.enter();
			}
			
			// If we have reached a new scene that is different to the current one, either merge with it, or switch to it
			if (currentScene != null && sceneForActiveChild != null && currentScene != sceneForActiveChild) {
				var didSkipFrames : Boolean = activeChild.currentFrame != previousFrameForActiveChild + 1;
				var shouldMerge : Boolean = sceneForActiveChild.isTemporary == true && didSkipFrames == false;
				
				if (shouldMerge == true) {
					scenes = AnimationPlaybackStates.scenes.value;
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
			var shouldSplit : Boolean = false;
			
			if (updateStatus == SceneModel.UPDATE_STATUS_EXIT) {
				currentScene = enterNewScene();
			}
			
			if (updateStatus == SceneModel.UPDATE_STATUS_LOOP_MIDDLE) {
				shouldSplit = true;
			}
			
			if (updateStatus == SceneModel.UPDATE_STATUS_COMPLETELY_STOPPED) {
				if (currentScene.getTotalInnerFrames() > 1) {
					shouldSplit = true;
				}
			}
			
			if (shouldSplit == true) {
				var firstHalf : SceneModel = currentScene.split();
				scenes = AnimationPlaybackStates.scenes.value;
				scenes.push(firstHalf);
				sortScenes(scenes);
				animationPlaybackStates._scenes.setValue(scenes);
			}
			
			scenesPanel.update();
			
			previousFrameForActiveChild = activeChild.currentFrame;
		}
		
		private function onHierarchySelectedChildStateChange() : void {
			var activeChild : TPMovieClip = HierarchyStates.selectedChild.value;
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			var scenes : Array = AnimationPlaybackStates.scenes.value;
			var canDiscardCurrentScene : Boolean = currentScene != null && currentScene.isTemporary == true && currentScene.getTotalInnerFrames() == 1;
			
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