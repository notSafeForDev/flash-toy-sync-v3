package ui {
	
	import core.DisplayObjectUtil;
	import core.GraphicsUtil;
	import core.MovieClipEvents;
	import core.StageUtil;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import global.EditorState;
	import global.ScenesState;
	import global.ScriptingState;
	import utils.StageChildSelectionUtil;
	
	import core.MovieClipUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StageElementHighlighter {
		
		private var animation : MovieClip;
		
		private var overlay : MovieClip;
		
		private var childBitmap : Bitmap;
		
		public function StageElementHighlighter(_animation : MovieClip, _overlayContainer : MovieClip) {
			animation = _animation;
			
			overlay = MovieClipUtil.create(_overlayContainer, "stageElementHighlighterOverlay");
			
			MovieClipEvents.addOnEnterFrame(this, overlay, onEnterFrame);
		}
		
		private function onEnterFrame() : void {
			if (childBitmap != null) {
				DisplayObjectUtil.setVisible(childBitmap, false);
			}
			
			GraphicsUtil.clear(overlay);
			
			var childToHighlight : DisplayObject = null;
			
			if (EditorState.hoveredChild.value != null) {
				childToHighlight = EditorState.hoveredChild.value;
			}
			
			if (ScriptingState.isDraggingMarker.value == true && ScriptingState.childUnderDraggedMarker.value != null) {
				childToHighlight = ScriptingState.childUnderDraggedMarker.value;
			}
			
			if (ScriptingState.isDraggingMarker.value == true && ScriptingState.childUnderDraggedMarker.value == null) {
				childToHighlight = StageChildSelectionUtil.getClickableChildAtCursor(animation);
			}
			
			if (childToHighlight != null) {
				highlightElement(childToHighlight);
			}
		}
		
		private function highlightElement(_child : DisplayObject) : void {
			var bounds : Rectangle = DisplayObjectUtil.getBounds(_child, overlay);
			var color : Number = DisplayObjectUtil.isShape(_child) ? 0xFFFF00 :  0x00FF00;
			
			if (childBitmap != null) {
				DisplayObjectUtil.remove(childBitmap);
				childBitmap = null;
			}
			
			if (bounds.width < StageUtil.getWidth() && bounds.height < StageUtil.getHeight()) {
				childBitmap = DisplayObjectUtil.drawToBitmap(_child, overlay);
				DisplayObjectUtil.applyTransformMatrixFromOtherObject(_child, childBitmap);
				childBitmap.filters = [new GlowFilter(color, 0.5, 4, 4, 16, 2, true, true)];
			}
			
			/* GraphicsUtil.setLineStyle(overlay, 2, color);
			GraphicsUtil.drawRect(overlay, bounds.x, bounds.y, bounds.width, bounds.height); */
		}
	}
}