package controllers {
	
	import components.KeyboardInput;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import models.ScriptTrackingMarkerModel;
	import states.ScriptStates;
	import utils.MathUtil;
	import utils.SceneScriptUtil;
	import utils.StageChildSelectionUtil;
	import ui.ScriptMarker;
	import ui.ScriptTrackingMarker;
	import visualComponents.DepthPreview;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptTrackerMarkersEditorController {
		
		private var scriptStates : ScriptStates;
		
		private var baseModel : ScriptTrackingMarkerModel;
		private var stimModel : ScriptTrackingMarkerModel;
		private var tipModel : ScriptTrackingMarkerModel;
		
		private var trackingModels : Vector.<ScriptTrackingMarkerModel>;
		
		private var baseShortcut : Number = Keyboard.B;
		private var stimShortcut : Number = Keyboard.S;
		private var tipShortcut : Number = Keyboard.T;
		
		public function ScriptTrackerMarkersEditorController(_scriptStates : ScriptStates, _container : TPMovieClip) {
			scriptStates = _scriptStates;
			
			var baseMarker : ScriptTrackingMarker = new ScriptTrackingMarker(_container, 0xDB2547, "BASE");
			var stimMarker : ScriptTrackingMarker = new ScriptTrackingMarker(_container, 0x00FF00, "STIM");
			var tipMarker : ScriptTrackingMarker = new ScriptTrackingMarker(_container, 0x0000FF, "TIP");
			
			var depthPreview : DepthPreview = new DepthPreview(_container, baseMarker, stimMarker, tipMarker);
			
			baseMarker.hide();
			stimMarker.hide();
			tipMarker.hide();
			
			baseModel = new ScriptTrackingMarkerModel(baseMarker, scriptStates._baseTrackerAttachedTo, scriptStates._baseTrackerPoint);
			stimModel = new ScriptTrackingMarkerModel(stimMarker, scriptStates._stimTrackerAttachedTo, scriptStates._stimTrackerPoint);
			tipModel = new ScriptTrackingMarkerModel(tipMarker, scriptStates._tipTrackerAttachedTo, scriptStates._tipTrackerPoint);
			
			trackingModels = new Vector.<ScriptTrackingMarkerModel>();
			trackingModels.push(baseModel, stimModel, tipModel);
			
			KeyboardInput.addShortcut([baseShortcut], this, onGrabMarkerShortcut, [baseModel]);
			KeyboardInput.addShortcut([stimShortcut], this, onGrabMarkerShortcut, [stimModel]);
			KeyboardInput.addShortcut([tipShortcut], this, onGrabMarkerShortcut, [tipModel]);
			
			KeyboardInput.keyUpEvent.listen(this, onKeyUp);
		}
		
		public function update() : void {
			var isDraggingAnyMarker : Boolean = false;
			var areAllMarkersVisible : Boolean = true;
			
			for (var i : Number = 0; i < trackingModels.length; i++) {
				if (trackingModels[i].element.isDragging() == true) {
					isDraggingAnyMarker = true;
				}
			}
			
			scriptStates._isDraggingTrackerMarker.setValue(isDraggingAnyMarker);
			
			if (isDraggingAnyMarker == true) {
				var childAtCursor : TPDisplayObject = StageChildSelectionUtil.getClickableChildAtCursor();
				scriptStates._childUnderDraggedMarker.setValue(childAtCursor);
			}
		}
		
		private function onGrabMarkerShortcut(_model : ScriptTrackingMarkerModel) : void {
			_model.element.moveToCursor();
			_model.element.startDrag();
			_model.element.show();
		}
		
		private function onKeyUp(_key : Number) : void {
			for (var i : Number = 0; i < trackingModels.length; i++) {
				if (trackingModels[i].element.isDragging() == true) {
					trackingModels[i].element.stopDrag();
				}
			}
		}
	}
}