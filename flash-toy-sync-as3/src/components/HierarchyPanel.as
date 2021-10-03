package components {
	
	import core.Debug;
	import core.DisplayObjectUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import core.ArrayUtil;
	import core.MovieClipUtil;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanel {
		
		private var base : Panel;
		
		private var panelWidth : Number = 200;
		private var panelHeight : Number = 400;
		
		private var animationContainer : MovieClip;
		
		private var nestedChildren : Array = [];
		private var nestedChildrenDepths : Array = [];
		
		private var expandedChildren : Array = [];
		
		private var displayedChildren : Array = [];
		private var displayedChildrenDepths : Array = [];
		
		private var listItems : Array = [];
		
		public var excludeChildrenWithoutNestedAnimations : Boolean = true;
		
		public function HierarchyPanel(_parent : MovieClip, _animationContainer : MovieClip) {
			base = new Panel(_parent, "Hierarchy", panelWidth, panelHeight);
			animationContainer = _animationContainer;
		}
		
		// Used to updated nestedChildren, which we use to determine which elements to display in the list
		private function nestedChildrenIterator(_child : MovieClip, _depth : Number) : Number {
			var parent : DisplayObject = DisplayObjectUtil.getParent(_child);
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
			
			var shouldInclude : Boolean = ArrayUtil.indexOf(expandedChildren, parent) >= 0 || (parentOfParent != null && ArrayUtil.indexOf(expandedChildren, parentOfParent) >= 0);
			
			if (shouldInclude == true) {
				nestedChildren.push(_child);
				nestedChildrenDepths.push(_depth);
				return MovieClipUtil.ITERATE_CONTINUE;
			}
			
			return MovieClipUtil.ITERATE_SKIP_NESTED;
		}
		
		public function update() : void {
			var startTime : Number = Debug.getTime();
			var latestTime : Number = Debug.getTime();
			
			nestedChildren.length = 0;
			nestedChildrenDepths.length = 0;
			
			displayedChildren.length = 0;
			displayedChildren.push(animationContainer);
			displayedChildrenDepths.length = 0;
			displayedChildrenDepths.push(0);
			
			// This updates nestedChildren and nestedChildrenDepths
			MovieClipUtil.iterateOverChildren(animationContainer, nestedChildrenIterator, this);
			
			var elapsedTimeNestedChildren : Number = Debug.getTime() - latestTime;
			latestTime = Debug.getTime();
			
			var i : Number = 0;
			var child : MovieClip;
			var parent : MovieClip;
			
			// Each index of this array corresponds to each nested child, with each value corresponding to the number of children it has
			// We use this to determine if a list item should be expandable
			var parentsChildCounts : Array = [];
			
			var elapsedTimeExcludedChildren : Number = Debug.getTime() - latestTime;
			latestTime = Debug.getTime();
			
			// Set the children to display in the list and update information used to determine if a child can be expanded or not
			for (i = 0; i < nestedChildren.length; i++) {
				parentsChildCounts.push(0);
				parent = MovieClipUtil.getParent(nestedChildren[i]);
				var parentIndex : Number = ArrayUtil.indexOf(nestedChildren, parent);
				if (parentIndex >= 0) {
					parentsChildCounts[parentIndex] = parentsChildCounts[parentIndex] + 1;
				}
				
				if (ArrayUtil.indexOf(expandedChildren, parent) >= 0) {
					displayedChildren.push(nestedChildren[i]);
					displayedChildrenDepths.push(nestedChildrenDepths[i]);
				}
			}
			
			var elapsedTimeDisplayedChildren : Number = Debug.getTime() - latestTime;
			latestTime = Debug.getTime();
			
			// Update list items
			for (i = 0; i < displayedChildren.length; i++) {
				child = displayedChildren[i];
				
				var depth : Number = displayedChildrenDepths[i];
				var nestedChildIndex : Number = ArrayUtil.indexOf(nestedChildren, child);
				var childCount : Number = parentsChildCounts[nestedChildIndex];
				var isExpandable : Boolean = childCount > 0 || i == 0;
				var isExpanded : Boolean = ArrayUtil.indexOf(expandedChildren, child) >= 0
				
				updateListItem(child, depth, i, isExpandable, isExpanded);
			}
			
			// Hide list items that are not needed
			for (i = displayedChildren.length; i < listItems.length; i++) {
				listItems[i].setVisible(false);
			}
			
			var elapsedTimeUpdateList : Number = Debug.getTime() - latestTime;
			var endTime : Number = Debug.getTime();
			
			/* trace(
				"Hierarchy Total: " + (endTime - startTime).toString() + 
				", Nested: " + (elapsedTimeNestedChildren).toString() + 
				", Excluded: " + (elapsedTimeExcludedChildren).toString() +
				", Displayed: " + (elapsedTimeDisplayedChildren).toString() +
				", List: " + (elapsedTimeUpdateList).toString()
			); */
		}
		
		private function updateListItem(_child : MovieClip, _childDepth : Number, _listIndex : Number, _isExpandable : Boolean, _isExpanded : Boolean) : void {
			var listItem : HierarchyPanelListItem;
			
			if (listItems.length <= _listIndex) {
				listItem = new HierarchyPanelListItem(base.content, _listIndex, panelWidth);
				listItem.onMouseDown.listen(this, onListItemMouseDown);
				listItems.push(listItem);
			} else {
				listItem = listItems[_listIndex]
			}
			
			listItem.setVisible(true);
			
			listItem.update(_child, _childDepth, _isExpandable, _isExpanded);
		}
		
		private function onListItemMouseDown(_index : Number) : void {
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
	}
}