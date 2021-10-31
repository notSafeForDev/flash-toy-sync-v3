package ui {
	
	import components.HierarchyChildInfo;
	import core.CustomEvent;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import states.HierarchyStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanel extends Panel {
		
		public var selectEvent : CustomEvent;
		public var toggleExpandEvent : CustomEvent;
		
		private var listItems : Vector.<HierarchyUIListItem>;
		private var uiList : UIList;
		
		public function HierarchyPanel(_parent : TPMovieClip, _contentWidth : Number, _contentHeight : Number) {
			super(_parent, "Hierarchy", _contentWidth, _contentHeight);
			
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
			var listItem : HierarchyUIListItem;
			
			for (i = 0; i < _childInfoList.length; i++) {				
				if (i >= listItems.length) {
					var container : TPMovieClip = uiList.getListItemsContainer();
					var width : Number = contentWidth - uiList.getScrollbarWidth();
					
					listItem = new HierarchyUIListItem(container, width, i);
					
					listItem.selectChildEvent.listen(this, onListItemSelectChild);
					listItem.toggleExpandChildEvent.listen(this, onListItemToggleExpandChild);
					
					listItems.push(listItem);
					uiList.addListItem(listItem);
				}
			}
			
			uiList.showItemsAtScrollPosition(_childInfoList.length);
			
			var selectedHierarchyChild : DisplayObject = null;
			if (HierarchyStates.selectedChild.value != null) {
				selectedHierarchyChild = HierarchyStates.selectedChild.value.sourceDisplayObject;
			}
			
			for (i = 0; i < _childInfoList.length; i++) {
				listItem = listItems[i];
				if (listItem.isVisible() == false) {
					continue;
				}
				
				listItem.update(_childInfoList[i].child, _childInfoList[i].depth, _childInfoList[i].childIndex, _childInfoList[i].isExpandable, _childInfoList[i].isExpanded);
				if (_childInfoList[i].child.sourceDisplayObject == selectedHierarchyChild) {
					listItem.highlight();
				} else {
					listItem.clearHighlight();
				}
			}
		}
	}
}