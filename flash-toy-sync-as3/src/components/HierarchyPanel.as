package components {
	
	import flash.display.MovieClip;
	
	import core.ArrayUtil;
	import core.MovieClipUtil;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanel {
		
		private var panelWidth : Number = 200;
		private var panelHeight : Number = 400;
		
		private var base : Panel;
		private var animationContainer : MovieClip;
		private var expandedChildren : Array = [];
		private var displayedChildren : Array = [];
		private var listItems : Array = [];
		
		public var excludeChildrenWithoutNestedAnimations : Boolean = true;
		
		public function HierarchyPanel(_parent : MovieClip, _animationContainer : MovieClip) {
			base = new Panel(_parent, "Hierarchy", panelWidth, panelHeight);
			animationContainer = _animationContainer;
		}
		
		public function update() : void {
			displayedChildren.length = 0;
			displayedChildren.push(animationContainer);
			
			var nestedChildren : Array = MovieClipUtil.getNestedChildren(animationContainer);
			var i : Number = 0;
			var child : MovieClip;
			var parent : MovieClip;
			
			// Each index of this array corresponds to each nested child, with each value corresponding to the number of children it has
			// We use this to determine if a list item should be expandable
			var parentsChildCounts : Array = [];
			
			if (excludeChildrenWithoutNestedAnimations == true) {
				var validChildren : Array = [];
				
				for (i = 0; i < nestedChildren.length; i++) {
					var hasNestedAnimations : Boolean = MovieClipUtil.hasNestedAnimations(nestedChildren[i]);
					if (hasNestedAnimations == true) {
						validChildren.push(nestedChildren[i]);
					}
				}
				
				nestedChildren = validChildren;
			}
			
			for (i = 0; i < nestedChildren.length; i++) {
				parentsChildCounts.push(0);
				parent = MovieClipUtil.getParent(nestedChildren[i]);
				var parentIndex : Number = ArrayUtil.indexOf(nestedChildren, parent);
				if (parentIndex >= 0) {
					parentsChildCounts[parentIndex] = parentsChildCounts[parentIndex] + 1;
				}
				
				if (ArrayUtil.indexOf(expandedChildren, parent) >= 0) {
					displayedChildren.push(nestedChildren[i]);
				}
			}
			
			for (i = 0; i < displayedChildren.length; i++) {
				child = displayedChildren[i];
				var nestedChildIndex : Number = ArrayUtil.indexOf(nestedChildren, child);
				var childCount : Number = parentsChildCounts[nestedChildIndex];
				var isExpandable : Boolean = childCount > 0 || i == 0;
				
				updateListItem(child, isExpandable, i);
			}
			
			for (i = displayedChildren.length; i < listItems.length; i++) {
				listItems[i].setVisible(false);
			}
		}
		
		private function updateListItem(_child : MovieClip, _isExpandable : Boolean, _index : Number) : void {
			var listItem : HierarchyPanelListItem;
			
			if (listItems.length <= _index) {
				listItem = new HierarchyPanelListItem(base.content, _index, panelWidth);
				listItem.onMouseDown.listen(this, onListItemMouseDown);
				listItems.push(listItem);
			} else {
				listItem = listItems[_index]
			}
			
			listItem.setVisible(true);
			
			var path : Array = MovieClipUtil.getChildPath(animationContainer, _child);
			var name : String = "";
			
			for (var i : Number = 0; i < path.length; i++) {
				name += "   ";
			}
			
			if (_isExpandable == true) {
				if (ArrayUtil.indexOf(expandedChildren, _child) >= 0) {
					name += "v ";
				} else {
					name += "> ";
				}
			} else {
				name += "  ";
			}
			
			name += path.length > 0 ? path[path.length - 1] : "root";
			
			listItem.setText(name);
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