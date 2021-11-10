package controllers {
	import components.KeyboardInput;
	import states.AnimationInfoStates;
	import states.EditorStates;
	import ui.Shortcuts;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class KeyboardShortcutsController {
		
		public function KeyboardShortcutsController() {
			AnimationInfoStates.listen(this, onAnimationLoadedStateChange, [AnimationInfoStates.isLoaded]);
		}
		
		private function onAnimationLoadedStateChange() : void {
			if (AnimationInfoStates.isLoaded.value == false) {
				KeyboardInput.disableShortcuts(Shortcuts.EDITOR_ONLY);
			} else if (EditorStates.isEditor.value == true) {
				KeyboardInput.enableShortcuts(Shortcuts.EDITOR_ONLY);
			}
		}
	}
}