package ui {
	import core.TPMovieClip;
	import states.AnimationSceneStates;
	import utils.ArrayUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenesUIListItem extends UIListItem {
		
		public function ScenesUIListItem(_parent : TPMovieClip, _width : Number, _height : Number) {
			super(_parent, _width, _height);
		}
		
		public function update() : void {
			updateBackgroundGraphics();
		}
		
		protected override function updateBackgroundGraphics() : void {
			super.updateBackgroundGraphics();
			
			var scenes : Array = AnimationSceneStates.scenes.value;
			var selectedScenes : Array = AnimationSceneStates.selectedScenes.value;
			var selectedSceneIndexes : Vector.<Number> = ArrayUtil.indexesOf(scenes, selectedScenes);
			
			if (ArrayUtil.includes(selectedSceneIndexes, index) == true) {
				background.graphics.beginFill(0xFFFFFF);
				Icons.drawListItemSelectionIcon(background.graphics, 6, 5, 6, 10);
			}
		}
	}
}