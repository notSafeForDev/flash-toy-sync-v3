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
		
		private var childBitmaps : Vector.<TPDisplayObject>;
		
		public function StageElementHighlighter(_container : TPMovieClip) {
			overlay = TPMovieClip.create(_container, "stageElementHighlighterOverlay");
			
			overlay.addEnterFrameListener(this, onEnterFrame);
			
			childBitmaps = new Vector.<TPDisplayObject>();
		}
		
		private function onEnterFrame() : void {
			for (var i : Number = 0; i < childBitmaps.length; i++) {
				TPDisplayObject.remove(childBitmaps[i]);
			}
			
			childBitmaps.length = 0;
			
			if (ScriptTrackerStates.isDraggingTrackerMarker.value == true && ScriptTrackerStates.childUnderDraggedMarker.value != null) {
				highlightElement(ScriptTrackerStates.childUnderDraggedMarker.value, 0x00FF00);
				
				/* var child : * = ScriptTrackerStates.childUnderDraggedMarker.value.parent;
				while (child != null) {
					highlightElement(new TPDisplayObject(child), 0xFF0000);
					var temp : * = new TPDisplayObject(child);
					child = temp.parent;
				} */
			}
		}
		
		private function highlightElement(_child : TPDisplayObject, _color : Number) : void {
			var bounds : Rectangle = _child.getBounds(overlay);
			
			if (bounds.width < TPStage.stageWidth && bounds.height < TPStage.stageHeight) {
				var childBitmap : TPDisplayObject = TPBitmapUtil.drawToBitmap(_child, overlay);
				TPDisplayObject.applyTransformMatrixFromOtherObject(_child, childBitmap);
				childBitmap.filters = [new GlowFilter(_color, 0.5, 4, 4, 16, 2, true, true)];
				childBitmaps.push(childBitmap);
			}
		}
	}
}