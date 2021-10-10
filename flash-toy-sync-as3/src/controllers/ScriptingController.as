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
			
			if (clickedChild != null && DisplayObjectUtil.getParent(clickedChild) == null) {
				globalState._clickedChild.setState(null);
			}
		}
		
		private function onScriptingPanelAttachStimulationMarker() : void {
			attachScriptMarker(globalState._stimulationMarkerAttachedTo, globalState._stimulationMarkerPoint);
		}
		
		private function onScriptingPanelAttachBaseMarker() : void {
			attachScriptMarker(globalState._baseMarkerAttachedTo, globalState._baseMarkerPoint);
		}
		
		private function onScriptingPanelAttachTipMarker() : void {
			attachScriptMarker(globalState._tipMarkerAttachedTo, globalState._tipMarkerPoint);
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
		}
	}
}