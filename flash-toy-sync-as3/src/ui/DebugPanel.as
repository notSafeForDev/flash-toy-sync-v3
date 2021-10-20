package ui {
	
	import global.EditorState;
	import global.ScenesState;
	import global.ScriptingState;
	import ui.TextStyles;
	import core.Fonts;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import ui.Panel;
	
	import core.DisplayObjectUtil;
	import core.MovieClipUtil;
	import core.TextElement;
	
	import global.GlobalEvents;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DebugPanel extends Panel {
		
		private var selectedChildText : TextElement;
		private var clickedChildText : TextElement;
		private var stimulationMarkerAttachedToText : TextElement;
		private var baseMarkerAttachedToText : TextElement;
		private var baseMarkerPointText : TextElement;
		private var tipMarkerAttachedToText : TextElement;
		private var currentFrameText : TextElement;
		private var isForceStoppedText : TextElement;
		private var isPlayingText : TextElement;
		private var skippedFromFrameText : TextElement;
		private var skippedToFrameText : TextElement;
		private var stoppedAtFrameText : TextElement;
		
		private var totalAddedTexts : Number = 0;
		
		public function DebugPanel(_parent : MovieClip) {
			super(_parent, "Debug", 200, 240);
			
			selectedChildText = addText("", 20);
			clickedChildText = addText("", 20);
			stimulationMarkerAttachedToText = addText("", 20);
			baseMarkerAttachedToText = addText("", 20);
			baseMarkerPointText = addText("", 20);
			tipMarkerAttachedToText = addText("", 20);
			currentFrameText = addText("", 20);
			isForceStoppedText = addText("", 20);
			isPlayingText = addText("", 20);
			skippedFromFrameText = addText("", 20);
			skippedToFrameText = addText("", 20);
			stoppedAtFrameText = addText("", 20);
			
			// GlobalState.listen(this, onAnyStateUpdate, []);
		}
		
		private function onAnyStateUpdate() : void {
			selectedChildText.setText(getDisplayObjectText("Selected", ScenesState.selectedChild.value));
			clickedChildText.setText(getDisplayObjectText("Clicked", EditorState.clickedChild.value));
			stimulationMarkerAttachedToText.setText(getDisplayObjectText("Stim Attach", ScriptingState.stimulationMarkerAttachedTo.value));
			baseMarkerAttachedToText.setText(getDisplayObjectText("Base Attach", ScriptingState.baseMarkerAttachedTo.value));
			baseMarkerPointText.setText(getPointText("Base Point", ScriptingState.baseMarkerPoint.value));
			tipMarkerAttachedToText.setText(getDisplayObjectText("Tip Attach", ScriptingState.tipMarkerAttachedTo.value));
			// currentFrameText.setText("Frame: " + GlobalState.currentFrame.state);
			isForceStoppedText.setText("Force stopped: " + ScenesState.isForceStopped.value);
			// isPlayingText.setText("Playing: " + GlobalState.isPlaying.state);
			// skippedFromFrameText.setText("Skipped from: " + GlobalState.skippedFromFrame.state);
			// skippedToFrameText.setText("Skipped to: " + GlobalState.skippedToFrame.state);
			// stoppedAtFrameText.setText("Stopped at: " + GlobalState.stoppedAtFrame.state);
		}
		
		private function getDisplayObjectText(_prefix : String, _object : DisplayObject) : String {
			if (_object == null) {
				return _prefix + ": null";
			}
			return _prefix + ": " + DisplayObjectUtil.getName(_object);
		}
		
		private function getPointText(_prefix : String, _point : Point) : String {
			if (_point == null) {
				return _prefix + ": null";
			}
			return _prefix + ": " + "x:" + Math.round(_point.x) + ", y:" + Math.round(_point.y);
		}
	}
}