package ui {
	import core.CustomEvent;
	import core.MouseEvents;
	import core.TextElement;
	import core.Timeout;
	import flash.display.MovieClip;
	import flash.system.System;
	import global.GlobalState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SaveDataPanel extends Panel {
		
		public var onSave : CustomEvent;
		
		private var dataText : TextElement;
		private var statusText : TextElement;
		
		public function SaveDataPanel(_parent : MovieClip) {
			super(_parent, "Save Data", 150, -1);
			
			onSave = new CustomEvent();
			
			dataText = addInputText("no data", this, null);
			addButton("Save").onMouseClick.listen(this, onSaveButtonClick);
			statusText = addText("", 20);
			
			MouseEvents.addOnMouseDown(this, dataText.element, onDataTextMouseDown);
		}
		
		public function setSaveData(_data : String) : void {
			dataText.setText(_data);
		}
		
		private function onDataTextMouseDown() : void {
			// Neither of this happens in the AS2 version
			// This is a hack for the issue where text can't be selected in any of the input texts,
			// which is only an issue in the AS3 version
			dataText.element.setSelection(0, dataText.getText().length);
			System.setClipboard(dataText.getText());
		}
		
		private function onSaveButtonClick() : void {
			statusText.setText("Saving");
			
			onSave.emit();
			
			Timeout.set(this, onStatusTextAddDot, 400);
			Timeout.set(this, onStatusTextAddDot, 800);
			Timeout.set(this, onStatusTextAddDot, 1200);
			Timeout.set(this, onStatusTextClear, 1600);
		}
		
		private function onStatusTextAddDot() : void {
			statusText.setText(statusText.getText() + ".");
		}
		
		private function onStatusTextClear() : void {
			statusText.setText("");
		}
	}
}