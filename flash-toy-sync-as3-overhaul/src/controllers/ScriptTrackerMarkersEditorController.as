package controllers {
	
	import components.KeyboardInput;
	import core.TPMovieClip;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import models.ScriptTrackingMarkerModel;
	import states.ScriptStates;
	import utils.MathUtil;
	import utils.SceneScriptUtil;
	import visualComponents.ScriptMarker;
	import visualComponents.ScriptTrackingMarker;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptTrackerMarkersEditorController {
		
		private var scriptStates : ScriptStates;
		
		private var depthPreview : TPMovieClip;
		
		private var baseModel : ScriptTrackingMarkerModel;
		private var stimModel : ScriptTrackingMarkerModel;
		private var tipModel : ScriptTrackingMarkerModel;
		
		private var trackingModels : Vector.<ScriptTrackingMarkerModel>;
		
		private var baseShortcut : Number = Keyboard.B;
		private var stimShortcut : Number = Keyboard.S;
		private var tipShortcut : Number = Keyboard.T;
		
		public function ScriptTrackerMarkersEditorController(_scriptStates : ScriptStates, _container : TPMovieClip) {
			scriptStates = _scriptStates;
			
			depthPreview = TPMovieClip.create(_container, "depthPreview");
			
			var baseMarker : ScriptTrackingMarker = new ScriptTrackingMarker(_container, 0xDB2547, "BASE");
			var stimMarker : ScriptTrackingMarker = new ScriptTrackingMarker(_container, 0x00FF00, "STIM");
			var tipMarker : ScriptTrackingMarker = new ScriptTrackingMarker(_container, 0x0000FF, "TIP");
			
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
			depthPreview.graphics.clear();
			
			var isDraggingAnyMarker : Boolean = false;
			var areAllMarkersVisible : Boolean = true;
			
			for (var i : Number = 0; i < trackingModels.length; i++) {
				if (trackingModels[i].element.isDragging() == true) {
					isDraggingAnyMarker = true;
				}
			}
			
			if (isDraggingAnyMarker == true) {
				drawDepthPreview();
			}
		}
		
		// TODO: Move to a util class or a trackerMarkersDepthPreview class
		private function drawDepthPreview() : void {
			depthPreview.graphics.clear();
			
			if (baseModel.element.isVisible() == false || tipModel.element.isVisible() == false) {
				return;
			}
			
			var markerRadius : Number = baseModel.element.getRadius();
			var basePoint : Point = baseModel.element.getPosition();
			var tipPoint : Point = tipModel.element.getPosition();
			var distance : Number = MathUtil.distanceBetween(basePoint, tipPoint);
			var direction : Point = tipPoint.subtract(basePoint);
			direction.normalize(1);
			
			if (distance < markerRadius * 2) {
				return;
			}
			
			var lineOffset : Point = direction.clone();
			lineOffset.normalize(markerRadius + 10);
			
			var lineStart : Point = basePoint.add(lineOffset);
			var lineEnd : Point = tipPoint.subtract(lineOffset);
			
			depthPreview.graphics.lineStyle(2, 0xDB2547, 0.25);
			depthPreview.graphics.moveTo(lineStart.x, lineStart.y);
			depthPreview.graphics.lineTo(lineEnd.x, lineEnd.y);
			
			if (stimModel.element.isVisible() == false) {
				return;
			}
			
			var stimPoint : Point = stimModel.element.getPosition();
			
			var depth : Number = SceneScriptUtil.caclulateDepth(basePoint, tipPoint, stimPoint);
			
			var depthLineEnd : Point = new Point(MathUtil.lerp(tipPoint.x, basePoint.x, depth), MathUtil.lerp(tipPoint.y, basePoint.y, depth));
			
			var depthLineDirection : Point = depthLineEnd.subtract(stimPoint);
			depthLineDirection.normalize(1);
			
			var depthLineStartOffset : Point = depthLineDirection.clone();
			depthLineStartOffset.normalize(markerRadius);
			
			var depthLineStart : Point = stimPoint.add(depthLineStartOffset);
			
			depthPreview.graphics.moveTo(depthLineStart.x, depthLineStart.y);
			depthPreview.graphics.lineTo(depthLineEnd.x, depthLineEnd.y);
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