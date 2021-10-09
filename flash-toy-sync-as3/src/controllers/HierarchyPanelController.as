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
		
		public function HierarchyPanelController(_globalState : GlobalState, _panelContainer : MovieClip, _animation : MovieClip) {
			globalState = _globalState;
			
			var hierarchyPanel : HierarchyPanel = new HierarchyPanel(_panelContainer, _animation);
			hierarchyPanel.excludeChildrenWithoutNestedAnimations = true;
			hierarchyPanel.onSelectChild.listen(this, onPanelSelectChild);
			hierarchyPanel.onToggleMouseSelect.listen(this, onPanelToggleMouseSelect);
			
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
			
			var currentFrame : Number = MovieClipUtil.getCurrentFrame(_child);
			
			globalState._selectedChild.setState(_child);
			globalState._currentFrame.setState(currentFrame);
			globalState._isPlaying.setState(false);
			globalState._isForceStopped.setState(false);
			globalState._skippedFromFrame.setState(-1);
			globalState._skippedToFrame.setState(-1);
			globalState._stoppedAtFrame.setState(-1);
			
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