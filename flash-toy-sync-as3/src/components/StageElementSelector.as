package components {
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import core.StageUtil;
	import core.FunctionUtil;
	import core.MovieClipUtil;
	import core.GraphicsUtil;
	import core.MouseEvents;
	import core.MovieClipEvents;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StageElementSelector {
		
		private var container : MovieClip;
		private var overlay : MovieClip;
		private var selectedChildren : Array = [];
		
		public function StageElementSelector(_container : MovieClip, _overlay : MovieClip) {
			container = _container;
			overlay = _overlay;
			
			MovieClipEvents.addOnEnterFrame(this, overlay, onEnterFrame);
			MouseEvents.addOnMouseDown(this, container, onMouseDown);
		}
		
		private function onEnterFrame() : void {
			drawBounds();
		}
		
		private function onMouseDown() : void {
			selectedChildren.length = 0;
			
			var nestedChildren : Array = MovieClipUtil.getNestedChildren(container);
			
			for (var i : Number = 0; i < nestedChildren.length; i++) {
				var stageX : Number = StageUtil.getMouseX();
				var stageY : Number = StageUtil.getMouseY();
				var wasHit : Boolean = MovieClipUtil.hitTest(nestedChildren[i], stageX, stageY, true);
				if (wasHit == true) {
					selectedChildren.push(nestedChildren[i]);
				}
			}
		}
		
		private function drawBounds() : void {
			GraphicsUtil.clear(overlay);
			GraphicsUtil.setLineStyle(overlay, 2, 0x00FF00);
			
			for (var i : Number = 0; i < selectedChildren.length; i++) {
				var child : MovieClip = selectedChildren[i];
				if (MovieClipUtil.getParent(child) == null) {
					continue;
				}
				
				var bounds : Rectangle = MovieClipUtil.getBounds(child, overlay);
				GraphicsUtil.drawRect(overlay, bounds.x, bounds.y, bounds.width, bounds.height);
			}
		}
	}
}