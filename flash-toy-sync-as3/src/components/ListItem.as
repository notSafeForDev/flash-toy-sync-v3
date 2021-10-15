package components {
	
	import flash.display.MovieClip;
	
	import core.CustomEvent;
	import core.DisplayObjectUtil;
	import core.GraphicsUtil;
	import core.MouseEvents;
	import core.MovieClipUtil;
	import core.TextElement;
	
	import config.TextStyles;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ListItem {
		
		private var index : Number;
		private var width : Number;
		private var height : Number = 20;
		
		public var onSelect : CustomEvent;
		
		protected var primaryText : TextElement;
		
		public var background : MovieClip;
		
		public function ListItem(_parent : MovieClip, _index : Number, _width : Number) {
			index = _index;
			width = _width;
			
			onSelect = new CustomEvent();
			
			background = MovieClipUtil.create(_parent, "background" + _index);
			DisplayObjectUtil.setY(background, index * height);
			background.buttonMode = true;
			
			primaryText = new TextElement(background, getPrimaryText());
			TextStyles.applyListItemStyle(primaryText);
			primaryText.setWidth(_width);
			primaryText.setBold(true);
			primaryText.setMouseEnabled(false);
			
			MouseEvents.addOnMouseDown(this, background, onMouseDown);
			
			updateBackground(false);
		}
		
		private function getPrimaryText() : String {
			return "Item: " + index;
		}
		
		public function setPrimaryText(_text : String) : void {
			primaryText.setText(_text);
		}
		
		private function updateBackground(_isHighlighted : Boolean) : void {
			GraphicsUtil.clear(background);
			GraphicsUtil.beginFill(background, 0xFFFFFF, _isHighlighted ? 0.5 : 0.2);
			GraphicsUtil.drawRect(background, 0, 0, width, 20);
		}
		
		private function onMouseDown() : void {
			onSelect.emit(index);
		}
		
		public function setVisible(_visible : Boolean) : void {
			DisplayObjectUtil.setVisible(background, _visible);
			 // We also move it up incase it's not supposed to be visible, as it otherwise counts towards the total height of scroll content
			DisplayObjectUtil.setY(background, _visible ? index * height : 0);
		}
		
		public function setHighlighted(_value : Boolean) : void {
			updateBackground(_value);
		}
	}
}