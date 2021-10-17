package ui {
	import ui.TextStyles;
	import core.CustomEvent;
	import core.TextElement;
	import flash.display.MovieClip;
	import global.GlobalState;
	
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
			
			addInputText("connectionKey...", this, onConnectionKeyInputChange);
			prepareScriptButton = addButton("Prepare Script");
			prepareScriptButton.disable();
			prepareScriptButton.onMouseClick.listen(this, onPrepareScriptButtonClick);
			
			statusText = addText("Status: ...", 35);
			
			GlobalState.listen(this, onToyStatesChange, [GlobalState.toyStatus, GlobalState.toyError]);
			GlobalState.listen(this, onCurrentSceneScriptStateChange, [GlobalState.currentSceneScript]);
		}
		
		private function onToyStatesChange() : void {
			if (GlobalState.toyError.state != "") {
				statusText.setText("Error: " + GlobalState.toyError.state);
			} else if (GlobalState.toyStatus.state != "") {
				statusText.setText("Status: " + GlobalState.toyStatus.state);
			} else {
				statusText.setText("Status: ...");
			}
		}
		
		private function onCurrentSceneScriptStateChange() : void {
			if (GlobalState.currentSceneScript.state == null) {
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