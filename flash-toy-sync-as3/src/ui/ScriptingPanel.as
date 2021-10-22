package ui {
	
	import flash.display.MovieClip;
	
	import global.EditorState;
	import global.ScenesState;
	import global.ScriptingState;
	
	import core.ArrayUtil;
	import core.DisplayObjectUtil;
	import core.MouseEvents;
	import core.CustomEvent;
	import core.Fonts;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.TextElement;
	
	import ui.TextStyles;
	
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
		public var startFrameInputText : TextElement;
		public var endFrameInputText : TextElement;
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
			
			addDivider();
			
			addText("Filters:", 20);
			filterInputText = addInputText("---", this, onFilterInputTextChange); // Uses a non empty string, as in AS2 it doesn't work otherwise
			addText("Names of elements you don't want to select", 35);
			lastClickedChildText = addText("Clicked: -", 20);
			
			addDivider();
			
			var startFrameContainer : MovieClip = MovieClipUtil.create(content, "startFrameContainer");
			var startFrameTitle : TextElement = createText(startFrameContainer, "Start Frame:", 20);
			startFrameTitle.setX(layoutPadding);
			startFrameInputText = createInputText(startFrameContainer, "-1", this, null);
			startFrameInputText.setX(contentWidth - 80);
			startFrameInputText.setWidth(80 - layoutPadding);
			addElementToLayout(startFrameContainer, false);
			
			var endFrameContainer : MovieClip = MovieClipUtil.create(content, "startFrameContainer");
			var endFrameTitle : TextElement = createText(endFrameContainer, "End Frame:", 20);
			endFrameTitle.setX(layoutPadding);
			endFrameInputText = createInputText(endFrameContainer, "-1", this, null);
			endFrameInputText.setX(contentWidth - 80);
			endFrameInputText.setWidth(80 - layoutPadding);
			addElementToLayout(endFrameContainer, false);
			
			recordButton = addButton("Record Script");
			
			stimulationMarkerButton.onMouseClick.listen(this, onMarkerButtonClick, onAttachStimulationMarker);
			baseMarkerButton.onMouseClick.listen(this, onMarkerButtonClick, onAttachBaseMarker);
			tipMarkerButton.onMouseClick.listen(this, onMarkerButtonClick, onAttachTipMarker);
			
			stimulationMarkerButton.onStartDrag.listen(this, onMarkerButtonDrag, onDragStimulationMarker);
			baseMarkerButton.onStartDrag.listen(this, onMarkerButtonDrag, onDragBaseMarker);
			tipMarkerButton.onStartDrag.listen(this, onMarkerButtonDrag, onDragTipMarker);
			
			recordButton.onMouseClick.listen(this, onStartRecordingButtonClick);
			
			ScriptingState.listen(this, onMarkerAttachStatesChange, [ScriptingState.baseMarkerAttachedTo, ScriptingState.stimulationMarkerAttachedTo, ScriptingState.tipMarkerAttachedTo]);
			EditorState.listen(this, onClickedChildStateChange, [EditorState.clickedChild]);
			ScenesState.listen(this, onCurrentSceneStateChange, [ScenesState.currentScene]);
		}
		
		private function onFilterInputTextChange(_text : String) : void {
			onMouseSelectFilterChange.emit(_text);
		}
		
		private function onMarkerAttachStatesChange() : void {
			updateButtons();
		}
		
		private function onClickedChildStateChange() : void {
			if (EditorState.clickedChild.value != null) {
				lastClickedChildText.setText("Clicked: " + DisplayObjectUtil.getName(EditorState.clickedChild.value));
			}
		}
		
		private function onCurrentSceneStateChange() : void {
			startFrameInputText.setText("-1");
			endFrameInputText.setText("-1");
			
			updateButtons();
		}
		
		private function updateButtons() : void {
			var canAttachMarkers : Boolean = ScenesState.selectedChild.value != null;
			
			stimulationMarkerButton.setEnabled(canAttachMarkers);
			baseMarkerButton.setEnabled(canAttachMarkers);
			tipMarkerButton.setEnabled(canAttachMarkers);
			
			recordButton.setEnabled(canRecord());
		}
		
		private function onMarkerButtonClick(_attachMarkerEvent : CustomEvent) : void {
			if (ScenesState.selectedChild.value != null) {
				_attachMarkerEvent.emit();
			}
		}
		
		private function onMarkerButtonDrag(_dragMarkerEvent : CustomEvent) : void {
			_dragMarkerEvent.emit();
		}
		
		private function onStartRecordingButtonClick() : void {
			onStartRecording.emit();
		}
		
		private function canRecord() : Boolean {
			var dependencies : Array = [
				ScenesState.currentScene.value,
				ScenesState.selectedChild.value,
				ScriptingState.stimulationMarkerAttachedTo.value,
				ScriptingState.baseMarkerAttachedTo.value,
				ScriptingState.tipMarkerAttachedTo.value
			];
			
			return ArrayUtil.indexOf(dependencies, null) < 0;
		}
	}
}