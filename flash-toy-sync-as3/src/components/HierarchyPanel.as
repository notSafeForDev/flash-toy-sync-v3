package components {
	
	import core.MovieClipEvents;
	import core.MovieClipUtil;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanel {
		
		private var base : Panel;
		private var animationContainer : MovieClip;
		
		public function HierarchyPanel(_parent : MovieClip, _animationContainer : MovieClip) {
			base = new Panel(_parent, "Hierarchy", 200, 400);
			animationContainer = _animationContainer;
			
			MovieClipEvents.addOnExitFrame(this, _animationContainer, onExitFrame);
		}
		
		private function onExitFrame() : void {
			var nestedChildren : Array = MovieClipUtil.getNestedChildren(animationContainer);
			trace(nestedChildren.length);
		}
	}
}