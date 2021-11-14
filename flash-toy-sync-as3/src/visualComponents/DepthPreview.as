package visualComponents {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.geom.Point;
	import states.ScriptRecordingStates;
	import states.ScriptTrackerStates;
	import utils.MathUtil;
	import utils.SceneScriptUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DepthPreview {
		
		private var overlayContainer : TPMovieClip;
		
		public function DepthPreview(_container : TPMovieClip) {
			overlayContainer = TPMovieClip.create(_container, "overlayContainer");
			
			Index.enterFrameEvent.listen(this, onEnterFrame);
		}
		
		private function onEnterFrame() : void {
			overlayContainer.graphics.clear();
			
			if (ScriptTrackerStates.isDraggingTrackerMarker.value == false && ScriptRecordingStates.isDraggingSampleMarker.value == false) {
				return;
			}
			
			var base : Point = ScriptTrackerStates.baseGlobalTrackerPoint.value || ScriptRecordingStates.interpolatedBasePoint.value;
			var stim : Point = ScriptTrackerStates.stimGlobalTrackerPoint.value || ScriptRecordingStates.interpolatedStimPoint.value;
			var tip : Point = ScriptTrackerStates.tipGlobalTrackerPoint.value || ScriptRecordingStates.interpolatedTipPoint.value;
			
			if (base == null || tip == null) {
				return;
			}
			
			var markerRadius : Number = 8;
			var distance : Number = MathUtil.distanceBetween(base, tip);
			var direction : Point = tip.subtract(base);
			direction.normalize(1);
			
			if (distance < markerRadius * 2) {
				return;
			}
			
			var lineOffset : Point = direction.clone();
			lineOffset.normalize(0);
			
			var lineStart : Point = base.add(lineOffset);
			var lineEnd : Point = tip.subtract(lineOffset);
			
			overlayContainer.graphics.lineStyle(3, 0x000000, 0.25);
			overlayContainer.graphics.moveTo(lineStart.x, lineStart.y);
			overlayContainer.graphics.lineTo(lineEnd.x, lineEnd.y);
			
			overlayContainer.graphics.lineStyle(1, 0xFFFFFF, 0.5);
			overlayContainer.graphics.moveTo(lineStart.x, lineStart.y);
			overlayContainer.graphics.lineTo(lineEnd.x, lineEnd.y);
			
			if (stim == null) {
				return;
			}
			
			var depth : Number = SceneScriptUtil.caclulateDepth(base, stim, tip);
			
			var depthLineEnd : Point = new Point(MathUtil.lerp(tip.x, base.x, depth), MathUtil.lerp(tip.y, base.y, depth));
			
			var depthLineDirection : Point = depthLineEnd.subtract(stim);
			depthLineDirection.normalize(1);
			
			var depthLineStartOffset : Point = depthLineDirection.clone();
			depthLineStartOffset.normalize(markerRadius);
			
			var depthLineStart : Point = stim.add(depthLineStartOffset);
			
			overlayContainer.graphics.lineStyle(3, 0x000000, 0.25);
			overlayContainer.graphics.moveTo(depthLineStart.x, depthLineStart.y);
			overlayContainer.graphics.lineTo(depthLineEnd.x, depthLineEnd.y);
			
			overlayContainer.graphics.lineStyle(1, 0xFFFFFF, 0.5);
			overlayContainer.graphics.moveTo(depthLineStart.x, depthLineStart.y);
			overlayContainer.graphics.lineTo(depthLineEnd.x, depthLineEnd.y);
		}
	}
}