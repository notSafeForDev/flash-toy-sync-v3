package components {
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
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
			MouseEvents.add(this, container, "mouseDown", onMouseDown); // TODO: Change to addOnMouseDown
		}
		
		private function onEnterFrame() {
			drawBounds();
		}
		
		private function onMouseDown(_clickedChildren : Array) {
			if (_clickedChildren.length == 0) {
				selectedChildren.length = 0;
				return;
			}
			
			selectedChildren.length = 0;
			for (var i = 0; i < _clickedChildren.length; i++) {
				selectedChildren.push(_clickedChildren[i]);
			}
		}
		
		private function drawBounds() {
			GraphicsUtil.clear(overlay);
			GraphicsUtil.setLineStyle(overlay, 2, 0x00FF00);
			
			for (var i = 0; i < selectedChildren.length; i++) {
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