package controllers {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.ui.Keyboard;
	import states.ScriptStates;
	import ui.Colors;
	import ui.ScriptTrackerMarker;
	import ui.Shortcuts;
	import utils.StageChildSelectionUtil;
	import visualComponents.DepthPreview;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptTrackersController {
		
		private var scriptStates : ScriptStates;
		
		private var baseSubController : ScriptTrackerSubController;
		private var stimSubController : ScriptTrackerSubController;
		private var tipSubController : ScriptTrackerSubController;
		
		private var subControllers : Vector.<ScriptTrackerSubController>;
		
		private var depthPreview : DepthPreview;
		
		public function ScriptTrackersController(_scriptStates : ScriptStates, _container : TPMovieClip) {
			scriptStates = _scriptStates;
			
			var baseMarker : ScriptTrackerMarker = new ScriptTrackerMarker(_container, Colors.baseMarker, "BASE");
			var stimMarker : ScriptTrackerMarker = new ScriptTrackerMarker(_container, Colors.stimMarker, "STIM");
			var tipMarker : ScriptTrackerMarker = new ScriptTrackerMarker(_container, Colors.tipMarker, "TIP");
			
			baseSubController = new ScriptTrackerSubController(baseMarker, _scriptStates._baseTrackerAttachedTo, _scriptStates._baseTrackerPoint, Shortcuts.grabBaseMarker);
			stimSubController = new ScriptTrackerSubController(stimMarker, _scriptStates._stimTrackerAttachedTo, _scriptStates._stimTrackerPoint, Shortcuts.grabStimMarker);
			tipSubController = new ScriptTrackerSubController(tipMarker, _scriptStates._tipTrackerAttachedTo, _scriptStates._tipTrackerPoint, Shortcuts.grabTipMarker);
			
			subControllers = new Vector.<ScriptTrackerSubController>();
			subControllers.push(baseSubController, stimSubController, tipSubController);
			
			for (var i : Number = 0; i < subControllers.length; i++) {
				subControllers[i].initalAttachEvent.listen(this, onInitialAttach);
			}
			
			depthPreview = new DepthPreview(_container, baseMarker, stimMarker, tipMarker);
		}
		
		public function update() : void {
			var subControllerForDraggedMarker : ScriptTrackerSubController;
			
			for (var i : Number = 0; i < subControllers.length; i++) {
				subControllers[i].update();
				if (subControllers[i].isDraggingMarker() == true) {
					subControllerForDraggedMarker = subControllers[i];
				}
			}
			
			scriptStates._isDraggingTrackerMarker.setValue(subControllerForDraggedMarker != null);
			
			if (subControllerForDraggedMarker != null) {
				var attachedTo : TPDisplayObject = subControllerForDraggedMarker.getAttachedToStateValue();
				
				if (attachedTo != null) {
					scriptStates._childUnderDraggedMarker.setValue(attachedTo);
				} else {
					var childAtCursor : TPDisplayObject = StageChildSelectionUtil.getClickableChildAtCursor();
					scriptStates._childUnderDraggedMarker.setValue(childAtCursor);
				}
			}
		}
		
		private function onInitialAttach(_child : TPDisplayObject) : void {
			scriptStates._lastDraggedTrackerAttachedTo.setValue(_child);
		}
	}
}