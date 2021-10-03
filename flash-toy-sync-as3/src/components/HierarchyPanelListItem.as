package components {
	
	import core.CustomEvent;
	import core.Fonts;
	import core.GraphicsUtil;
	import core.MouseEvents;
	import core.MovieClipUtil;
	import core.TextElement;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanelListItem {
		
		private var index : Number;
		private var child : MovieClip;
		private var isExpanded : Boolean = false;
		
		private var background : MovieClip;
		private var nameText : TextElement;
		private var framesText : TextElement;
		
		public var onMouseDown : CustomEvent;
		
		public function HierarchyPanelListItem(_parent : MovieClip, _index : Number, _width : Number) {
			index = _index;
			
			onMouseDown = new CustomEvent();
			
			background = MovieClipUtil.create(_parent, "background");
			
			nameText = new TextElement(background, "PLACEHOLDER");
			nameText.element.textColor = 0xFFFFFF;
			nameText.setFont(Fonts.COURIER_NEW);
			nameText.setBold(true);
			
			framesText = new TextElement(background);
			framesText.element.textColor = 0xFFFFFF;
			framesText.setFont(Fonts.COURIER_NEW);
			framesText.setX(_width - 5);
			framesText.setAlign(TextElement.ALIGN_RIGHT);
			framesText.setAutoSize(TextElement.AUTO_SIZE_RIGHT);
			
			GraphicsUtil.beginFill(background, 0xFFFFFF, 0.2);
			GraphicsUtil.drawRect(background, 0, 0, _width, 20);
			MovieClipUtil.setY(background, _index * 20);
			
			MouseEvents.addOnMouseDown(this, background, onBackgroundMouseDown);
		}
		
		public function setVisible(_value : Boolean) : void {
			MovieClipUtil.setVisible(background, _value);
		}
		
		public function update(_child : MovieClip, _depth : Number, _isExpandable : Boolean, _isExpanded : Boolean) : void {
			if (_child != child || _isExpanded != isExpanded) {
				child = _child;
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
			onMouseDown.emit(index);
		}
	}
}