package ui {
	import global.SceneScriptsState;
	import global.ToyState;
	import ui.TextStyles;
	import core.CustomEvent;
	import core.TextElement;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ToyPanel extends Panel {
		
		public var onConnectionKeyChange : CustomEvent;
		public var onPrepareScript : CustomEvent;
		
		private var statusText : TextElement;
		private var prepareScriptButton : UIButton;
		
		public function ToyPanel(_parent : MovieClip) {
			super(_parent, "Toy", 150, -1);
			
			onConnectionKeyChange = new CustomEvent();
			onPrepareScript = new CustomEvent();
			
			var theHandyConnectionKey : String = ToyState.theHandyConnectionKey.value;
			var inputStartText : String = theHandyConnectionKey == "" ? "connectionKey..." : theHandyConnectionKey;
			
			addInputText(inputStartText, this, onConnectionKeyInputChange);
			prepareScriptButton = addButton("Prepare Script");
			prepareScriptButton.disable();
			prepareScriptButton.onMouseClick.listen(this, onPrepareScriptButtonClick);
			
			statusText = addText("Status: ...", 35);
			
			ToyState.listen(this, onToyStatesChange, [ToyState.status, ToyState.error]);
			SceneScriptsState.listen(this, onCurrentSceneScriptStateChange, [SceneScriptsState.currentScript]);
		}
		
		private function onToyStatesChange() : void {
			if (ToyState.error.value != "") {
				statusText.setText("Error: " + ToyState.error.value);
			} else if (ToyState.status.value != "") {
				statusText.setText("Status: " + ToyState.status.value);
			} else {
				statusText.setText("Status: ...");
			}
		}
		
		private function onCurrentSceneScriptStateChange() : void {
			if (SceneScriptsState.currentScript.value == null) {
				prepareScriptButton.disable();
			} else {
				prepareScriptButton.enable();
			}
		}
		
		private function onConnectionKeyInputChange(_key : String) : void {
			onConnectionKeyChange.emit(_key);
		}
		
		private function onPrepareScriptButtonClick() : void {
			onPrepareScript.emit();
		}
	}
}