package controllers {
	
	import components.ScriptMarker;
	import global.EditorState;
	import global.ScenesState;
	import global.ScriptingState;
	import ui.ScriptMarkerElement;
	import core.CustomEvent;
	import core.DisplayObjectUtil;
	import core.MovieClipUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import utils.StageChildSelectionUtil;
	
	import ui.ScriptingPanel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptMarkersController {
		
		private var scriptingState : ScriptingState;
		
		private var animation : MovieClip;
		
		private var scriptMarkers : Array = null;
		
		private var stimulationMarker : ScriptMarker;
		private var baseMarker : ScriptMarker;
		private var tipMarker : ScriptMarker;
		
		private var draggingMarker : ScriptMarker;
		
		public function ScriptMarkersController(_scriptingState : ScriptingState, _scriptingPanel : ScriptingPanel, _animation : MovieClip, _overlayContainer : MovieClip) {
			scriptingState = _scriptingState;
			animation = _animation;
			
			var markersContainer : MovieClip = MovieClipUtil.create(_overlayContainer, "scriptMarkersContainer");
			
			var stimulationMarkerElement : ScriptMarkerElement = new ScriptMarkerElement(markersContainer, 0xD99EC6, "STIM");
			var baseMarkerElement : ScriptMarkerElement = new ScriptMarkerElement(markersContainer, 0xA1D99E, "BASE");
			var tipMarkerElement : ScriptMarkerElement = new ScriptMarkerElement(markersContainer, 0x9ED0D9, "TIP");
			
			stimulationMarker = new ScriptMarker(_animation, stimulationMarkerElement, scriptingState._stimulationMarkerAttachedTo, scriptingState._stimulationMarkerPoint);
			baseMarker = new ScriptMarker(_animation, baseMarkerElement, scriptingState._baseMarkerAttachedTo, scriptingState._baseMarkerPoint);
			tipMarker = new ScriptMarker(_animation, tipMarkerElement, scriptingState._tipMarkerAttachedTo, scriptingState._tipMarkerPoint);
			
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
			
			ScenesState.listen(this, onCurrentSceneStateChange, [ScenesState.currentScene]);
		}
		
		public function onEnterFrame() : void {
			if (ScriptingState.isDraggingMarker.value == true && draggingMarker.attachedToState.getValue() == null) {
				var childAtCursor : DisplayObject = StageChildSelectionUtil.getClickableChildAtCursor(animation);
				scriptingState._childUnderDraggedMarker.setValue(childAtCursor);
			}
			
			for (var i : Number = 0; i < scriptMarkers.length; i++) {
				var scriptMarker : ScriptMarker = scriptMarkers[i];
				scriptMarker.update();
			}
		}
		
		private function onCurrentSceneStateChange() : void {
			for (var i : Number = 0; i < scriptMarkers.length; i++) {
				var scriptMarker : ScriptMarker = scriptMarkers[i];
				scriptMarker.detatch();
			}
		}
		
		private function onScriptingPanelAttachMarker(_scriptMarker : ScriptMarker) : void {
			_scriptMarker.attachTo(EditorState.clickedChild.value || ScenesState.selectedChild.value, false);
		}
		
		private function onScriptingPanelDragMarker(_scriptMarker : ScriptMarker) : void {
			_scriptMarker.detatch();
			_scriptMarker.startDrag();
			draggingMarker = _scriptMarker;
			
			scriptingState._isDraggingMarker.setValue(true);
			scriptingState._childUnderDraggedMarker.setValue(null);
		}
		
		private function onStartDragMarker(_scriptMarker : ScriptMarker) : void {
			draggingMarker = _scriptMarker;
			
			scriptingState._isDraggingMarker.setValue(true);
			scriptingState._childUnderDraggedMarker.setValue(_scriptMarker.attachedToState.getValue());
		}
		
		private function onStopDragMarker(_scriptMarker : ScriptMarker) : void {
			if (ScriptingState.childUnderDraggedMarker.value != null) {
				_scriptMarker.attachTo(ScriptingState.childUnderDraggedMarker.value, true);
			}
			
			scriptingState._isDraggingMarker.setValue(false);
			scriptingState._childUnderDraggedMarker.setValue(null);
			
			draggingMarker = null;
		}
	}
}