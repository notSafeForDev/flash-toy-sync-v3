package controllers {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.ui.Keyboard;
	import states.ScriptStates;
	import ui.ScriptTrackerMarker;
	import utils.StageChildSelectionUtil;
	
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
		
		public function ScriptTrackersController(_scriptStates : ScriptStates, _container : TPMovieClip) {
			scriptStates = _scriptStates;
			
			var baseMarker : ScriptTrackerMarker = new ScriptTrackerMarker(_container, 0xDB2547, "BASE");
			var stimMarker : ScriptTrackerMarker = new ScriptTrackerMarker(_container, 0x00FF00, "STIM");
			var tipMarker : ScriptTrackerMarker = new ScriptTrackerMarker(_container, 0x0000FF, "TIP");
			
			baseSubController = new ScriptTrackerSubController(baseMarker, _scriptStates._baseTrackerAttachedTo, _scriptStates._baseTrackerPoint, Keyboard.B);
			stimSubController = new ScriptTrackerSubController(stimMarker, _scriptStates._stimTrackerAttachedTo, _scriptStates._stimTrackerPoint, Keyboard.S);
			tipSubController = new ScriptTrackerSubController(tipMarker, _scriptStates._tipTrackerAttachedTo, _scriptStates._tipTrackerPoint, Keyboard.T);
			
			subControllers = new Vector.<ScriptTrackerSubController>();
			subControllers.push(baseSubController, stimSubController, tipSubController);
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
	}
}