package controllers {
	
	import components.HierarchyChildInfo;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import states.AnimationInfoStates;
	import states.HierarchyStates;
	import ui.HierarchyPanel;
	import utils.ArrayUtil;
	import utils.HierarchyUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanelController {
		
		private var hierarchyStates : HierarchyStates;
		
		private var hierarchyPanel : HierarchyPanel;
		
		private var expandedChildren : Vector.<DisplayObject>;
		
		private var selectedChildPath : Vector.<String> = null;
		private var selectedChildParentChainLength : Number = -1;
		
		public function HierarchyPanelController(_hierarchyStates : HierarchyStates, _hierarchyPanel : HierarchyPanel) {
			hierarchyStates = _hierarchyStates;
			
			hierarchyPanel = _hierarchyPanel;
			hierarchyPanel.toggleExpandEvent.listen(this, onToggleExpand);
			hierarchyPanel.selectEvent.listen(this, onSelect);
			
			expandedChildren = new Vector.<DisplayObject>();
		}
		
		public function update() : void {
			if (AnimationInfoStates.isLoaded.value == false) {
				return;
			}
			
			var currentSelectedChild : TPMovieClip = HierarchyStates.selectedChild.value;
			
			if (currentSelectedChild != null) {
				var parents : Vector.<DisplayObjectContainer> = TPDisplayObject.getParents(currentSelectedChild.sourceMovieClip);
				if (parents.length != selectedChildParentChainLength) {
					currentSelectedChild = null;
				}
			}
			
			if (currentSelectedChild == null && selectedChildPath != null) {
				var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
				var childFromPath : TPMovieClip = HierarchyUtil.getMovieClipFromPath(root, selectedChildPath);
				currentSelectedChild = childFromPath;
			}
			
			// It's important that we don't update the state twice here,
			// due to the playback controller listening to this state
			hierarchyStates._selectedChild.setValue(currentSelectedChild);
			
			hierarchyPanel.update(getInfoForActiveChildren());
		}
		
		private function createInitialChildInfo(_tpDisplayObject : TPDisplayObject, _depth : Number, _childIndex : Number) : HierarchyChildInfo {
			var info : HierarchyChildInfo = new HierarchyChildInfo();
			info.child = _tpDisplayObject;
			info.depth = _depth;
			info.childIndex = _childIndex;
			info.isExpandable = false;
			info.isExpanded = ArrayUtil.includes(expandedChildren, _tpDisplayObject.sourceDisplayObject);
			
			return info;
		}
		
		private function onSelect(_child : TPDisplayObject) : void {
			if (TPMovieClip.isMovieClip(_child.sourceDisplayObject) == false) {
				return;
			}
			
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var path : Vector.<String> = HierarchyUtil.getChildPath(root, _child);
			var movieClip : MovieClip = TPMovieClip.asMovieClip(_child.sourceDisplayObject);
			var tpMovieClip : TPMovieClip = new TPMovieClip(movieClip);
			var parents : Vector.<DisplayObjectContainer> = TPDisplayObject.getParents(movieClip);
			
			hierarchyStates._selectedChild.setValue(tpMovieClip);
			
			selectedChildParentChainLength = parents.length;
			selectedChildPath = path;
		}
		
		private function onToggleExpand(_child : TPDisplayObject) : void {
			var index : Number = ArrayUtil.indexOf(expandedChildren, _child.sourceDisplayObject);
			
			var didExpand : Boolean = index < 0;
			if (didExpand == true) {
				expandedChildren.push(_child.sourceDisplayObject);
				return;
			}
			
			expandedChildren.splice(index, 1);
			
			for (var i : Number = 0; i < expandedChildren.length; i++) {
				var parents : Vector.<DisplayObjectContainer> = TPDisplayObject.getParents(expandedChildren[i]);
				index = ArrayUtil.indexOf(parents, _child.sourceDisplayObject);
				if (index >= 0) {
					expandedChildren.splice(i, 1);
					i--;
				}
			}
		}
		
		private function getInfoForActiveChildren() : Vector.<HierarchyChildInfo> {
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var rootInfo : HierarchyChildInfo = createInitialChildInfo(root, 0, 0);
			
			var infoList : Vector.<HierarchyChildInfo> = new Vector.<HierarchyChildInfo>();
			var expandableChildren : Vector.<DisplayObject> = new Vector.<DisplayObject>();
			
			infoList.push(rootInfo);
			
			TPMovieClip.iterateOverChildren(root.sourceMovieClip, this, getInfoForActiveChildrenIterator, [infoList, expandableChildren]);
			
			for (var i : Number = 0; i < infoList.length; i++) {
				var child : TPDisplayObject = infoList[i].child;
				
				var isParentExpanded : Boolean = ArrayUtil.includes(expandedChildren, child.parent);
				
				if (isParentExpanded == false && i > 0) {
					infoList.splice(i, 1);
					i--;
					continue;
				}
				
				var isChildExpandable : Boolean = (i == 0 && infoList.length > 1) || ArrayUtil.includes(expandableChildren, child.sourceDisplayObject);
				infoList[i].isExpandable = isChildExpandable;
			}
			
			return infoList;
		}
		
		private function getInfoForActiveChildrenIterator(_child : MovieClip, _depth : Number, _childIndex : Number, _infoList : Vector.<HierarchyChildInfo>, _expandableChildren : Vector.<DisplayObject>) : Number {
			var tpMovieClip : TPMovieClip = new TPMovieClip(_child);
			
			var parent : DisplayObjectContainer = tpMovieClip.parent;
			var isParentMarkedAsExpandable : Boolean = ArrayUtil.includes(_expandableChildren, parent);
			var isParentExpanded : Boolean = ArrayUtil.includes(expandedChildren, parent);
			
			if (isParentMarkedAsExpandable == true && isParentExpanded == false) {
				return TPMovieClip.ITERATE_SKIP_SIBLINGS;
			}
			
			var hasNestedAnimations : Boolean = TPMovieClip.hasNestedAnimations(_child);
			if (hasNestedAnimations == false && tpMovieClip.totalFrames == 1) {
				return TPMovieClip.ITERATE_SKIP_NESTED;
			}
			
			if (isParentExpanded == true || isParentMarkedAsExpandable == false) {
				if (isParentMarkedAsExpandable == false) {
					_expandableChildren.push(parent);
				}
				
				_infoList.push(createInitialChildInfo(tpMovieClip, _depth, _childIndex));
			}
			
			return TPMovieClip.ITERATE_CONTINUE;
		}
	}
}