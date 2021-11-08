package ui {
	
	import components.HierarchyChildInfo;
	import core.CustomEvent;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import states.AnimationSceneStates;
	import states.EditorStates;
	import states.HierarchyStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanel extends Panel {
		
		public var selectEvent : CustomEvent;
		public var toggleExpandEvent : CustomEvent;
		public var toggleLockEvent : CustomEvent;
		
		private var listItems : Vector.<HierarchyUIListItem>;
		private var uiList : UIList;
		
		private var lockButton : UIButton;
		
		public function HierarchyPanel(_parent : TPMovieClip, _contentWidth : Number, _contentHeight : Number) {
			super(_parent, "Hierarchy", _contentWidth, _contentHeight);
			
			selectEvent = new CustomEvent();
			toggleExpandEvent = new CustomEvent();
			toggleLockEvent = new CustomEvent();
			
			var iconsBarHeight : Number = 20;
			var listHeight : Number = _contentHeight - iconsBarHeight;
			
			var listContainer : TPMovieClip = TPMovieClip.create(content, "listContainer");
			
			listItems = new Vector.<HierarchyUIListItem>();
			
			uiList = new UIList(listContainer, contentWidth, listHeight);
			
			var iconsBar : TPMovieClip = TPMovieClip.create(content, "iconsBar");
			iconsBar.graphics.beginFill(0x000000, 0.25);
			iconsBar.graphics.drawRect(0, 0, contentWidth, iconsBarHeight);
			
			iconsBar.graphics.lineStyle(1, 0xFFFFFF, 0.1);
			iconsBar.graphics.moveTo(0, 0);
			iconsBar.graphics.lineTo(contentWidth, 0);
			
			iconsBar.y = listHeight;
			
			var lockButtonElement : TPMovieClip = TPMovieClip.create(iconsBar, "lockButtonElement");
			lockButton = new UIButton(lockButtonElement);
			lockButton.mouseClickEvent.listen(this, onLockButtonClick);
			
			lockButtonElement.graphics.beginFill(0xFFFFFF, 0);
			lockButtonElement.graphics.drawRect(0, 0, 20, 20);
			
			lockButtonElement.graphics.beginFill(0xFFFFFF);
			Icons.drawLockIcon(lockButtonElement.graphics, 4, 4, 12, 12);
			/* Icons.drawLockBody(lockButtonElement.graphics, 4, 4, 12, 12);
			
			lockButtonElement.graphics.lineStyle(2, 0xFFFFFF);
			lockButtonElement.graphics.beginFill(0xFFFFFF, 0);
			Icons.drawLockShackle(lockButtonElement.graphics, 4, 4, 12, 12);
			
			lockButtonElement.graphics.beginFill(0x000000);
			Icons.drawLockKeyHole(lockButtonElement.graphics, 4, 4, 12, 12); */
			
			HierarchyStates.listen(this, onSelectedHierarchyChildStateChange, [HierarchyStates.selectedChild]);
			HierarchyStates.listen(this, onHierachyInfoListStateChange, [HierarchyStates.hierarchyPanelInfoList]);
			AnimationSceneStates.listen(this, onAnimationSceneActiveChildStateChange, [AnimationSceneStates.activeChild]);
		}
		
		private function onListItemSelectChild(_child : TPDisplayObject) : void {
			selectEvent.emit(_child);
		}
		
		private function onListItemToggleExpandChild(_child : TPDisplayObject) : void {
			toggleExpandEvent.emit(_child);
		}
		
		private function onSelectedHierarchyChildStateChange() : void {
			if (HierarchyStates.selectedChild.value == null) {
				lockButton.disable();
			} else {
				lockButton.enable();
			}
		}
		
		private function onHierachyInfoListStateChange() : void {
			if (isMinimized() == true || EditorStates.isEditor.value == false) {
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
		
		private function onLockButtonClick() : void {
			toggleLockEvent.emit();
		}
		
		private function onAnimationSceneActiveChildStateChange() : void {
			if (EditorStates.isEditor.value == false) {
				return;
			}
			
			highlightListItemForActiveChild();
		}
		
		private function highlightListItemForActiveChild() : void {
			if (EditorStates.isEditor.value == false) {
				return;
			}
			
			var activeChild : TPMovieClip = AnimationSceneStates.activeChild.value;
			
			for (var i : Number = 0; i < listItems.length; i++) {
				if (listItems[i].isVisible() == false) {
					continue;
				}
				if (activeChild != null && listItems[i].hasChild(activeChild) == true) {
					listItems[i].highlight();
				} else {
					listItems[i].clearHighlight();
				}
			}
		}
	}
}