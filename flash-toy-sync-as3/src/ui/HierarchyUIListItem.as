package ui {
	
	import components.HierarchyChildInfo;
	import core.CustomEvent;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import core.TPStage;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import states.HierarchyStates;
	import states.ScriptTrackerStates;
	import utils.ArrayUtil;
	import utils.HierarchyUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyUIListItem extends UIListItem {
		
		public var toggleExpandChildEvent : CustomEvent;
		public var selectChildEvent : CustomEvent;
		
		private var child : TPDisplayObject;
		private var depth : Number;
		
		public function HierarchyUIListItem(_parent : TPMovieClip, _width : Number, _index : Number) {
			super(_parent, _width, _index);
			
			selectChildEvent = new CustomEvent();
			toggleExpandChildEvent = new CustomEvent();
		}
		
		protected override function onMouseDown() : void {
			var localMousePosition : Point = background.globalToLocal(new Point(TPStage.mouseX, TPStage.mouseY));
			
			if (localMousePosition.x < 25 + depth * 15) {
				toggleExpandChildEvent.emit(child);
			} else {
				selectChildEvent.emit(child);
			}
			
			super.onMouseDown();
		}
		
		public function hasChild(_child : TPDisplayObject) : Boolean {
			return child.sourceDisplayObject == _child.sourceDisplayObject;
		}
		
		public function update(_info: HierarchyChildInfo) : void {
			if (_info == null || _info.child == null) {
				throw new Error("Unable to update hierarchy list item, the info is not valid");
			}
			
			child = _info.child;
			depth = _info.depth;
			
			updateBackgroundGraphics();
			
			var prefix : String = " ";
			
			for (var i : Number = 0; i < _info.depth; i++) {
				prefix += "  ";
			}
			
			if (_info.isExpandable == true && _info.isExpanded == true) {
				prefix += " v ";
			}
			if (_info.isExpandable == true && _info.isExpanded == false) {
				prefix += " > ";
			}
			if (_info.isExpandable == false) {
				prefix += "   ";
			}
			
			var name : String = HierarchyUtil.getChildIdentifier(_info.child.name, _info.depth, _info.childIndex);
			setPrimaryText(prefix + name);
			
			var lockedChildren : Array = HierarchyStates.lockedChildren.value;
			if (ArrayUtil.includes(lockedChildren, child.sourceDisplayObject) == true) {
				setSecondaryText("");
				return;
			}
			
			if (TPMovieClip.isMovieClip(_info.child.sourceDisplayObject) == false) {
				setSecondaryText("-/-");
			} else {
				var movieClip : MovieClip = TPMovieClip.asMovieClip(_info.child.sourceDisplayObject);
				var tpMovieClip : TPMovieClip = new TPMovieClip(movieClip);
				setSecondaryText(tpMovieClip.currentFrame + "/" + tpMovieClip.totalFrames);
			}
		}
		
		protected override function updateBackgroundGraphics() : void {
			super.updateBackgroundGraphics();
			
			if (child == null) {
				return;
			}
			
			if (HierarchyStates.selectedChild.value != null && child.sourceDisplayObject == HierarchyStates.selectedChild.value.sourceDisplayObject) {
				background.graphics.beginFill(0xFFFFFF);
				Icons.drawListItemSelectionIcon(background.graphics, 6, 5, 6, 10);
			}
			
			var baseTrackerAttachedTo : TPDisplayObject = ScriptTrackerStates.baseTrackerAttachedTo.value;
			var stimTrackerAttachedTo : TPDisplayObject = ScriptTrackerStates.stimTrackerAttachedTo.value;
			var tipTrackerAttachedTo : TPDisplayObject = ScriptTrackerStates.tipTrackerAttachedTo.value;
			
			if (baseTrackerAttachedTo != null && child.sourceDisplayObject == baseTrackerAttachedTo.sourceDisplayObject) {
				drawChildSelectionIndicator(Colors.baseMarker, 0);
			}
			if (stimTrackerAttachedTo != null && child.sourceDisplayObject == stimTrackerAttachedTo.sourceDisplayObject) {
				drawChildSelectionIndicator(Colors.stimMarker, 1);
			}
			if (tipTrackerAttachedTo != null && child.sourceDisplayObject == tipTrackerAttachedTo.sourceDisplayObject) {
				drawChildSelectionIndicator(Colors.tipMarker, 2);
			}
			
			var lockedChildren : Array = HierarchyStates.lockedChildren.value;
			if (ArrayUtil.includes(lockedChildren, child.sourceDisplayObject) == false) {
				return;
			}
			
			background.graphics.beginFill(0xFFFFFF, 0.5);
			Icons.drawLockIcon(background.graphics, width - 16, 4, 12, 12);
		}
		
		private function drawChildSelectionIndicator(_color : Number, _index : Number) : void {
			background.graphics.beginFill(_color);
			background.graphics.drawRect(1, 1 + _index * 6, 3, 6);
			background.graphics.endFill();
		}
	}
}