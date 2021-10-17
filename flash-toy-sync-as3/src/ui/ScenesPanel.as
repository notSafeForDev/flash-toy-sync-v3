package ui {
	
	import components.Scene;
	import flash.display.MovieClip;
	import ui.ListItem;
	
	import core.CustomEvent;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.UIScrollArea;
	
	import global.GlobalState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenesPanel extends Panel {
		
		public var onSceneSelected : CustomEvent;
		
		private var scrollBarWidth : Number = 10;
		
		private var scrollContent : MovieClip;
		
		private var uiScrollArea : UIScrollArea;
		
		private var listItems : Array = [];
		
		public function ScenesPanel(_parent : MovieClip) {
			super(_parent, "Scenes", 200, 200);
			
			var scrollContainerHeight : Number = contentHeight;
			
			var scrollContainer : MovieClip = MovieClipUtil.create(content, "scrollContainer");
			
			scrollContent = MovieClipUtil.create(scrollContainer, "scrollContent");
			
			var scrollBar : MovieClip = MovieClipUtil.create(scrollContainer, "scrollBar");
			GraphicsUtil.beginFill(scrollBar, 0xFFFFFF);
			GraphicsUtil.drawRect(scrollBar, contentWidth - scrollBarWidth, 0, scrollBarWidth, scrollBarWidth);
			
			var mask : MovieClip = MovieClipUtil.create(scrollContainer, "mask");
			GraphicsUtil.beginFill(mask, 0xFF0000, 0.5);
			GraphicsUtil.drawRect(mask, 0, 0, contentWidth - scrollBarWidth, scrollContainerHeight);
			
			uiScrollArea = new UIScrollArea(scrollContent, mask, scrollBar);
			uiScrollArea.handleAlphaWhenNotScrollable = 0.25;
			
			GlobalState.listen(this, onSceneStatesChange, [GlobalState.scenes, GlobalState.currentScene]);
			
			onSceneSelected = new CustomEvent();
		}
		
		private function onSceneStatesChange() : void {
			var scenes : Array = GlobalState.scenes.state;
			var listItem : ListItem;
			var i : Number;
			
			for (i = 0; i < scenes.length; i++) {
				var scene : Scene = scenes[i];
				
				if (i == listItems.length) {
					listItem = new ListItem(scrollContent, i, contentWidth - scrollBarWidth);
					listItem.onSelect.listen(this, onListItemSelect);
					listItems.push(listItem);
				} else {
					listItem = listItems[i];
				}
				
				listItem.setPrimaryText("Scene: " + i + " | " + scene.getFirstFrames().join(","));
				
				listItem.setVisible(true);
				listItem.setHighlighted(scene == GlobalState.currentScene.state);
			}
			
			for (i = scenes.length; i < listItems.length; i++) {
				listItem = listItems[i];
				listItem.setVisible(false);
			}
		}
		
		private function onListItemSelect(_index : Number) : void {
			onSceneSelected.emit(GlobalState.scenes.state[_index]);
		}
	}
}