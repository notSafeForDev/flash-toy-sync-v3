package components {
	
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
		private var child : MovieClip;
		private var depth : Number;
		
		private var width : Number;
		private var height : Number = 20;
		private var isExpandable : Boolean = false;
		private var isExpanded : Boolean = false;
		
		public var background : MovieClip;
		private var nameText : TextElement;
		private var framesText : TextElement;
		
		public var onSelect : CustomEvent;
		public var onExpand : CustomEvent;
		
		public function HierarchyPanelListItem(_parent : MovieClip, _index : Number, _width : Number) {
			index = _index;
			width = _width;
			
			onSelect = new CustomEvent();
			onExpand = new CustomEvent();
			
			background = MovieClipUtil.create(_parent, "background" + _index);
			background.useHandCursor = true;
			background.buttonMode = true;
			
			nameText = new TextElement(background, "PLACEHOLDER");
			nameText.element.textColor = 0xFFFFFF;
			nameText.setFont(Fonts.COURIER_NEW);
			nameText.setBold(true);
			nameText.setMouseEnabled(false);
			
			framesText = new TextElement(background);
			framesText.element.textColor = 0xFFFFFF;
			framesText.setFont(Fonts.COURIER_NEW);
			framesText.setX(_width - 5);
			framesText.setAlign(TextElement.ALIGN_RIGHT);
			framesText.setAutoSize(TextElement.AUTO_SIZE_RIGHT);
			framesText.setMouseEnabled(false);
			
			updateBackground(false);
			
			MovieClipUtil.setY(background, _index * height);
			
			MouseEvents.addOnMouseDown(this, background, onBackgroundMouseDown);
		}
		
		private function updateBackground(_isHighlighted : Boolean) : void {
			GraphicsUtil.clear(background);
			GraphicsUtil.beginFill(background, 0xFFFFFF, _isHighlighted ? 0.5 : 0.2);
			GraphicsUtil.drawRect(background, 0, 0, width, 20);
		}
		
		public function setVisible(_value : Boolean) : void {
			MovieClipUtil.setVisible(background, _value);
			// We also move it up if it's not supposed to be visible, as it otherwise would count towards the scrollable height
			if (_value == false) {
				setHighlighted(false);
				MovieClipUtil.setY(background, 0);
			} else {
				MovieClipUtil.setY(background, index * height);
			}
		}
		
		public function setHighlighted(_value : Boolean) : void {
			updateBackground(_value);
		}
		
		public function update(_child : MovieClip, _depth : Number, _isExpandable : Boolean, _isExpanded : Boolean) : void {
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
			
			name += _depth == 0 ? "root" : MovieClipUtil.getChildPathPart(child, _depth);
			
			nameText.setText(name);
		}
		
		private function updateFramesText() : void {
			framesText.setText(MovieClipUtil.getCurrentFrame(child) + "/" + MovieClipUtil.getTotalFrames(child));
		}
		
		private function onBackgroundMouseDown() : void {
			var localMousePosition : Point = DisplayObjectUtil.globalToLocal(background, StageUtil.getMouseX(), StageUtil.getMouseY());
			var shouldExpand : Boolean = localMousePosition.x <= (depth + 1) * 15;
			
			if (shouldExpand == true && isExpandable == true) {
				onExpand.emit(index);
			} else {
				onSelect.emit(index);
			}
		}
	}
}