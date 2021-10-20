package controllers {
	
	import core.DisplayObjectUtil;
	import core.KeyboardManager;
	import core.MouseEvents;
	import core.MovieClipUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import global.EditorState;
	import global.ScenesState;
	import ui.ScriptingPanel;
	import utils.StageChildSelectionUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StageChildSelectionController {
		
		private var editorState : EditorState;
		
		private var keyboardManager : KeyboardManager;
		
		private var animation : MovieClip;
		
		public function StageChildSelectionController(_editorState : EditorState, _scriptingPanel : ScriptingPanel, _animation : MovieClip, _overlayContainer : MovieClip) {
			editorState = _editorState;
			
			animation = _animation;
			
			keyboardManager = new KeyboardManager(animation);
			
			_scriptingPanel.onMouseSelectFilterChange.listen(this, onScriptingPanelMouseSelectFilterChange);
			
			MouseEvents.addOnMouseDownPassThrough(this, animation, onOverlayMouseDown);
		}
		
		public function onEnterFrame() : void {
			if (keyboardManager.isKeyPressed(Keyboard.E) == true) {
				var childAtCursor : DisplayObject = StageChildSelectionUtil.getClickableChildAtCursor(animation);
				editorState._hoveredChild.setValue(childAtCursor);
			} else {
				editorState._hoveredChild.setValue(null);
			}
			
			if (DisplayObjectUtil.isNested(animation, EditorState.clickedChild.value) == false) {
				editorState._clickedChild.setValue(null);
			}
		}
		
		private function onOverlayMouseDown() : void {	
			if (keyboardManager.isKeyPressed(Keyboard.E) == false) {
				return;
			}
			
			var childAtCursor : DisplayObject = StageChildSelectionUtil.getClickableChildAtCursor(animation);
			editorState._clickedChild.setValue(childAtCursor);
		}
		
		private function onScriptingPanelMouseSelectFilterChange(_filter : String) : void {
			editorState._mouseSelectFilter.setValue(_filter);
		}
	}
}