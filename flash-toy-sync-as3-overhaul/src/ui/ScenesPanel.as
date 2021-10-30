package ui {
	
	import core.TPMovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenesPanel extends Panel {
		
		private var scrollbarWidth : Number = 10;
		
		private var uiScrollArea : UIScrollArea;
		
		public function ScenesPanel(_parent : TPMovieClip, _contentWidth : Number, _contentHeight : Number) {
			super(_parent, "Scenes", _contentWidth, _contentHeight);
			
			var scrollAreaHeight : Number = contentHeight;
			var scrollAreaContainer : TPMovieClip = TPMovieClip.create(content, "scrollContainer");
			var scrollContent : TPMovieClip = TPMovieClip.create(scrollAreaContainer, "scrollContent");
			
			scrollPadder = TPMovieClip.create(scrollContent, "scrollPadder");
			scrollPadder.graphics.beginFill(0xFF0000, 0);
			scrollPadder.graphics.drawRect(0, 0, 10, 10);
			
			listItems = new Vector.<UIListItem>();
			
			uiScrollArea = createScrollArea(scrollAreaContainer, scrollContent, scrollAreaHeight);
		}
		
		private function createScrollArea(_container : TPMovieClip, _content : TPMovieClip, _height : Number) : UIScrollArea {
			var scrollbarBackground : TPMovieClip = TPMovieClip.create(_container, "scrollbarHandle");
			scrollbarBackground.graphics.beginFill(0x000000, 0.25);
			scrollbarBackground.graphics.drawRect(contentWidth - scrollbarWidth, 0, scrollbarWidth, _height);
			
			var scrollbarHandle : TPMovieClip = TPMovieClip.create(_container, "scrollbarHandle");
			scrollbarHandle.graphics.beginFill(0xFFFFFF);
			scrollbarHandle.graphics.drawRect(contentWidth - scrollbarWidth, 0, scrollbarWidth, scrollbarWidth);
			
			var mask : TPMovieClip = TPMovieClip.create(_container, "mask");
			mask.graphics.beginFill(0xFF0000, 0.5);
			mask.graphics.drawRect(0, 0, contentWidth - scrollbarWidth, _height);
			
			return new UIScrollArea(_content, mask, scrollbarHandle);
		}
		
		public function update(_infoList : Vector.<HierarchyChildInfo>) : void {
			if (isMinimized() == true) {
				clearList();
				return;
			}
			
			updateList(_infoList);
		}
		
		private function updateList(_infoList : Vector.<HierarchyChildInfo>) : void {
			var i : Number;
			
			for (i = 0; i < _infoList.length; i++) {
				var listItem : UIListItem;
				
				if (i >= listItems.length) {
					listItem = new UIListItem(uiScrollArea.content, contentWidth - scrollbarWidth, i);
					listItem.clickEvent.listen(this, onListItemClick);
					listItems.push(listItem);
				} else {
					listItem = listItems[i];
				}
				
				listItem.show();
				
				var isVisible : Boolean = uiScrollArea.isElementVisible(listItem.background);
				
				if (isVisible == false) {
					listItem.hide();
					continue;
				}
				
				listItem.setPrimaryText("Scene " + i);
			}
			
			if (listItems.length > 0) {
				scrollPadder.height = _infoList.length * listItems[0].getHeight();
			}
			
			for (i = _infoList.length; i < listItems.length; i++) {
				listItems[i].hide();
			}
		}
		
		private function clearList() : void {
			for (var i : Number = listItems.length; i < listItems.length; i++) {
				listItems[i].hide();
			}
		}
	}
}