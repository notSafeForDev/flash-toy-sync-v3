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
		
		public var onDragStimulationMarker : CustomEvent;
		public var onDragBaseMarker : CustomEvent;
		public var onDragTipMarker : CustomEvent;
		
		public var onMouseSelectFilterChange : CustomEvent;
		public var onStartRecording : CustomEvent;
		
		private var stimulationMarkerButton : UIButton;
		private var baseMarkerButton : UIButton;
		private var tipMarkerButton : UIButton;
		private var recordButton : UIButton;
		
		private var filterInputText : TextElement;
		private var lastClickedChildText : TextElement;
		
		public function ScriptingPanel(_parent : MovieClip) {
			super(_parent, "Scripting", 200, -1);
			
			onAttachStimulationMarker = new CustomEvent();
			onAttachBaseMarker = new CustomEvent();
			onAttachTipMarker = new CustomEvent();
			
			onDragStimulationMarker = new CustomEvent();
			onDragBaseMarker = new CustomEvent();
			onDragTipMarker = new CustomEvent();
			
			onMouseSelectFilterChange = new CustomEvent();
			
			onStartRecording = new CustomEvent();
			
			stimulationMarkerButton = addButton("Stimulation Marker");
			baseMarkerButton = addButton("Base Marker");
			tipMarkerButton = addButton("Tip Marker");
			recordButton = addButton("Record Script");
			
			var filterHeaderText : TextElement = new TextElement(content, "Filters:");
			TextStyles.applyListItemStyle(filterHeaderText);
			filterHeaderText.setX(10);
			filterHeaderText.setWidth(180);
			
			filterInputText = new TextElement(content, "---"); // Uses a non empty string, as in AS2 it doesn't work otherwise
			TextStyles.applyInputStyle(filterInputText);
			filterInputText.setX(10);
			filterInputText.setWidth(180);
			filterInputText.element.type = "input";
			filterInputText.element.selectable = true;
			filterInputText.setAutoSize(TextElement.AUTO_SIZE_NONE);
			filterInputText.onChange.listen(this, onFilterInputTextChange);
			
			var filterDescriptionText : TextElement = new TextElement(content, "Names of elements you don't want to select");
			TextStyles.applyListItemStyle(filterDescriptionText);
			filterDescriptionText.setX(10);
			filterDescriptionText.setWidth(180);
			filterDescriptionText.setHeight(40);
			filterDescriptionText.element.wordWrap = true;
			
			lastClickedChildText = new TextElement(content, "Clicked: -");
			TextStyles.applyListItemStyle(lastClickedChildText);
			lastClickedChildText.setX(10);
			lastClickedChildText.setWidth(180);
			
			addElementToLayout(stimulationMarkerButton.element, false);
			addElementToLayout(baseMarkerButton.element, false);
			addElementToLayout(tipMarkerButton.element, false);
			addElementToLayout(filterHeaderText.element, false);
			addElementToLayout(filterInputText.element, false);
			addElementToLayout(filterDescriptionText.element, false);
			addElementToLayout(lastClickedChildText.element, false);
			addElementToLayout(recordButton.element, false);
			
			stimulationMarkerButton.onMouseClick.listen(this, onMarkerButtonClick, onAttachStimulationMarker);
			baseMarkerButton.onMouseClick.listen(this, onMarkerButtonClick, onAttachBaseMarker);
			tipMarkerButton.onMouseClick.listen(this, onMarkerButtonClick, onAttachTipMarker);
			
			stimulationMarkerButton.onStartDrag.listen(this, onMarkerButtonDrag, onDragStimulationMarker);
			baseMarkerButton.onStartDrag.listen(this, onMarkerButtonDrag, onDragBaseMarker);
			tipMarkerButton.onStartDrag.listen(this, onMarkerButtonDrag, onDragTipMarker);
			
			recordButton.onMouseClick.listen(this, onStartRecordingButtonClick);
			
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
			var canAttachMarkers : Boolean = GlobalState.selectedChild.state != null;
			
			stimulationMarkerButton.setEnabled(canAttachMarkers);
			baseMarkerButton.setEnabled(canAttachMarkers);
			tipMarkerButton.setEnabled(canAttachMarkers);
			
			recordButton.setEnabled(canRecord());
		}
		
		private function onMarkerButtonClick(_attachMarkerEvent : CustomEvent) : void {
			if (GlobalState.selectedChild.state != null) {
				_attachMarkerEvent.emit();
			}
		}
		
		private function onMarkerButtonDrag(_dragMarkerEvent : CustomEvent) : void {
			_dragMarkerEvent.emit();
		}
		
		private function onStartRecordingButtonClick() : void {
			onStartRecording.emit();
		}
		
		private function addButton(_text : String) : UIButton {
			var element : MovieClip = MovieClipUtil.create(content, _text.split(" ").join("") + "Button");
			element.buttonMode = true;
			element.mouseEnabled = true;
			
			var buttonWidth : Number = 180;
			
			GraphicsUtil.beginFill(element, 0xFFFFFF);
			GraphicsUtil.drawRect(element, 0, 0, buttonWidth, 30);
			
			var text : TextElement = new TextElement(element, _text);
			text.setWidth(buttonWidth);
			text.setAutoSize(TextElement.AUTO_SIZE_CENTER);
			text.setMouseEnabled(false);
			text.setY(6);
			TextStyles.applyButtonStyle(text);
			
			DisplayObjectUtil.setX(element, 10);
			
			var button : UIButton = new UIButton(element);
			button.disabledAlpha = 0.5;
			
			return button;
		}
		
		private function canRecord() : Boolean {
			var dependencies : Array = [
				GlobalState.currentScene.state,
				GlobalState.selectedChild.state,
				GlobalState.stimulationMarkerAttachedTo.state,
				GlobalState.baseMarkerAttachedTo.state,
				GlobalState.tipMarkerAttachedTo.state
			];
			
			return ArrayUtil.indexOf(dependencies, null) < 0;
		}
	}
}