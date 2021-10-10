package components {
	
	import core.ArrayUtil;
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
		public var onMouseSelectFilterChange : CustomEvent;
		
		private var attachStimulationMarkerButton : MovieClip;
		private var attachBaseMarkerButton : MovieClip;
		private var attachTipMarkerButton : MovieClip;
		private var recordButton : MovieClip;
		
		private var filterInputText : TextElement;
		private var lastClickedChildText : TextElement;
		
		public function ScriptingPanel(_parent : MovieClip) {
			super(_parent, "Scripting", 200, 280);
			
			onAttachStimulationMarker = new CustomEvent();
			onAttachBaseMarker = new CustomEvent();
			onAttachTipMarker = new CustomEvent();
			onMouseSelectFilterChange = new CustomEvent();
			
			attachStimulationMarkerButton = addButton("Attach stim marker", 10);
			attachBaseMarkerButton = addButton("Attach base marker", 50);
			attachTipMarkerButton = addButton("Attach tip marker", 90);
			recordButton = addButton("Record script", 240);
			
			var filterHeaderText : TextElement = new TextElement(content, "Filters:");
			TextStyles.applyListItemStyle(filterHeaderText);
			filterHeaderText.setX(10);
			filterHeaderText.setY(130);
			filterHeaderText.setWidth(180);
			
			filterInputText = new TextElement(content, "---"); // Uses a non empty string, as in AS2 it doesn't work otherwise
			TextStyles.applyInputStyle(filterInputText);
			filterInputText.setX(10);
			filterInputText.setY(150);
			filterInputText.setWidth(180);
			filterInputText.element.type = "input";
			filterInputText.element.selectable = true;
			filterInputText.setAutoSize(TextElement.AUTO_SIZE_NONE);
			filterInputText.onChange.listen(this, onFilterInputTextChange);
			
			var filterDescriptionText : TextElement = new TextElement(content, "Names of elements you don't want to select");
			TextStyles.applyListItemStyle(filterDescriptionText);
			filterDescriptionText.setX(10);
			filterDescriptionText.setY(170);
			filterDescriptionText.setWidth(180);
			filterDescriptionText.setHeight(40);
			filterDescriptionText.element.wordWrap = true;
			
			lastClickedChildText = new TextElement(content, "Clicked: -");
			TextStyles.applyListItemStyle(lastClickedChildText);
			lastClickedChildText.setX(10);
			lastClickedChildText.setY(210);
			lastClickedChildText.setWidth(180);
			
			MouseEvents.addOnMouseDown(this, attachStimulationMarkerButton, onAttachStimulationMarkerButtonClick);
			MouseEvents.addOnMouseDown(this, attachBaseMarkerButton, onAttachBaseMarkerButtonClick);
			MouseEvents.addOnMouseDown(this, attachTipMarkerButton, onAttachTipMarkerButtonClick);
			
			GlobalState.listen(this, onStatesChange, [
				GlobalState.clickedChild, GlobalState.selectedChild, GlobalState.baseMarkerAttachedTo, GlobalState.stimulationMarkerAttachedTo, GlobalState.tipMarkerAttachedTo
			]);
			
			updateButtons();
		}
		
		private function onFilterInputTextChange(_text : String) : void {
			onMouseSelectFilterChange.emit(_text);
		}
		
		private function onStatesChange() : void {
			updateButtons();
			if (GlobalState.clickedChild.state != null) {
				lastClickedChildText.setText("Clicked: " + DisplayObjectUtil.getName(GlobalState.clickedChild.state));
			}
		}
		
		private function updateButtons() : void {
			var canAttachMarkers : Boolean = GlobalState.clickedChild.state != null || GlobalState.selectedChild.state != null;
			
			var alpha : Number = canAttachMarkers ? 1 : 0.5;
			
			attachStimulationMarkerButton.mouseEnabled = canAttachMarkers;
			attachBaseMarkerButton.mouseEnabled = canAttachMarkers;
			attachTipMarkerButton.mouseEnabled = canAttachMarkers;
			
			DisplayObjectUtil.setAlpha(attachStimulationMarkerButton, alpha);
			DisplayObjectUtil.setAlpha(attachBaseMarkerButton, alpha);
			DisplayObjectUtil.setAlpha(attachTipMarkerButton, alpha);
			
			alpha = canRecord() ? 1 : 0.5;
			
			recordButton.mouseEnabled = canRecord();
			
			DisplayObjectUtil.setAlpha(recordButton, alpha);
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
		
		private function canRecord() : Boolean {
			return ArrayUtil.indexOf([
				GlobalState.stimulationMarkerAttachedTo.state, 
				GlobalState.baseMarkerAttachedTo.state, 
				GlobalState.tipMarkerAttachedTo.state
			], null) < 0;
		}
	}
}