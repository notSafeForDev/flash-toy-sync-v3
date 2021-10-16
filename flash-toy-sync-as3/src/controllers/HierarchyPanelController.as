package controllers {
	
	import core.DisplayObjectUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import core.MovieClipUtil;
	import core.ArrayUtil;
	import core.stateTypes.ArrayState;
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	import components.HierarchyPanel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanelController {
		
		private var globalState : GlobalState;
		
		public function HierarchyPanelController(_globalState : GlobalState, _hierarchyPanel : HierarchyPanel, _animation : MovieClip) {
			globalState = _globalState;
			
			_hierarchyPanel.excludeChildrenWithoutNestedAnimations = true;
			_hierarchyPanel.onSelectChild.listen(this, onPanelSelectChild);
			_hierarchyPanel.onToggleMouseSelect.listen(this, onPanelToggleMouseSelect);
			
			GlobalEvents.enterFrame.listen(this, onEnterFrame);
		}
		
		private function onEnterFrame() : void {
			var state : ArrayState = globalState._disabledMouseSelectForChildren;
			var stateValue : Array = state.getState();
			var haveRemovedAny : Boolean = false;
			
			for (var i : Number = 0; i < stateValue.length; i++) {
				if (DisplayObjectUtil.getParent(stateValue[i]) == null) {
					stateValue.splice(i, 1);
					haveRemovedAny = true;
					i--;
				}
			}
			
			if (haveRemovedAny == true) {
				state.setState(stateValue);
			}
		}
		
		private function onPanelSelectChild(_child : MovieClip) : void {
			if (GlobalState.selectedChild.state == _child) {
				return;
			}
			
			GlobalEvents.childSelected.emit(_child);
		}
		
		private function onPanelToggleMouseSelect(_child : DisplayObject) : void {
			var state : ArrayState = globalState._disabledMouseSelectForChildren;
			var stateValue : Array = state.getState();
			var index : Number = ArrayUtil.indexOf(state.getState(), _child);
			
			if (index >= 0) {
				stateValue.splice(index, 1);
			} else {
				stateValue.push(_child);
			}
			
			state.setState(stateValue);
		}
	}
}