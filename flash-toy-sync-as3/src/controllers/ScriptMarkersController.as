package controllers {
	
	import components.ScriptMarker;
	import ui.ScriptMarkerElement;
	import components.StageElementSelector;
	import core.CustomEvent;
	import core.DisplayObjectUtil;
	import core.MovieClipUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import global.GlobalState;
	
	import ui.ScriptingPanel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptMarkersController {
		
		private var globalState : GlobalState;
		
		private var animation : MovieClip;
		
		private var stageElementSelector : StageElementSelector;
		
		private var scriptMarkers : Array = null;
		
		private var stimulationMarker : ScriptMarker;
		private var baseMarker : ScriptMarker;
		private var tipMarker : ScriptMarker;
		
		private var draggingMarker : ScriptMarker;
		
		public function ScriptMarkersController(_globalState : GlobalState, _scriptingPanel : ScriptingPanel, _animation : MovieClip, _overlayContainer : MovieClip) {
			globalState = _globalState;
			animation = _animation;
			
			stageElementSelector = new StageElementSelector(_animation, _overlayContainer);
			stageElementSelector.onSelectChild.listen(this, onStageElementSelectorSelectChild);
			
			var markersContainer : MovieClip = MovieClipUtil.create(_overlayContainer, "scriptMarkersContainer");
			
			var stimulationMarkerElement : ScriptMarkerElement = new ScriptMarkerElement(markersContainer, 0xD99EC6, "STIM");
			var baseMarkerElement : ScriptMarkerElement = new ScriptMarkerElement(markersContainer, 0xA1D99E, "BASE");
			var tipMarkerElement : ScriptMarkerElement = new ScriptMarkerElement(markersContainer, 0x9ED0D9, "TIP");
			
			stimulationMarker = new ScriptMarker(_animation, stimulationMarkerElement, globalState._stimulationMarkerAttachedTo, globalState._stimulationMarkerPoint);
			baseMarker = new ScriptMarker(_animation, baseMarkerElement, globalState._baseMarkerAttachedTo, globalState._baseMarkerPoint);
			tipMarker = new ScriptMarker(_animation, tipMarkerElement, globalState._tipMarkerAttachedTo, globalState._tipMarkerPoint);
			
			stimulationMarker.onStartDrag.listen(this, onStartDragMarker, stimulationMarker);
			baseMarker.onStartDrag.listen(this, onStartDragMarker, baseMarker);
			tipMarker.onStartDrag.listen(this, onStartDragMarker, tipMarker);
			
			stimulationMarker.onStopDrag.listen(this, onStopDragMarker, stimulationMarker);
			baseMarker.onStopDrag.listen(this, onStopDragMarker, baseMarker);
			tipMarker.onStopDrag.listen(this, onStopDragMarker, tipMarker);
			
			scriptMarkers = [stimulationMarker, baseMarker, tipMarker];
			
			_scriptingPanel.onAttachStimulationMarker.listen(this, onScriptingPanelAttachMarker, stimulationMarker);
			_scriptingPanel.onAttachBaseMarker.listen(this, onScriptingPanelAttachMarker, baseMarker);
			_scriptingPanel.onAttachTipMarker.listen(this, onScriptingPanelAttachMarker, tipMarker);
			
			_scriptingPanel.onDragStimulationMarker.listen(this, onScriptingPanelDragMarker, stimulationMarker);
			_scriptingPanel.onDragBaseMarker.listen(this, onScriptingPanelDragMarker, baseMarker);
			_scriptingPanel.onDragTipMarker.listen(this, onScriptingPanelDragMarker, tipMarker);
			
			_scriptingPanel.onMouseSelectFilterChange.listen(this, onScriptingPanelMouseSelectFilterChange);
			
			GlobalState.listen(this, onCurrentSceneStateChange, [GlobalState.currentScene]);
		}
		
		public function onEnterFrame() : void {
			if (DisplayObjectUtil.isNested(animation, GlobalState.clickedChild.state) == false) {
				globalState._clickedChild.setState(null);
			}
			
			if (draggingMarker != null) {
				var attachedTo : DisplayObject = draggingMarker.attachedToState.getState();
				if (attachedTo == null) {
					stageElementSelector.highlightElementAtCursor();
				} else {
					stageElementSelector.highlightElement(attachedTo);
				}
			}
			
			for (var i : Number = 0; i < scriptMarkers.length; i++) {
				var scriptMarker : ScriptMarker = scriptMarkers[i];
				scriptMarker.update();
			}
		}
		
		private function onScriptingPanelMouseSelectFilterChange(_filter : String) : void {
			globalState._mouseSelectFilter.setState(_filter);
		}
		
		private function onStageElementSelectorSelectChild(_child : DisplayObject) : void {
			globalState._clickedChild.setState(_child);
		}
		
		private function onCurrentSceneStateChange() : void {
			for (var i : Number = 0; i < scriptMarkers.length; i++) {
				var scriptMarker : ScriptMarker = scriptMarkers[i];
				scriptMarker.detatch();
			}
		}
		
		private function onScriptingPanelAttachMarker(_scriptMarker : ScriptMarker) : void {
			_scriptMarker.attachTo(GlobalState.clickedChild.state || GlobalState.selectedChild.state, false);
		}
		
		private function onScriptingPanelDragMarker(_scriptMarker : ScriptMarker) : void {
			_scriptMarker.detatch();
			_scriptMarker.startDrag();
			draggingMarker = _scriptMarker;
		}
		
		private function onStartDragMarker(_scriptMarker : ScriptMarker) : void {
			draggingMarker = _scriptMarker;
		}
		
		private function onStopDragMarker(_scriptMarker : ScriptMarker) : void {
			if (_scriptMarker.attachedToState.getState() == null) {
				var childAtCursor : DisplayObject = stageElementSelector.getElementAtCursor();
				if (childAtCursor != null) {
					_scriptMarker.attachTo(childAtCursor, true);
				}
			}
			
			draggingMarker = null;
		}
	}
}