package components {
	
	import core.Fonts;
	import flash.display.MovieClip;
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
		private var currentFrameText : TextElement;
		private var isForceStoppedText : TextElement;
		private var isPlayingText : TextElement;
		private var skippedFromFrameText : TextElement;
		private var skippedToFrameText : TextElement;
		private var stoppedAtFrameText : TextElement;
		
		private var totalAddedTexts : Number = 0;
		
		public function DebugPanel(_parent : MovieClip) {
			super(_parent, "Debug", 200, 170);
			
			selectedChildText = addText();
			currentFrameText = addText();
			isForceStoppedText = addText();
			isPlayingText = addText();
			skippedFromFrameText = addText();
			skippedToFrameText = addText();
			stoppedAtFrameText = addText();
			
			GlobalState.listen(this, onAnyStateUpdate, []);
		}
		
		private function onAnyStateUpdate() : void {
			var selectedChild : MovieClip = GlobalState.selectedChild.state;
			
			if (selectedChild == null) {
				selectedChildText.setText("Selected: null");
			} else {
				selectedChildText.setText("Selected: " + DisplayObjectUtil.getName(selectedChild));
			}
			
			currentFrameText.setText("Frame: " + GlobalState.currentFrame.state);
			isForceStoppedText.setText("Force stopped: " + GlobalState.isForceStopped.state);
			isPlayingText.setText("Playing: " + GlobalState.isPlaying.state);
			skippedFromFrameText.setText("Skipped from: " + GlobalState.skippedFromFrame.state);
			skippedToFrameText.setText("Skipped to: " + GlobalState.skippedToFrame.state);
			stoppedAtFrameText.setText("Stopped at: " + GlobalState.stoppedAtFrame.state);
		}
		
		private function addText() : TextElement {
			var textElement : TextElement = new TextElement(content);
			textElement.element.textColor = 0xFFFFFF;
			textElement.setFont(Fonts.COURIER_NEW);
			textElement.setY(totalAddedTexts * 20);
			totalAddedTexts++;
			
			return textElement;
		}
	}
}