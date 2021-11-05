package controllers {
	
	import components.KeyboardInput;
	import core.TPMovieClip;
	import flash.geom.Point;
	import models.SceneModel;
	import models.SceneScriptModel;
	import states.AnimationPlaybackStates;
	import states.ScriptRecordingStates;
	import states.ScriptTrackerStates;
	import ui.Shortcuts;
	import utils.ArrayUtil;
	import utils.SceneScriptUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptRecordingController {
		
		private var scriptRecordingStates : ScriptRecordingStates;
		
		public function ScriptRecordingController(_scriptRecordingStates : ScriptRecordingStates) {
			scriptRecordingStates = _scriptRecordingStates;
			
			KeyboardInput.addShortcut(Shortcuts.recordFrame, this, onRecordFrameShortcut, []);
			
			ScriptTrackerStates.listen(this, onTrackerAttachedToStatesChange, [ScriptTrackerStates.baseTrackerAttachedTo, ScriptTrackerStates.stimTrackerAttachedTo, ScriptTrackerStates.tipTrackerAttachedTo]);
		}
		
		private function onTrackerAttachedToStatesChange() : void {
			var canRecordDependencies : Array = [ScriptTrackerStates.baseGlobalTrackerPoint.value, ScriptTrackerStates.stimGlobalTrackerPoint.value, ScriptTrackerStates.tipGlobalTrackerPoint.value];
			
			scriptRecordingStates._canRecord.setValue(ArrayUtil.includes(canRecordDependencies, null) == false);
		}
		
		private function onRecordFrameShortcut() : void {
			if (ScriptRecordingStates.canRecord.value == false) {
				return;
			}
			
			var currentScene : SceneModel = AnimationPlaybackStates.currentScene.value;
			var activeChild : TPMovieClip = AnimationPlaybackStates.activeChild.value;
			
			var base : Point = ScriptTrackerStates.baseGlobalTrackerPoint.value;
			var stim : Point = ScriptTrackerStates.stimGlobalTrackerPoint.value;
			var tip : Point = ScriptTrackerStates.tipGlobalTrackerPoint.value;
			
			var script : SceneScriptModel = currentScene.getPlugins().getScript();
			script.addPositions(activeChild.currentFrame, base, stim, tip);
		}
	}
}