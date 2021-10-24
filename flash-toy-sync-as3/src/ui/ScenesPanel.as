package ui {
	
	import flash.display.MovieClip;
	import global.GlobalEvents;
	
	import core.DisplayObjectUtil;
	import core.CustomEvent;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.UIScrollArea;

	import global.ScenesState;

	import components.Scene;

	import ui.ListItem;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenesPanel extends Panel {
		
		public var onSceneSelected : CustomEvent;
		public var onDelete : CustomEvent;
		
		private var scrollBarWidth : Number = 10;
		
		private var scrollContent : MovieClip;
		
		private var uiScrollArea : UIScrollArea;
		
		private var deleteButton : UIButton;
		
		private var listItems : Array = [];
		
		public function ScenesPanel(_parent : MovieClip) {
			super(_parent, "Scenes", 200, 245);
			
			var scrollContainerHeight : Number = 200;
			
			var scrollContainer : MovieClip = MovieClipUtil.create(content, "scrollContainer");
			
			scrollContent = MovieClipUtil.create(scrollContainer, "scrollContent");
			
			var scrollBar : MovieClip = MovieClipUtil.create(scrollContainer, "scrollBar");
			GraphicsUtil.beginFill(scrollBar, 0xFFFFFF);
			GraphicsUtil.drawRect(scrollBar, contentWidth - scrollBarWidth, 0, scrollBarWidth, scrollBarWidth);
			
			var mask : MovieClip = MovieClipUtil.create(scrollContainer, "mask");
			GraphicsUtil.beginFill(mask, 0xFF0000, 0.5);
			GraphicsUtil.drawRect(mask, 0, 0, contentWidth - scrollBarWidth, scrollContainerHeight);
			
			uiScrollArea = new UIScrollArea(scrollContent, mask, scrollBar);
			uiScrollArea.disabledHandleAlpha = 0.25;
			
			deleteButton = addButton("Delete");
			// Since the scrollContainer isn't part of the layout, we have to manually move the button
			DisplayObjectUtil.setY(deleteButton.element, scrollContainerHeight + layoutElementsSpacing);
			deleteButton.onMouseClick.listen(this, onDeleteButtonClick);
			
			onSceneSelected = new CustomEvent();
			onDelete = new CustomEvent();
			
			ScenesState.listen(this, onCurrentSceneStateChange, [ScenesState.currentScene]);
			
			GlobalEvents.enterFrame.listen(this, onEnterFrame);
		}
		
		private function onCurrentSceneStateChange() : void {
			var scenes : Array = ScenesState.scenes.value;
			for (var i : Number = 0; i < listItems.length; i++) {
				var scene : Scene = scenes[i];
				if (scene == ScenesState.currentScene.value) {
					uiScrollArea.scrollTo(listItems[i].background);
				}
			}
		}
		
		private function onEnterFrame() : void {
			var scenes : Array = ScenesState.scenes.value;
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
				
				listItem.setPrimaryText("Scene: " + i + " | " + scene.getFirstFrames().join(",") + "-" + scene.getLastFrame());
				
				listItem.setVisible(true);
				listItem.setHighlighted(scene == ScenesState.currentScene.value);
			}
			
			for (i = scenes.length; i < listItems.length; i++) {
				listItem = listItems[i];
				listItem.setVisible(false);
			}
			
			if (ScenesState.currentScene.value != null) {
				deleteButton.enable();
			} else {
				deleteButton.disable();
			}
		}
		
		private function onListItemSelect(_index : Number) : void {
			onSceneSelected.emit(ScenesState.scenes.value[_index]);
		}
		
		private function onDeleteButtonClick() : void {
			onDelete.emit();
		}
	}
}