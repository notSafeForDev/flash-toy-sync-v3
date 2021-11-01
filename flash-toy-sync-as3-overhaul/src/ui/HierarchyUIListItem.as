package ui {
	
	import components.HierarchyChildInfo;
	import core.CustomEvent;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import core.TPStage;
	import flash.display.MovieClip;
	import flash.geom.Point;
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
			
			if (localMousePosition.x < 20 + depth * 15) {
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
			child = _info.child;
			depth = _info.depth;
			
			var prefix : String = "";
			
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
			
			if (TPMovieClip.isMovieClip(_info.child.sourceDisplayObject) == false) {
				setSecondaryText("-/-");
			} else {
				var movieClip : MovieClip = TPMovieClip.asMovieClip(_info.child.sourceDisplayObject);
				var tpMovieClip : TPMovieClip = new TPMovieClip(movieClip);
				setSecondaryText(tpMovieClip.currentFrame + "/" + tpMovieClip.totalFrames);
			}
		}
	}
}