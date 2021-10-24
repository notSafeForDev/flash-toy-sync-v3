package controllers {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import core.DisplayObjectUtil;
	import core.ArrayUtil;
	
	import global.EditorState;
	import global.ScenesState;
	import global.GlobalEvents;
	
	import ui.HierarchyPanel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanelController {
		
		private var editorState : EditorState;
		
		public function HierarchyPanelController(_editorState : EditorState, _hierarchyPanel : HierarchyPanel, _animation : MovieClip) {
			editorState = _editorState;
			
			_hierarchyPanel.excludeChildrenWithoutNestedAnimations = true;
			_hierarchyPanel.onSelectChild.listen(this, onPanelSelectChild);
			_hierarchyPanel.onToggleMouseSelect.listen(this, onPanelToggleMouseSelect);
		}
		
		public function onEnterFrame() : void {
			var stateValue : Array = EditorState.mouseSelectDisabledForChildren.value;
			var haveRemovedAny : Boolean = false;
			
			for (var i : Number = 0; i < stateValue.length; i++) {
				if (DisplayObjectUtil.getParent(stateValue[i]) == null) {
					stateValue.splice(i, 1);
					haveRemovedAny = true;
					i--;
				}
			}
			
			if (haveRemovedAny == true) {
				editorState._mouseSelectDisabledForChildren.setValue(stateValue);
			}
		}
		
		private function onPanelSelectChild(_child : MovieClip) : void {
			if (ScenesState.selectedChild.value == _child) {
				return;
			}
			
			if (DisplayObjectUtil.getParent(_child) == null) {
				throw new Error("Unable to select child from hierarchy, it's no longer in the display list");
			}
			
			GlobalEvents.childSelected.emit(_child);
		}
		
		private function onPanelToggleMouseSelect(_child : DisplayObject) : void {
			var stateValue : Array = EditorState.mouseSelectDisabledForChildren.value;
			var index : Number = ArrayUtil.indexOf(stateValue, _child);
			
			if (index >= 0) {
				stateValue.splice(index, 1);
			} else {
				stateValue.push(_child);
			}
			
			editorState._mouseSelectDisabledForChildren.setValue(stateValue);
		}
	}
}