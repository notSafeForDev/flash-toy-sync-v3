package controllers {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.ui.Keyboard;
	import states.ScriptTrackerStates;
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
		
		private var scriptTrackerStates : ScriptTrackerStates;
		
		private var baseSubController : ScriptTrackerSubController;
		private var stimSubController : ScriptTrackerSubController;
		private var tipSubController : ScriptTrackerSubController;
		
		private var subControllers : Vector.<ScriptTrackerSubController>;
		
		private var depthPreview : DepthPreview;
		
		public function ScriptTrackersController(_scriptTrackerStates : ScriptTrackerStates, _container : TPMovieClip) {
			scriptTrackerStates = _scriptTrackerStates;
			
			var baseMarker : ScriptTrackerMarker = new ScriptTrackerMarker(_container, Colors.baseMarker, "BASE");
			var stimMarker : ScriptTrackerMarker = new ScriptTrackerMarker(_container, Colors.stimMarker, "STIM");
			var tipMarker : ScriptTrackerMarker = new ScriptTrackerMarker(_container, Colors.tipMarker, "TIP");
			
			baseSubController = new ScriptTrackerSubController(
				baseMarker, scriptTrackerStates._baseTrackerAttachedTo, scriptTrackerStates._baseTrackerPoint, scriptTrackerStates._baseGlobalTrackerPoint, Shortcuts.grabBaseMarker);
			stimSubController = new ScriptTrackerSubController(
				stimMarker, scriptTrackerStates._stimTrackerAttachedTo, scriptTrackerStates._stimTrackerPoint, scriptTrackerStates._stimGlobalTrackerPoint, Shortcuts.grabStimMarker);
			tipSubController = new ScriptTrackerSubController(
				tipMarker, scriptTrackerStates._tipTrackerAttachedTo, scriptTrackerStates._tipTrackerPoint, scriptTrackerStates._tipGlobalTrackerPoint, Shortcuts.grabTipMarker);
			
			subControllers = new Vector.<ScriptTrackerSubController>();
			subControllers.push(baseSubController, stimSubController, tipSubController);
			
			for (var i : Number = 0; i < subControllers.length; i++) {
				subControllers[i].initalAttachEvent.listen(this, onTrackerInitialAttach);
			}
			
			depthPreview = new DepthPreview(_container);
		}
		
		public function update() : void {
			var subControllerForDraggedMarker : ScriptTrackerSubController;
			
			for (var i : Number = 0; i < subControllers.length; i++) {
				subControllers[i].update();
				if (subControllers[i].isDraggingMarker() == true) {
					subControllerForDraggedMarker = subControllers[i];
				}
			}
			
			scriptTrackerStates._isDraggingTrackerMarker.setValue(subControllerForDraggedMarker != null);
			
			if (subControllerForDraggedMarker != null) {
				var attachedTo : TPDisplayObject = subControllerForDraggedMarker.getAttachedToStateValue();
				
				if (attachedTo != null) {
					scriptTrackerStates._childUnderDraggedMarker.setValue(attachedTo);
				} else {
					var childAtCursor : TPDisplayObject = StageChildSelectionUtil.getClickableChildAtCursor();
					scriptTrackerStates._childUnderDraggedMarker.setValue(childAtCursor);
				}
			}
		}
		
		private function onTrackerInitialAttach(_child : TPDisplayObject) : void {
			scriptTrackerStates._lastDraggedTrackerAttachedTo.setValue(_child);
		}
	}
}