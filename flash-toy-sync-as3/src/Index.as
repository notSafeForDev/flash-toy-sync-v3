package {
	
	import core.MovieClipEvents;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	
	import core.MovieClipUtil;
	
	import components.HierarchyPanel;
	import components.ExternalSWF;
	import components.StageElementSelector;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Index {
		
		private var container : MovieClip;
		private var animation : MovieClip;
		private var stageElementSelector : StageElementSelector;
		private var animationContainer : MovieClip;
		private var stageElementSelectorOverlay : MovieClip;
		private var hierarchyPanel : HierarchyPanel;
		
		public function Index(_container : MovieClip, _animationPath : String) {
			if (_container == null) {
				throw new Error("Unable construct Index, the container is not valid");
			}
			
			container = _container;
			animationContainer = MovieClipUtil.create(_container, "animationContainer");
			stageElementSelectorOverlay = MovieClipUtil.create(_container, "stageElementSelectorOverlay");
			
			var externalSWF : ExternalSWF = new ExternalSWF(_animationPath, animationContainer);
			externalSWF.onLoaded.listen(this, onSWFLoaded);
		}
		
		private function onSWFLoaded(_swf : MovieClip) : void {
			animation = _swf;
			stageElementSelector = new StageElementSelector(_swf, stageElementSelectorOverlay);
			hierarchyPanel = new HierarchyPanel(container, _swf);
			hierarchyPanel.excludeChildrenWithoutNestedAnimations = true;
			
			// We add the onEnterFrame listener on the container, instead of the animation, for better compatibility with AS2
			// As the contents of _swf can be replaced by the loaded swf file
			MovieClipEvents.addOnEnterFrame(this, container, onEnterFrame);
		}
		
		private function onEnterFrame() : void {
			// var startTime : int = flash.utils.getTimer();
			hierarchyPanel.update();
			// var endTime : int = flash.utils.getTimer();
			// trace(endTime - startTime);
		}
	}
}