package ui {
	
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
		
		public function update(_child : TPDisplayObject, _depth : Number, _childIndex : Number, _isExpandable : Boolean, _isExpanded : Boolean) : void {
			child = _child;
			depth = _depth;
			
			var prefix : String = "";
			
			for (var i : Number = 0; i < _depth; i++) {
				prefix += "  ";
			}
			
			if (_isExpandable == true && _isExpanded == true) {
				prefix += " v ";
			}
			if (_isExpandable == true && _isExpanded == false) {
				prefix += " > ";
			}
			if (_isExpandable == false) {
				prefix += "   ";
			}
			
			var name : String = HierarchyUtil.getChildIdentifier(_child.name, _depth, _childIndex);
			setPrimaryText(prefix + name);
			
			if (TPMovieClip.isMovieClip(_child.sourceDisplayObject) == false) {
				setSecondaryText("-/-");
			} else {
				var movieClip : MovieClip = TPMovieClip.asMovieClip(_child.sourceDisplayObject);
				var tpMovieClip : TPMovieClip = new TPMovieClip(movieClip);
				setSecondaryText(tpMovieClip.currentFrame + "/" + tpMovieClip.totalFrames);
			}
		}
	}
}