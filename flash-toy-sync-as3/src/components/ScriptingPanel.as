package components {
	
	import flash.display.MovieClip;
	
	import core.DisplayObjectUtil;
	import core.MouseEvents;
	import core.CustomEvent;
	import core.Fonts;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.TextElement;
	
	import global.GlobalState;
	
	import config.TextStyles;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptingPanel extends Panel {
		
		public var onAttachStimulationMarker : CustomEvent;
		public var onAttachBaseMarker : CustomEvent;
		public var onAttachTipMarker : CustomEvent;
		
		private var attachStimulationMarkerButton : MovieClip;
		private var attachBaseMarkerButton : MovieClip;
		private var attachTipMarkerButton : MovieClip;
		
		public function ScriptingPanel(_parent : MovieClip) {
			super(_parent, "Scripting", 200, 150);
			
			onAttachStimulationMarker = new CustomEvent();
			onAttachBaseMarker = new CustomEvent();
			onAttachTipMarker = new CustomEvent();
			
			attachStimulationMarkerButton = addButton("Attach stim marker", 10);
			attachBaseMarkerButton = addButton("Attach base marker", 50);
			attachTipMarkerButton = addButton("Attach tip marker", 90);
			
			MouseEvents.addOnMouseDown(this, attachStimulationMarkerButton, onAttachStimulationMarkerButtonClick);
			MouseEvents.addOnMouseDown(this, attachBaseMarkerButton, onAttachBaseMarkerButtonClick);
			MouseEvents.addOnMouseDown(this, attachTipMarkerButton, onAttachTipMarkerButtonClick);
			
			GlobalState.listen(this, onStatesChange, [GlobalState.clickedChild, GlobalState.selectedChild]);
			
			updateAttachButtons();
		}
		
		private function onStatesChange() : void {
			updateAttachButtons();
		}
		
		private function updateAttachButtons() : void {
			var canAttachMarkers : Boolean = GlobalState.clickedChild.state != null || GlobalState.selectedChild.state != null;
			
			var alpha : Number = canAttachMarkers ? 1 : 0.5;
			
			attachStimulationMarkerButton.mouseEnabled = canAttachMarkers;
			attachBaseMarkerButton.mouseEnabled = canAttachMarkers;
			attachTipMarkerButton.mouseEnabled = canAttachMarkers;
			
			DisplayObjectUtil.setAlpha(attachStimulationMarkerButton, alpha);
			DisplayObjectUtil.setAlpha(attachBaseMarkerButton, alpha);
			DisplayObjectUtil.setAlpha(attachTipMarkerButton, alpha);
		}
		
		private function onAttachStimulationMarkerButtonClick() : void {
			onAttachStimulationMarker.emit();
		}
		
		private function onAttachBaseMarkerButtonClick() : void {
			onAttachBaseMarker.emit();
		}
		
		private function onAttachTipMarkerButtonClick() : void {
			onAttachTipMarker.emit();
		}
		
		private function addButton(_text : String, _y : Number) : MovieClip {
			var button : MovieClip = MovieClipUtil.create(content, _text.split(" ").join(""));
			button.buttonMode = true;
			button.mouseEnabled = true;
			
			var buttonWidth : Number = 180;
			
			GraphicsUtil.beginFill(button, 0xFFFFFF);
			GraphicsUtil.drawRect(button, 0, 0, buttonWidth, 30);
			
			var text : TextElement = new TextElement(button, _text);
			text.setWidth(buttonWidth);
			text.setAutoSize(TextElement.AUTO_SIZE_CENTER);
			text.setMouseEnabled(false);
			text.setY(6);
			TextStyles.applyButtonStyle(text);
			
			DisplayObjectUtil.setX(button, 10);
			DisplayObjectUtil.setY(button, _y);
			
			return button;
		}
	}
}