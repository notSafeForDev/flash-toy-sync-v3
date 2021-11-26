package visualComponents {
	
	import components.Timeout;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.geom.Point;
	import states.ScriptRecordingStates;
	import states.ScriptTrackerStates;
	import ui.TextElement;
	import ui.TextStyles;
	import utils.MathUtil;
	import utils.SceneScriptUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DepthPreview {
		
		private var overlayContainer : TPMovieClip;
		private var depthText : TextElement;
		private var shouldHighlightDepth : Boolean = false;
		private var highlightDepthTimeout : Number = -1;
		
		public function DepthPreview(_container : TPMovieClip) {
			overlayContainer = TPMovieClip.create(_container, "overlayContainer");
			
			depthText = new TextElement(overlayContainer, "");
			TextStyles.applyMarkerStyle(depthText);
			
			Index.enterFrameEvent.listen(this, onEnterFrame);
			
			ScriptRecordingStates.listen(this, onInterpolatedStimPointStateChange, [ScriptRecordingStates.interpolatedStimPoint]);
		}
		
		private function onEnterFrame() : void {
			overlayContainer.graphics.clear();
			depthText.element.visible = false;
			
			var shouldDrawLines : Boolean = ScriptTrackerStates.isDraggingTrackerMarker.value == true || ScriptRecordingStates.isDraggingSampleMarker.value == true;
			
			if (shouldDrawLines == false && shouldHighlightDepth == false) {
				return;
			}
			
			var base : Point = ScriptTrackerStates.baseGlobalTrackerPoint.value || ScriptRecordingStates.interpolatedBasePoint.value;
			var stim : Point = ScriptTrackerStates.stimGlobalTrackerPoint.value || ScriptRecordingStates.interpolatedStimPoint.value;
			var tip : Point = ScriptTrackerStates.tipGlobalTrackerPoint.value || ScriptRecordingStates.interpolatedTipPoint.value;
			
			var canCalculateDepth : Boolean = base != null && stim != null && tip != null;
			
			if (shouldDrawLines == true && base != null && tip != null) {
				drawBaseToTipLine(base, tip);
			}
			
			if (canCalculateDepth == true) {
				var depth : Number = SceneScriptUtil.caclulateDepth(base, stim, tip);
				
				depthText.element.x = stim.x + 15;
				depthText.element.y = stim.y - 8;
				depthText.text = Math.round(depth * 100) + "%";
				depthText.element.visible = true;
				
				if (shouldDrawLines == true) {
					drawDepthLine(base, stim, tip, depth);
				}
			}
		}
		
		private function onInterpolatedStimPointStateChange() : void {
			trace(ScriptRecordingStates.isDraggingSampleMarker.value);
			
			if (ScriptTrackerStates.isDraggingTrackerMarker.value == true || ScriptRecordingStates.isDraggingSampleMarker.value == true) {
				return;
			}
			
			Timeout.clear(highlightDepthTimeout);
			
			depthText.element.visible = true;
			shouldHighlightDepth = true;
			highlightDepthTimeout = Timeout.set(this, doneHighlightingDepth, 500);
		}
		
		private function doneHighlightingDepth() : void {
			shouldHighlightDepth = false;
		}
		
		private function drawBaseToTipLine(_base : Point, _tip : Point) : void {
			var markerRadius : Number = 8;
			var distance : Number = MathUtil.distanceBetween(_base, _tip);
			var direction : Point = _tip.subtract(_base);
			direction.normalize(1);
			
			if (distance < markerRadius * 2) {
				return;
			}
			
			var lineOffset : Point = direction.clone();
			lineOffset.normalize(0);
			
			var lineStart : Point = _base.add(lineOffset);
			var lineEnd : Point = _tip.subtract(lineOffset);
			
			overlayContainer.graphics.lineStyle(3, 0x000000, 0.25);
			overlayContainer.graphics.moveTo(lineStart.x, lineStart.y);
			overlayContainer.graphics.lineTo(lineEnd.x, lineEnd.y);
			
			overlayContainer.graphics.lineStyle(1, 0xFFFFFF, 0.5);
			overlayContainer.graphics.moveTo(lineStart.x, lineStart.y);
			overlayContainer.graphics.lineTo(lineEnd.x, lineEnd.y);
		}
		
		private function drawDepthLine(_base : Point, _stim : Point, _tip : Point, _depth : Number) : void {
			var markerRadius : Number = 8;
			
			var depthLineEnd : Point = new Point(MathUtil.lerp(_tip.x, _base.x, _depth), MathUtil.lerp(_tip.y, _base.y, _depth));
			
			var depthLineDirection : Point = depthLineEnd.subtract(_stim);
			depthLineDirection.normalize(1);
			
			var depthLineStartOffset : Point = depthLineDirection.clone();
			depthLineStartOffset.normalize(markerRadius);
			
			var depthLineStart : Point = _stim.add(depthLineStartOffset);
			
			overlayContainer.graphics.lineStyle(3, 0x000000, 0.25);
			overlayContainer.graphics.moveTo(depthLineStart.x, depthLineStart.y);
			overlayContainer.graphics.lineTo(depthLineEnd.x, depthLineEnd.y);
			
			overlayContainer.graphics.lineStyle(1, 0xFFFFFF, 0.5);
			overlayContainer.graphics.moveTo(depthLineStart.x, depthLineStart.y);
			overlayContainer.graphics.lineTo(depthLineEnd.x, depthLineEnd.y);
		}
	}
}