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
		
		public function setNameText(_value : String) : void {
			nameText.setText(_value);
		}
		
		public function setFrameValues(_currentFrame : Number, _totalFrames : Number) : void {
			framesText.setText(_currentFrame + "/" + _totalFrames);
		}
		
		private function onBackgroundMouseDown() : void {
			onMouseDown.emit(index);
		}
	}
}