package visualComponents {
	
	import components.Timeout;
	import core.TPMovieClip;
	import core.TPStage;
	import models.SceneModel;
	import states.AnimationInfoStates;
	import states.AnimationSceneStates;
	import states.SaveDataStates;
	import states.ScriptRecordingStates;
	import ui.TextElement;
	import ui.TextStyles;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StatusText {
		
		private var text : TextElement;
		
		private var currentTimeout : Number;
		
		public function StatusText(_container : TPMovieClip) {
			text = new TextElement(_container, "");
			TextStyles.applyStatusStyle(text);
			
			text.element.y = TPStage.stageHeight - 80;
			text.element.width = TPStage.stageWidth;
			
			Index.enterFrameEvent.listen(this, onEnterFrame);
			
			SaveDataStates.listen(this, onSaveDataListStateChange, [SaveDataStates.saveDataList]);
			AnimationInfoStates.listen(this, onAnimationLoadInfoStateChange, [AnimationInfoStates.loadStatus]);
		}
		
		private function onAnimationLoadInfoStateChange() : void {
			displayText(AnimationInfoStates.loadStatus.value);
		}
		
		private function onSaveDataListStateChange() : void {
			if (SaveDataStates.saveDataList.value.length != 0) {
				displayTemporaryText("Saving...", 2);
			}
		}
		
		private function onEnterFrame() : void {
			if (ScriptRecordingStates.isRecording.value == false) {
				return;
			}
			
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			var totalFrames : Number = currentScene.getTotalInnerFrames();
			var startFrame : Number = currentScene.getInnerStartFrame();
			var currentFrame : Number = AnimationSceneStates.activeChild.value.currentFrame;
			var currentFrameIndex : Number = (currentFrame - startFrame) + 1;
			
			displayTemporaryText("Recording frame: " + currentFrameIndex + "/" + totalFrames, 1);
		}
		
		private function displayText(_text : String) : void {
			Timeout.clear(currentTimeout)
			text.text = _text;
		}
		
		private function displayTemporaryText(_text : String, _duration : Number) : void {
			Timeout.clear(currentTimeout);
			text.text = _text;
			currentTimeout = Timeout.set(this, onDisplayTemporaryTextDone, _duration * 1000);
		}
		
		private function onDisplayTemporaryTextDone() : void {
			text.text = "";
		}
	}
}