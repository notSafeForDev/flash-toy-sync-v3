package ui {
	
	import core.CustomEvent;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class UIList {
		
		private var itemWidth : Number;
		private var height : Number;
		private var scrollbarWidth : Number = 10;
		
		private var uiScrollArea : UIScrollArea;
		private var uiSCrollAreaContent : TPMovieClip;
		
		private var listItems : Vector.<UIListItem>;
		private var listPadding : TPMovieClip;
		
		/**
		 * Creates a scrollable list, which can be populated with UIListItem instances
		 * 
		 * Use addListItem to add an item to the pool of available items to display
		 * You should keep your own list of items so that you can update them independently of this component
		 * 
		 * Use showItemsAtScrollPosition to make it show items in the list on scroll position
		 * You are then intended to iterate over each stored item and update those that are visible
		 * 
		 * @param	_parent		The element to attach the list to
		 * @param	_width		The width of the list, including the width of the scrollbar
		 * @param	_height		The height of the list
		 * @param	_items 		A Vector of UIListItem instances
		 */
		public function UIList(_parent : TPMovieClip, _width : Number, _height : Number) {
			itemWidth = _width - scrollbarWidth;
			height = _height;
			
			listItems = new Vector.<UIListItem>();
			
			var scrollAreaContainer : TPMovieClip = TPMovieClip.create(_parent, "scrollContainer");
			uiSCrollAreaContent = TPMovieClip.create(scrollAreaContainer, "scrollContent");
			
			listPadding = TPMovieClip.create(uiSCrollAreaContent, "scrollPadder");
			listPadding.graphics.beginFill(0xFF0000, 0);
			listPadding.graphics.drawRect(0, 0, 10, 10);
			
			uiScrollArea = createScrollArea(scrollAreaContainer, uiSCrollAreaContent);
		}
		
		public function getListItemsContainer() : TPMovieClip {
			return uiSCrollAreaContent;
		}
		
		public function getScrollbarWidth() : Number {
			return scrollbarWidth;
		}
		
		public function addListItem(_listItem : UIListItem) : void {
			listItems.push(_listItem);
		}
		
		public function showItemsAtScrollPosition(_activeItemCount : Number) : void {
			if (_activeItemCount > listItems.length) {
				throw new Error("Unable to show items at scroll position, there are not enough available list items");
			}
			
			var i : Number;
			
			for (i = 0; i < _activeItemCount; i++) {
				listItems[i].show();
				
				var isVisible : Boolean = uiScrollArea.isElementVisible(listItems[i].background);
				if (isVisible == false) {
					listItems[i].hide();
					continue;
				}
			}
			
			if (listItems.length > 0) {
				listPadding.height = _activeItemCount * listItems[0].getHeight();
			}
			
			for (i = _activeItemCount; i < listItems.length; i++) {
				listItems[i].hide();
			}
		}
		
		public function hideItems() : void {
			for (var i : Number = listItems.length; i < listItems.length; i++) {
				listItems[i].hide();
			}
		}
		
		private function createScrollArea(_container : TPMovieClip, _content : TPMovieClip) : UIScrollArea {
			var scrollbarBackground : TPMovieClip = TPMovieClip.create(_container, "scrollbarHandle");
			scrollbarBackground.graphics.beginFill(0x000000, 0.25);
			scrollbarBackground.graphics.drawRect(itemWidth, 0, scrollbarWidth, height);
			
			var scrollbarHandle : TPMovieClip = TPMovieClip.create(_container, "scrollbarHandle");
			scrollbarHandle.graphics.beginFill(0xFFFFFF);
			scrollbarHandle.graphics.drawRect(itemWidth, 0, scrollbarWidth, scrollbarWidth);
			
			var mask : TPMovieClip = TPMovieClip.create(_container, "mask");
			mask.graphics.beginFill(0xFF0000, 0.5);
			mask.graphics.drawRect(0, 0, itemWidth, height);
			
			return new UIScrollArea(_content, mask, scrollbarHandle);
		}
	}
}