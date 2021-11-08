package controllers {
	
	import components.HierarchyChildInfo;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import states.AnimationInfoStates;
	import states.AnimationSceneStates;
	import states.EditorStates;
	import states.HierarchyStates;
	import states.ScriptTrackerStates;
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
		
		public function HierarchyPanelController(_hierarchyStates : HierarchyStates, _hierarchyPanel : HierarchyPanel) {
			hierarchyStates = _hierarchyStates;
			
			hierarchyPanel = _hierarchyPanel;
			hierarchyPanel.selectEvent.listen(this, onSelect);
			hierarchyPanel.toggleExpandEvent.listen(this, onToggleExpand);
			hierarchyPanel.toggleLockEvent.listen(this, onToggleLock);
			
			expandedChildren = new Vector.<DisplayObject>();
			
			ScriptTrackerStates.listen(this, onLastDraggedTrackerAttachedToStateChange, [ScriptTrackerStates.lastDraggedTrackerAttachedTo]);
		}
		
		public function update() : void {
			if (AnimationInfoStates.isLoaded.value == false || EditorStates.isEditor.value == false) {
				return;
			}
			
			var selectedChild : TPDisplayObject = HierarchyStates.selectedChild.value;
			if (selectedChild != null && selectedChild.isRemoved() == true) {
				hierarchyStates._selectedChild.setValue(null);
			}
			
			hierarchyStates._hierarchyPanelInfoList.setValue(getInfoForActiveChildren());
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
			var lockedChildren : Array = HierarchyStates.lockedChildren.value;
			if (ArrayUtil.includes(lockedChildren, _child.sourceDisplayObject) == false) {
				hierarchyStates._selectedChild.setValue(_child);
			}
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
		
		private function onToggleLock() : void {
			var lockedChildren : Array = HierarchyStates.lockedChildren.value;
			var selectedChild : TPDisplayObject = HierarchyStates.selectedChild.value;
			
			if (ArrayUtil.includes(lockedChildren, selectedChild.sourceDisplayObject) == true) {
				ArrayUtil.remove(lockedChildren, selectedChild.sourceDisplayObject);
			} else {
				lockedChildren.push(selectedChild.sourceDisplayObject);
			}
			
			hierarchyStates._lockedChildren.setValue(lockedChildren);
		}
		
		private function onLastDraggedTrackerAttachedToStateChange() : void {
			hierarchyStates._selectedChild.setValue(ScriptTrackerStates.lastDraggedTrackerAttachedTo.value);
		}
		
		private function getInfoForActiveChildren() : Array {
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var rootInfo : HierarchyChildInfo = createInitialChildInfo(root, 0, 0);
			
			var infoList : Array = [];
			var expandableChildren : Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var includedChildren : Vector.<DisplayObject> = new Vector.<DisplayObject>();
			
			infoList.push(rootInfo);
			
			TPMovieClip.iterateOverChildren(root.sourceMovieClip, this, getInfoForActiveChildrenIterator, [infoList, expandableChildren]);
			
			for (var i : Number = 0; i < infoList.length; i++) {
				var info : HierarchyChildInfo = infoList[i];
				var child : TPDisplayObject = info.child;
				
				var isParentExpanded : Boolean = ArrayUtil.includes(expandedChildren, child.parent);
				
				if (isParentExpanded == false && i > 0) {
					infoList.splice(i, 1);
					i--;
					continue;
				}
				
				includedChildren.push(child.sourceDisplayObject);
				
				var isChildExpandable : Boolean = (i == 0 && infoList.length > 1) || ArrayUtil.includes(expandableChildren, child.sourceDisplayObject);
				info.isExpandable = isChildExpandable;
			}
			
			includeChildInInfoList(AnimationSceneStates.activeChild.value, infoList, includedChildren);
			includeChildInInfoList(ScriptTrackerStates.baseTrackerAttachedTo.value, infoList, includedChildren);
			includeChildInInfoList(ScriptTrackerStates.stimTrackerAttachedTo.value, infoList, includedChildren);
			includeChildInInfoList(ScriptTrackerStates.tipTrackerAttachedTo.value, infoList, includedChildren);
			
			return infoList;
		}
		
		private function includeChildInInfoList(_child : TPDisplayObject, _infoList : Array, _includedChildren : Vector.<DisplayObject>) : void {
			if (_child == null || ArrayUtil.includes(_includedChildren, _child.sourceDisplayObject) == true) {
				return;
			}
			
			var parents : Vector.<DisplayObjectContainer> = TPDisplayObject.getParents(_child.sourceDisplayObject);
			var insertIndex : Number = -1;
			var insertDepth : Number = -1;
			var i : Number;
			
			for (i = 0; i < parents.length; i++) {
				insertIndex = ArrayUtil.indexOf(_includedChildren, parents[i]);
				if (insertIndex >= 0) {
					insertDepth = _infoList[insertIndex].depth;
					parents = parents.slice(0, i);
					break;
				}
			}
			
			if (insertIndex < 0) {
				return;
			}
			
			// The parents are originally ordered from direct parent, ending with the stage
			// So we reverse it so that it starts with the first parent to add
			parents.reverse();
			
			for (i = 0; i < parents.length; i++) {
				var parentInfo : HierarchyChildInfo = new HierarchyChildInfo();
				parentInfo.child = new TPDisplayObject(parents[i]);
				parentInfo.childIndex = TPDisplayObject.getChildIndex(parents[i]);
				parentInfo.depth = insertDepth + 1 + i;
				parentInfo.isExpandable = false;
				parentInfo.isExpanded = false;
				
				_infoList.splice(insertIndex + 1 + i, 0, parentInfo);
				_includedChildren.splice(insertIndex + 1 + i, 0, parents[i]);
			}
			
			var childInfo : HierarchyChildInfo = new HierarchyChildInfo();
			childInfo.child = _child;
			childInfo.childIndex = TPDisplayObject.getChildIndex(_child.sourceDisplayObject);
			childInfo.depth = insertDepth + parents.length + 1;
			childInfo.isExpandable = false;
			childInfo.isExpanded = false;
			
			_infoList.splice(insertIndex + 1 + parents.length, 0, childInfo);
			_includedChildren.splice(insertIndex + 1 + parents.length, 0, _child.sourceDisplayObject);
		}
		
		private function getInfoForActiveChildrenIterator(_child : MovieClip, _depth : Number, _childIndex : Number, _infoList : Array, _expandableChildren : Vector.<DisplayObject>) : Number {
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