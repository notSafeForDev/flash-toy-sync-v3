package {
	
	import flash.display.MovieClip;
	
	import core.MovieClipUtil;
	
	import components.HierarchyPanel;
	import components.ExternalSWF;
	import components.StageElementSelector;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Index {
		
		public function Index(_container : MovieClip, _animationPath : String) {
			if (_container == null) {
				throw new Error("Unable construct Index, the container is not valid");
			}
			
			var stageElementSelector : StageElementSelector;
			var animationContainer : MovieClip = MovieClipUtil.create(_container, "animationContainer");
			var stageElementSelectorOverlay : MovieClip = MovieClipUtil.create(_container, "stageElementSelectorOverlay");
			var hierarchyPanel : HierarchyPanel = new HierarchyPanel(_container);
			
			var swf : ExternalSWF = new ExternalSWF(_animationPath, animationContainer);
			
			swf.onLoaded.listen(this, function(_swf : MovieClip) : void {
				stageElementSelector = new StageElementSelector(_swf, stageElementSelectorOverlay);
			});
		}
	}
}