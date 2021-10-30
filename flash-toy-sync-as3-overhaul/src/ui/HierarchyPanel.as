package ui {
	
	import components.HierarchyChildInfo;
	import core.CustomEvent;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanel extends Panel {
		
		public var selectEvent : CustomEvent;
		public var toggleExpandEvent : CustomEvent;
		
		private var listItems : Vector.<HierarchyUIListItem>;
		private var uiList : UIList;
		
		public function HierarchyPanel(_parent : TPMovieClip) {
			super(_parent, "Hierarchy", 300, 300);
			
			selectEvent = new CustomEvent();
			toggleExpandEvent = new CustomEvent();
			
			var listContainer : TPMovieClip = TPMovieClip.create(content, "listContainer");
			
			listItems = new Vector.<HierarchyUIListItem>();
			
			uiList = new UIList(listContainer, contentWidth, contentHeight);
		}
		
		private function onListItemSelectChild(_child : TPDisplayObject) : void {
			selectEvent.emit(_child);
		}
		
		private function onListItemToggleExpandChild(_child : TPDisplayObject) : void {
			toggleExpandEvent.emit(_child);
		}
		
		public function update(_childInfoList : Vector.<HierarchyChildInfo>) : void {
			if (isMinimized() == true) {
				uiList.hideItems();
				return;
			}
			
			var i : Number;
			
			for (i = 0; i < _childInfoList.length; i++) {				
				if (i >= listItems.length) {
					var container : TPMovieClip = uiList.getListItemsContainer();
					var width : Number = contentWidth - uiList.getScrollbarWidth();
					
					var listItem : HierarchyUIListItem = new HierarchyUIListItem(container, width, i);
					
					listItem.selectChildEvent.listen(this, onListItemSelectChild);
					listItem.toggleExpandChildEvent.listen(this, onListItemToggleExpandChild);
					
					listItems.push(listItem);
					uiList.addListItem(listItem);
				}
			}
			
			uiList.showItemsAtScrollPosition(_childInfoList.length);
			
			for (i = 0; i < _childInfoList.length; i++) {
				if (listItems[i].isVisible() == true) {
					listItems[i].update(_childInfoList[i].child, _childInfoList[i].depth, _childInfoList[i].childIndex, _childInfoList[i].isExpandable, _childInfoList[i].isExpanded);
				}
			}
		}
	}
}