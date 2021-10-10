package controllers {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.DisplayObjectUtil;
	import core.stateTypes.DisplayObjectState;
	import core.stateTypes.PointState;
	
	import global.GlobalState;
	
	import components.ScriptMarkers;
	import components.ScriptingPanel;
	import components.StageElementSelector;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptingController {
		
		private var globalState : GlobalState;
		
		private var overlayContainer : MovieClip;
		
		private var clickedChildParentChainLength : Number = -1;
		private var stimulationParentChainLength : Number = -1;
		private var baseParentChainLength : Number = -1;
		private var tipParentChainLength : Number = -1;
		
		public function ScriptingController(_globalState : GlobalState, _panelContainer : MovieClip, _animation : MovieClip, _overlayContainer : MovieClip) {
			globalState = _globalState;
			overlayContainer = _overlayContainer;
			
			var stageElementSelector : StageElementSelector = new StageElementSelector(_animation, _overlayContainer);
			stageElementSelector.onSelectChild.listen(this, onStageElementSelectorSelectChild);
			
			var scriptMarkers : ScriptMarkers = new ScriptMarkers(_overlayContainer);
			scriptMarkers.onMovedStimulationMarker.listen(this, onMovedStimulationScriptMarker);
			scriptMarkers.onMovedBaseMarker.listen(this, onMovedBaseScriptMarker);
			scriptMarkers.onMovedTipMarker.listen(this, onMovedTipScriptMarker);
			
			var scriptingPanel : ScriptingPanel = new ScriptingPanel(_panelContainer);
			scriptingPanel.setPosition(700, 300);
			scriptingPanel.onAttachStimulationMarker.listen(this, onScriptingPanelAttachStimulationMarker);
			scriptingPanel.onAttachBaseMarker.listen(this, onScriptingPanelAttachBaseMarker);
			scriptingPanel.onAttachTipMarker.listen(this, onScriptingPanelAttachTipMarker);
			scriptingPanel.onMouseSelectFilterChange.listen(this, onScriptingPanelMouseSelectFilterChange);
		}
		
		public function onEnterFrame() : void {
			var clickedChild : DisplayObject = GlobalState.clickedChild.state;
			var stimulationAttachedTo : DisplayObject = GlobalState.stimulationMarkerAttachedTo.state;
			var baseAttachedTo : DisplayObject = GlobalState.baseMarkerAttachedTo.state;
			var tipAttachedTo : DisplayObject = GlobalState.tipMarkerAttachedTo.state;
			
			if (clickedChild != null && isNoLongerInDisplayList(clickedChild, clickedChildParentChainLength) == true) {
				globalState._clickedChild.setState(null);
			}
			if (stimulationAttachedTo != null && isNoLongerInDisplayList(stimulationAttachedTo, stimulationParentChainLength) == true) {
				globalState._stimulationMarkerAttachedTo.setState(null);
				globalState._stimulationMarkerPoint.setState(null);
			}
			if (baseAttachedTo != null && isNoLongerInDisplayList(baseAttachedTo, baseParentChainLength) == true) {
				globalState._baseMarkerAttachedTo.setState(null);
				globalState._baseMarkerPoint.setState(null);
			}
			if (tipAttachedTo != null && isNoLongerInDisplayList(tipAttachedTo, tipParentChainLength) == true) {
				globalState._tipMarkerAttachedTo.setState(null);
				globalState._tipMarkerPoint.setState(null);
			}
		}
		
		private function isNoLongerInDisplayList(_object : DisplayObject, _originalParentChainLength : Number) : Boolean {
			return DisplayObjectUtil.getParents(_object).length != _originalParentChainLength;
		}
		
		private function onScriptingPanelAttachStimulationMarker() : void {
			attachScriptMarker(globalState._stimulationMarkerAttachedTo, globalState._stimulationMarkerPoint);
			stimulationParentChainLength = DisplayObjectUtil.getParents(GlobalState.stimulationMarkerAttachedTo.state).length;
		}
		
		private function onScriptingPanelAttachBaseMarker() : void {
			attachScriptMarker(globalState._baseMarkerAttachedTo, globalState._baseMarkerPoint);
			baseParentChainLength = DisplayObjectUtil.getParents(GlobalState.baseMarkerAttachedTo.state).length;
		}
		
		private function onScriptingPanelAttachTipMarker() : void {
			attachScriptMarker(globalState._tipMarkerAttachedTo, globalState._tipMarkerPoint);
			tipParentChainLength = DisplayObjectUtil.getParents(GlobalState.tipMarkerAttachedTo.state).length;
		}
		
		private function onScriptingPanelMouseSelectFilterChange(_filter : String) : void {
			globalState._mouseSelectFilter.setState(_filter);
		}
		
		private function attachScriptMarker(_attachedToState : DisplayObjectState, _pointState : PointState) : void {
			var child : DisplayObject = GlobalState.clickedChild.state || GlobalState.selectedChild.state;
			if (child == null) {
				return;
			}
			
			var bounds : Rectangle = DisplayObjectUtil.getBounds(child, overlayContainer);
			var centerX : Number = bounds.x + bounds.width / 2;
			var centerY : Number = bounds.y + bounds.height / 2;
			var point : Point = DisplayObjectUtil.globalToLocal(child, centerX, centerY);
			
			_attachedToState.setState(child);
			_pointState.setState(point);
		}
		
		private function onMovedStimulationScriptMarker(_point : Point) : void {
			globalState._stimulationMarkerPoint.setState(_point);
		}
		
		private function onMovedBaseScriptMarker(_point : Point) : void {
			globalState._baseMarkerPoint.setState(_point);
		}
		
		private function onMovedTipScriptMarker(_point : Point) : void {
			globalState._tipMarkerPoint.setState(_point);
		}
		
		private function onStageElementSelectorSelectChild(_child : DisplayObject) : void {
			globalState._clickedChild.setState(_child);
			clickedChildParentChainLength = DisplayObjectUtil.getParents(_child).length;
		}
	}
}