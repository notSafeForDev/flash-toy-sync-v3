package ui {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	import core.CustomEvent;
	import core.Debug;
	import core.DisplayObjectUtil;
	import core.GraphicsUtil;
	import core.UIScrollArea;
	import core.ArrayUtil;
	import core.MovieClipUtil;

	import global.EditorState;
	import global.ScenesState;
	import global.GlobalEvents;

	import ui.Icons;

	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanel extends Panel {
		
		private var scrollBarWidth : Number = 10;
		private var toggleBarHeight : Number = 20;
		
		private var animationContainer : MovieClip;
		
		private var nestedChildren : Array = [];
		private var nestedChildrenDepths : Array = [];
		
		private var expandableChildren : Array = [];
		private var expandedChildren : Array = [];
		
		private var displayedChildren : Array = [];
		private var displayedChildrenDepths : Array = [];
		
		private var uiScrollArea : UIScrollArea;
		
		private var scrollContent : MovieClip;
		
		private var listItems : Array = [];
		
		public var excludeChildrenWithoutNestedAnimations : Boolean = true;
		
		public var onSelectChild : CustomEvent;
		public var onToggleMouseSelect : CustomEvent;
		
		public function HierarchyPanel(_parent : MovieClip, _animationContainer : MovieClip) {
			super(_parent, "Hierarchy", 250, 300);

			animationContainer = _animationContainer;
			
			onSelectChild = new CustomEvent();
			onToggleMouseSelect = new CustomEvent();
			
			var mouseSelectIcon : MovieClip = MovieClipUtil.create(content, "cursorLockIcon");
			DisplayObjectUtil.setX(mouseSelectIcon, toggleBarHeight / 2);
			DisplayObjectUtil.setY(mouseSelectIcon, toggleBarHeight / 2);
			GraphicsUtil.beginFill(mouseSelectIcon, 0xFFFFFF, 0.75);
			Icons.drawCursor(mouseSelectIcon, 14);
			Icons.drawStrikeThrough(mouseSelectIcon, 14);
			
			var scrollContainerHeight : Number = contentHeight - toggleBarHeight;
			
			var scrollContainer : MovieClip = MovieClipUtil.create(content, "scrollContainer");
			DisplayObjectUtil.setY(scrollContainer, toggleBarHeight);
			
			scrollContent = MovieClipUtil.create(scrollContainer, "scrollContent");
			
			var scrollBar : MovieClip = MovieClipUtil.create(scrollContainer, "scrollBar");
			GraphicsUtil.beginFill(scrollBar, 0xFFFFFF);
			GraphicsUtil.drawRect(scrollBar, contentWidth - scrollBarWidth, 0, scrollBarWidth, scrollBarWidth);
			
			var mask : MovieClip = MovieClipUtil.create(scrollContainer, "mask");
			GraphicsUtil.beginFill(mask, 0xFF0000, 0.5);
			GraphicsUtil.drawRect(mask, 0, 0, contentWidth - scrollBarWidth, scrollContainerHeight);
			
			uiScrollArea = new UIScrollArea(scrollContent, mask, scrollBar);
			uiScrollArea.handleAlphaWhenNotScrollable = 0.25;
			
			GlobalEvents.enterFrame.listen(this, onEnterFrame);
		}
		
		private function onEnterFrame() : void {
			update();
		}
		
		// Used to updated nestedChildren, which we use to determine which elements to display in the list
		private function nestedChildrenIterator(_child : MovieClip, _depth : Number) : Number {
			var parent : DisplayObject = DisplayObjectUtil.getParent(_child);
			var isParentExpanded : Boolean = ArrayUtil.indexOf(expandedChildren, parent) >= 0;
			var isParentExpandable : Boolean = ArrayUtil.indexOf(expandableChildren, parent) >= 0;
			
			// If the parent isn't expanded, but we know it is already epandable, no need to check the other siblings
			if (isParentExpanded == false && isParentExpandable == true) {
				return MovieClipUtil.ITERATE_SKIP_SIBLINGS;
			}
			
			var parentOfParent : DisplayObject = null;
			if (DisplayObjectUtil.isDisplayObject(DisplayObjectUtil.getParent(parent)) == true) {
				parentOfParent = DisplayObjectUtil.getParent(parent);
			}
			
			if (excludeChildrenWithoutNestedAnimations == true) {
				var totalFrames : Number = MovieClipUtil.getTotalFrames(_child);
				var hasNestedAnimations : Boolean = MovieClipUtil.hasNestedAnimations(_child);
				if (hasNestedAnimations == false && totalFrames == 1) {
					return MovieClipUtil.ITERATE_SKIP_NESTED;
				}
			}
			
			var shouldInclude : Boolean = isParentExpanded == true || (parentOfParent != null && ArrayUtil.indexOf(expandedChildren, parentOfParent) >= 0);
			shouldInclude = shouldInclude || parent == animationContainer;
			
			if (shouldInclude == true) {
				nestedChildren.push(_child);
				nestedChildrenDepths.push(_depth);
				if (isParentExpandable == false) {
					expandableChildren.push(parent);
				}
				return MovieClipUtil.ITERATE_CONTINUE;
			}
			
			return MovieClipUtil.ITERATE_SKIP_NESTED;
		}
		
		private function update() : void {
			nestedChildren.length = 0;
			nestedChildren.push(animationContainer);
			nestedChildrenDepths.length = 0;
			nestedChildrenDepths.push(0);
			
			expandableChildren.length = 0;
			
			displayedChildren.length = 0;
			displayedChildren.push(animationContainer);
			displayedChildrenDepths.length = 0;
			displayedChildrenDepths.push(0);
			
			var startTime : Number = Debug.getTime();
			var latestTime : Number = Debug.getTime();
			
			// This updates nestedChildren and nestedChildrenDepths
			MovieClipUtil.iterateOverChildren(animationContainer, nestedChildrenIterator, this);
			
			var elapsedTimeNestedChildren : Number = Debug.getTime() - latestTime;
			latestTime = Debug.getTime();
			
			var i : Number = 0;
			var child : DisplayObject;
			var parent : MovieClip;
			
			var elapsedTimeExcludedChildren : Number = Debug.getTime() - latestTime;
			latestTime = Debug.getTime();
			
			// Set the children to display in the list and update information used to determine if a child can be expanded or not
			for (i = 1; i < nestedChildren.length; i++) {
				parent = MovieClipUtil.getParent(nestedChildren[i]);
				if (ArrayUtil.indexOf(expandedChildren, parent) >= 0) {
					displayedChildren.push(nestedChildren[i]);
					displayedChildrenDepths.push(nestedChildrenDepths[i]);
				}
			}
			
			var elapsedTimeDisplayedChildren : Number = Debug.getTime() - latestTime;
			latestTime = Debug.getTime();
			
			// Add the clickedChild and it's parents to the list of displayed children
			if (EditorState.clickedChild.value != null) {
				addChildToDisplay(EditorState.clickedChild.value);
			}
			
			// Add the selectedChild and it's parents to the list of displayed children
			if (ScenesState.selectedChild.value != null) {
				addChildToDisplay(ScenesState.selectedChild.value);
			}
			
			var disabledMouseSelectForChildren : Array = EditorState.mouseSelectDisabledForChildren.value;
			
			// Add the elements with disabled mouse select, so that the user always can enable them again, just incase
			for (i = 0; i < disabledMouseSelectForChildren.length; i++) {
				// Checking this to reduce the number of ArrayUtil.indexOf calls
				if (disabledMouseSelectForChildren[i] != EditorState.clickedChild.value) {
					addChildToDisplay(disabledMouseSelectForChildren[i]);
				}
			}
			
			// Update list items
			for (i = 0; i < displayedChildren.length; i++) {
				child = displayedChildren[i];
				
				var listItem : HierarchyPanelListItem;
				
				if (i >= listItems.length) {
					listItem = new HierarchyPanelListItem(scrollContent, i, contentWidth - scrollBarWidth);
					listItem.onSelect.listen(this, onListItemSelect);
					listItem.onExpand.listen(this, onListItemExpand);
					listItem.onToggleMouseSelect.listen(this, onListItemToggleMouseSelect);
					listItems.push(listItem);
				} else {
					listItem = listItems[i];
					listItem.setVisible(true);
				}
				
				var isVisible : Boolean = uiScrollArea.isElementVisible(listItem.background);
				
				if (isVisible == true) {
					var depth : Number = displayedChildrenDepths[i];
					var isExpandable : Boolean = ArrayUtil.indexOf(expandableChildren, child) >= 0;
					var isExpanded : Boolean = ArrayUtil.indexOf(expandedChildren, child) >= 0;
					var isMouseSelectEnabled : Boolean = ArrayUtil.indexOf(disabledMouseSelectForChildren, child) < 0;
					
					listItem.setVisible(true);
					listItem.setHighlighted(ScenesState.selectedChild.value == child);
					listItem.setIsClickedChild(EditorState.clickedChild.value == child);
					listItem.setMouseSelectEnabled(isMouseSelectEnabled);
					listItem.update(child, depth, isExpandable, isExpanded);
				}
			}
			
			// Hide list items that are not needed
			for (i = displayedChildren.length; i < listItems.length; i++) {
				listItems[i].setVisible(false);
			}
			
			var elapsedTimeUpdateList : Number = Debug.getTime() - latestTime;
			var endTime : Number = Debug.getTime();
			
			/* if (Math.random() < 0.2) {
				trace(
					"Hierarchy Total: " + (endTime - startTime).toString() + 
					", Nested: " + (elapsedTimeNestedChildren).toString() + 
					", Excluded: " + (elapsedTimeExcludedChildren).toString() +
					", Displayed: " + (elapsedTimeDisplayedChildren).toString() +
					", List: " + (elapsedTimeUpdateList).toString()
				);
			} */
		}
		
		private function addChildToDisplay(_child : DisplayObject) : void {
			if (_child == null || ArrayUtil.indexOf(displayedChildren, _child) >= 0) {
				return;
			}
			
			var insertIndex : Number = -1; // At what index of the displayed children we should start inserting the child's parent
			var parents : Array = DisplayObjectUtil.getParents(_child);
			var rootIndex : Number = ArrayUtil.indexOf(parents, animationContainer);
			var childDepth : Number = rootIndex + 1; // The number of parents up to and including the animationContainer
			var i : Number;
			
			for (i = 0; i < parents.length; i++) {
				insertIndex = ArrayUtil.indexOf(displayedChildren, parents[i]);
				if (insertIndex >= 0) {
					parents = parents.slice(0, i);
					break;
				}
			}
			
			if (insertIndex >= 0) {
				// The parents are originally ordered from direct parent, ending with the animationContainer
				// So we reverse it so that it starts with the first parent to add
				parents.reverse();
				
				var startDepth : Number = childDepth - parents.length; // How deep nested the first parent is
				var childrenToAdd : Array = parents.slice(); // All parents including the child itself
				childrenToAdd.push(_child);
				
				for (i = 0; i < childrenToAdd.length; i++) {
					var index : Number = insertIndex + 1 + i;
					displayedChildren.splice(index, 0, childrenToAdd[i]);
					displayedChildrenDepths.splice(index, 0, startDepth + i);
				}
			}
		}
		
		private function onListItemSelect(_index : Number) : void {
			if (MovieClipUtil.isMovieClip(displayedChildren[_index]) == true) {
				onSelectChild.emit(displayedChildren[_index]);
			}
		}
		
		private function onListItemExpand(_index : Number) : void {
			var child : MovieClip = displayedChildren[_index];
			if (ArrayUtil.indexOf(expandedChildren, child) < 0) {
				expandedChildren.push(child);
				return;
			}
			
			ArrayUtil.remove(expandedChildren, child);
			for (var i : Number = 0; i < expandedChildren.length; i++) {
				var otherExpandedChild : MovieClip = expandedChildren[i];
				var parents : Array = MovieClipUtil.getParents(otherExpandedChild);
				var index : Number = ArrayUtil.indexOf(parents, child);
				if (index >= 0) {
					ArrayUtil.remove(expandedChildren, otherExpandedChild);
					i--;
				}
			}
		}
		
		private function onListItemToggleMouseSelect(_index : Number) : void {
			if (MovieClipUtil.isMovieClip(displayedChildren[_index]) == true) {
				var child : MovieClip = displayedChildren[_index];
				onToggleMouseSelect.emit(child);
			}
		}
	}
}