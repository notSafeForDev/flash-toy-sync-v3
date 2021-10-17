package ui {
	
	import ui.Icons;
	import ui.TextStyles;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;

	import core.CustomEvent;
	import core.DisplayObjectUtil;
	import core.Fonts;
	import core.GraphicsUtil;
	import core.MouseEvents;
	import core.MovieClipUtil;
	import core.StageUtil;
	import core.TextElement;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanelListItem {
		
		private var index : Number;
		private var child : DisplayObject;
		private var depth : Number;
		
		private var width : Number;
		private var height : Number = 20;
		private var toggleIconWidth : Number = 20;
		
		private var isExpandable : Boolean = false;
		private var isExpanded : Boolean = false;
		private var isMouseSelectEnabled : Boolean = true;
		private var isMouseOver : Boolean = false;
		
		private var nameText : TextElement;
		private var framesText : TextElement;
		
		private var clickedChildIcon : MovieClip;
		private var mouseSelectableIcon : MovieClip;
		
		public var background : MovieClip;
		
		public var onSelect : CustomEvent;
		public var onExpand : CustomEvent;
		public var onToggleMouseSelect : CustomEvent;
		
		public function HierarchyPanelListItem(_parent : MovieClip, _index : Number, _width : Number) {
			index = _index;
			width = _width;
			
			onSelect = new CustomEvent();
			onExpand = new CustomEvent();
			onToggleMouseSelect = new CustomEvent();
			
			background = MovieClipUtil.create(_parent, "background" + _index);
			background.buttonMode = true;
			
			clickedChildIcon = MovieClipUtil.create(background, "disableClickIcon");
			DisplayObjectUtil.setX(clickedChildIcon, width - 40);
			DisplayObjectUtil.setY(clickedChildIcon, height / 2);
			GraphicsUtil.beginFill(clickedChildIcon, 0xFFFFFF, 0.5);
			GraphicsUtil.drawCircle(clickedChildIcon, 0, 0, 4);
			
			mouseSelectableIcon = MovieClipUtil.create(background, "mouseSelectableIcon");
			DisplayObjectUtil.setX(mouseSelectableIcon, 10);
			DisplayObjectUtil.setY(mouseSelectableIcon, 10);
			DisplayObjectUtil.setAlpha(mouseSelectableIcon, 0);
			GraphicsUtil.beginFill(mouseSelectableIcon, 0xFFFFFF);
			Icons.drawCursor(mouseSelectableIcon, 12);
			Icons.drawStrikeThrough(mouseSelectableIcon, 12);
			
			nameText = new TextElement(background, "PLACEHOLDER");
			nameText.setWidth(_width);
			nameText.setBold(true);
			nameText.setMouseEnabled(false);
			nameText.setX(toggleIconWidth * 2);
			TextStyles.applyListItemStyle(nameText);
			
			framesText = new TextElement(background, "", TextElement.AUTO_SIZE_RIGHT);
			framesText.setWidth(_width);
			framesText.setX(_width - 5);
			framesText.setAlign(TextElement.ALIGN_RIGHT);
			framesText.setMouseEnabled(false);
			TextStyles.applyListItemStyle(framesText);
			
			updateBackground(false);
			
			DisplayObjectUtil.setY(background, _index * height);
			
			MouseEvents.addOnMouseOver(this, background, onBackgroundMouseOver);
			MouseEvents.addOnMouseDown(this, background, onBackgroundMouseDown);
			MouseEvents.addOnMouseOut(this, background, onBackgroundMouseOut);
		}
		
		private function updateBackground(_isHighlighted : Boolean) : void {
			GraphicsUtil.clear(background);
			GraphicsUtil.beginFill(background, 0xFFFFFF, _isHighlighted ? 0.5 : 0.2);
			GraphicsUtil.drawRect(background, 0, 0, width, 20);
		}
		
		public function setVisible(_value : Boolean) : void {
			DisplayObjectUtil.setVisible(background, _value);
			// We also move it up if it's not supposed to be visible, as it otherwise would count towards the scrollable height
			if (_value == false) {
				setHighlighted(false);
				DisplayObjectUtil.setY(background, 0);
			} else {
				DisplayObjectUtil.setY(background, index * height);
			}
		}
		
		public function setIsClickedChild(_value : Boolean) : void {
			DisplayObjectUtil.setVisible(clickedChildIcon, _value);
		}
		
		public function setMouseSelectEnabled(_value : Boolean) : void {
			isMouseSelectEnabled = _value;
			if (isMouseSelectEnabled == false) {
				DisplayObjectUtil.setAlpha(mouseSelectableIcon, 1);
			} else if (isMouseOver == false) {
				DisplayObjectUtil.setAlpha(mouseSelectableIcon, 0);
			}
		}
		
		public function setHighlighted(_value : Boolean) : void {
			updateBackground(_value);
		}
		
		public function update(_child : DisplayObject, _depth : Number, _isExpandable : Boolean, _isExpanded : Boolean) : void {
			background.buttonMode = MovieClipUtil.isMovieClip(_child);
			
			depth = _depth;
			if (_child != child || _isExpandable != isExpandable || _isExpanded != isExpanded) {
				child = _child;
				isExpandable = _isExpandable;
				isExpanded = _isExpanded;
				updateNameText(_depth, _isExpandable, _isExpanded);
			}
			
			updateFramesText();
		}
		
		private function updateNameText(_depth : Number, _isExpandable : Boolean, _isExpanded : Boolean) : void {
			var name : String = "";
			
			for (var i : Number = 0; i < _depth; i++) {
				name += "  ";
			}
			
			if (_isExpandable == true && _isExpanded == true) {
				name += "v ";
			} else if (_isExpandable == true && _isExpanded == false) {
				name += "> ";
			} else {
				name += "  ";
			}
			
			name += _depth == 0 ? "root" : DisplayObjectUtil.getChildPathPart(child, _depth);
			
			nameText.setText(name);
		}
		
		private function updateFramesText() : void {
			if (MovieClipUtil.isMovieClip(child) == true) {
				var movieClip : MovieClip = MovieClipUtil.objectAsMovieClip(child);
				framesText.setText(MovieClipUtil.getCurrentFrame(movieClip) + "/" + MovieClipUtil.getTotalFrames(movieClip));
			} else {
				framesText.setText("-/-");
			}
		}
		
		private function onBackgroundMouseOver() : void {
			isMouseOver = true;
			if (isMouseSelectEnabled == true && MovieClipUtil.isMovieClip(child) == true) {
				DisplayObjectUtil.setAlpha(mouseSelectableIcon, 0.5);
			}
		}
		
		private function onBackgroundMouseDown() : void {
			var localMousePosition : Point = DisplayObjectUtil.globalToLocal(background, StageUtil.getMouseX(), StageUtil.getMouseY());
			
			if (localMousePosition.x <= toggleIconWidth) {
				onToggleMouseSelect.emit(index);
				return;
			}
			
			var shouldExpand : Boolean = localMousePosition.x <= (toggleIconWidth * 2) + (depth + 1) * 15;
			
			if (shouldExpand == true && isExpandable == true) {
				onExpand.emit(index);
			} else {
				onSelect.emit(index);
			}
		}
		
		private function onBackgroundMouseOut() : void {
			if (isMouseSelectEnabled == true) {
				DisplayObjectUtil.setAlpha(mouseSelectableIcon, 0);
			} else {
				DisplayObjectUtil.setAlpha(mouseSelectableIcon, 1);
			}
			isMouseOver = false;
		}
	}
}