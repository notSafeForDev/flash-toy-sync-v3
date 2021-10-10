package components {
	
	import config.TextStyles;
	import core.Fonts;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import global.GlobalState;
	
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
			
			selectedChildText = addText();
			clickedChildText = addText();
			stimulationMarkerAttachedToText = addText();
			baseMarkerAttachedToText = addText();
			baseMarkerPointText = addText();
			tipMarkerAttachedToText = addText();
			currentFrameText = addText();
			isForceStoppedText = addText();
			isPlayingText = addText();
			skippedFromFrameText = addText();
			skippedToFrameText = addText();
			stoppedAtFrameText = addText();
			
			GlobalState.listen(this, onAnyStateUpdate, []);
		}
		
		private function onAnyStateUpdate() : void {
			selectedChildText.setText(getDisplayObjectText("Selected", GlobalState.selectedChild.state));
			clickedChildText.setText(getDisplayObjectText("Clicked", GlobalState.clickedChild.state));
			stimulationMarkerAttachedToText.setText(getDisplayObjectText("Stim Attach", GlobalState.stimulationMarkerAttachedTo.state));
			baseMarkerAttachedToText.setText(getDisplayObjectText("Base Attach", GlobalState.baseMarkerAttachedTo.state));
			baseMarkerPointText.setText(getPointText("Base Point", GlobalState.baseMarkerPoint.state));
			tipMarkerAttachedToText.setText(getDisplayObjectText("Tip Attach", GlobalState.tipMarkerAttachedTo.state));
			currentFrameText.setText("Frame: " + GlobalState.currentFrame.state);
			isForceStoppedText.setText("Force stopped: " + GlobalState.isForceStopped.state);
			isPlayingText.setText("Playing: " + GlobalState.isPlaying.state);
			skippedFromFrameText.setText("Skipped from: " + GlobalState.skippedFromFrame.state);
			skippedToFrameText.setText("Skipped to: " + GlobalState.skippedToFrame.state);
			stoppedAtFrameText.setText("Stopped at: " + GlobalState.stoppedAtFrame.state);
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
		
		private function addText() : TextElement {
			var textElement : TextElement = new TextElement(content);
			textElement.element.textColor = 0xFFFFFF;
			textElement.setY(totalAddedTexts * 20);
			textElement.setWidth(200);
			TextStyles.applyListItemStyle(textElement);
			totalAddedTexts++;
			
			return textElement;
		}
	}
}