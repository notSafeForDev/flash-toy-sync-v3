package ui {
	
	import components.HierarchyChildInfo;
	import core.CustomEvent;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import states.AnimationPlaybackStates;
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
			
			HierarchyStates.listen(this, onHierachyInfoListStateChange, [HierarchyStates.hierarchyPanelInfoList]);
			AnimationPlaybackStates.listen(this, onAnimationPlaybackActiveChildStateChange, [AnimationPlaybackStates.activeChild]);
		}
		
		private function onListItemSelectChild(_child : TPDisplayObject) : void {
			selectEvent.emit(_child);
		}
		
		private function onListItemToggleExpandChild(_child : TPDisplayObject) : void {
			toggleExpandEvent.emit(_child);
		}
		
		private function onHierachyInfoListStateChange() : void {
			if (isMinimized() == true) {
				uiList.hideItems();
				return;
			}
			
			var infoList : Array = HierarchyStates.hierarchyPanelInfoList.value;
			
			var listItem : HierarchyUIListItem;
			var i : Number;
			
			for (i = 0; i < infoList.length; i++) {				
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
			
			uiList.showItemsAtScrollPosition(infoList.length);
			
			for (i = 0; i < infoList.length; i++) {
				listItem = listItems[i];
				if (listItem.isVisible() == true) {
					listItem.update(infoList[i]);
				}
			}
			
			highlightListItemForActiveChild();
		}
		
		private function onAnimationPlaybackActiveChildStateChange() : void {			
			highlightListItemForActiveChild();
		}
		
		private function highlightListItemForActiveChild() : void {
			var activeChild : TPMovieClip = AnimationPlaybackStates.activeChild.value;
			
			for (var i : Number = 0; i < listItems.length; i++) {
				if (activeChild != null && listItems[i].hasChild(activeChild) == true) {
					listItems[i].highlight();
				} else {
					listItems[i].clearHighlight();
				}
			}
		}
	}
}