package visualComponents {
	
	import core.TPBitmapUtil;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import core.TPStage;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import states.ScriptTrackerStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StageElementHighlighter {
		
		private var overlay : TPMovieClip;
		
		private var childBitmap : TPDisplayObject;
		
		public function StageElementHighlighter(_container : TPMovieClip) {
			overlay = TPMovieClip.create(_container, "stageElementHighlighterOverlay");
			
			overlay.addEnterFrameListener(this, onEnterFrame);
		}
		
		private function onEnterFrame() : void {
			if (childBitmap != null) {
				childBitmap.visible = false;
			}
			
			if (ScriptTrackerStates.isDraggingTrackerMarker.value == true && ScriptTrackerStates.childUnderDraggedMarker.value != null) {
				highlightElement(ScriptTrackerStates.childUnderDraggedMarker.value);
			}
		}
		
		private function highlightElement(_child : TPDisplayObject) : void {
			var bounds : Rectangle = _child.getBounds(overlay);
			var color : Number = 0x00FF00;
			
			if (childBitmap != null) {
				TPDisplayObject.remove(childBitmap);
				childBitmap = null;
			}
			
			if (bounds.width < TPStage.stageWidth && bounds.height < TPStage.stageHeight) {
				childBitmap = TPBitmapUtil.drawToBitmap(_child, overlay);
				TPDisplayObject.applyTransformMatrixFromOtherObject(_child, childBitmap);
				childBitmap.filters = [new GlowFilter(color, 0.5, 4, 4, 16, 2, true, true)];
			}
		}
	}
}