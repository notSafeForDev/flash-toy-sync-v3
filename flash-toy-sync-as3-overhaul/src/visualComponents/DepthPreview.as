package visualComponents {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.geom.Point;
	import states.ScriptStates;
	import ui.ScriptMarker;
	import utils.MathUtil;
	import utils.SceneScriptUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DepthPreview {
		
		private var overlayContainer : TPMovieClip;
		
		private var baseMarker : ScriptMarker;
		private var stimMarker : ScriptMarker;
		private var tipMarker : ScriptMarker
		
		public function DepthPreview(_container : TPMovieClip, _baseMarker : ScriptMarker, _stimMarker : ScriptMarker, _tipMarker : ScriptMarker) {
			overlayContainer = TPMovieClip.create(_container, "overlayContainer");
			
			baseMarker = _baseMarker;
			stimMarker = _stimMarker;
			tipMarker = _tipMarker;
			
			Index.enterFrameEvent.listen(this, onEnterFrame);
		}
		
		private function onEnterFrame() : void {
			overlayContainer.graphics.clear();
			
			if (ScriptStates.isDraggingTrackerMarker.value == false) {
				return;
			}
			
			if (baseMarker.isVisible() == false || tipMarker.isVisible() == false) {
				return;
			}
			
			var markerRadius : Number = 12;
			var basePoint : Point = baseMarker.getPosition();
			var tipPoint : Point = tipMarker.getPosition();
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
			
			overlayContainer.graphics.lineStyle(2, 0xDB2547, 0.25);
			overlayContainer.graphics.moveTo(lineStart.x, lineStart.y);
			overlayContainer.graphics.lineTo(lineEnd.x, lineEnd.y);
			
			if (stimMarker.isVisible() == false) {
				return;
			}
			
			var stimPoint : Point = stimMarker.getPosition();
			
			var depth : Number = SceneScriptUtil.caclulateDepth(basePoint, tipPoint, stimPoint);
			
			var depthLineEnd : Point = new Point(MathUtil.lerp(tipPoint.x, basePoint.x, depth), MathUtil.lerp(tipPoint.y, basePoint.y, depth));
			
			var depthLineDirection : Point = depthLineEnd.subtract(stimPoint);
			depthLineDirection.normalize(1);
			
			var depthLineStartOffset : Point = depthLineDirection.clone();
			depthLineStartOffset.normalize(markerRadius);
			
			var depthLineStart : Point = stimPoint.add(depthLineStartOffset);
			
			overlayContainer.graphics.moveTo(depthLineStart.x, depthLineStart.y);
			overlayContainer.graphics.lineTo(depthLineEnd.x, depthLineEnd.y);
			overlayContainer.graphics.lineTo(depthLineEnd.x, depthLineEnd.y);
		}
	}
}