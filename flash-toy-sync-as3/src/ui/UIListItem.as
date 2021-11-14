package ui {
	
	import core.CustomEvent;
	import core.MouseEvents;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class UIListItem {
		
		public var clickEvent : CustomEvent;
		
		public var background : TPMovieClip;
		
		protected var primaryText : TextElement;
		protected var secondaryText : TextElement;
		
		protected var index : Number;
		
		private var defaultColorTransform : ColorTransform;
		private var highlightColorTransform : ColorTransform;
		
		protected var width : Number;
		protected var height : Number = 20;
		
		public function UIListItem(_parent : TPMovieClip, _width : Number, _index : Number) {
			width = _width;
			index = _index;
			
			clickEvent = new CustomEvent();
			
			defaultColorTransform = new ColorTransform();
			highlightColorTransform = new ColorTransform();
			
			highlightColorTransform.redOffset = 100;
			highlightColorTransform.greenOffset = 100;
			highlightColorTransform.blueOffset = 100;
			
			background = TPMovieClip.create(_parent, "listItem" + _index);
			background.y = _index * height;
			updateBackgroundGraphics();
			
			primaryText = new TextElement(background, "");
			TextStyles.applyListItemStyle(primaryText);
			primaryText.element.width = _width;
			primaryText.element.height = height;
			
			secondaryText = new TextElement(background, "");
			TextStyles.applyListItemStyle(secondaryText);
			secondaryText.element.width = _width;
			secondaryText.element.height = height;
			
			var secondaryTextFormat : TextFormat = secondaryText.getTextFormat();
			secondaryTextFormat.align = TextElement.ALIGN_RIGHT;
			secondaryText.setTextFormat(secondaryTextFormat);
			
			background.buttonMode = true;
			MouseEvents.addOnMouseDown(this, background.sourceDisplayObject, onMouseDown);
		}
		
		protected function updateBackgroundGraphics() : void {
			background.graphics.clear();
			background.graphics.beginFill(0x000000, 0.5);
			background.graphics.drawRect(0, 0, width, height);
		}
		
		protected function onMouseDown() : void {
			clickEvent.emit(index);
		}
		
		public function isVisible() : Boolean {
			return background.visible;
		}
		
		public function getHeight() : Number {
			return height;
		}
		
		public function setPrimaryText(_text : String) : void {
			primaryText.text = _text;
		}
		
		public function setSecondaryText(_text : String) : void {
			secondaryText.text = _text;
		}
		
		public function highlight() : void {
			background.colorTransform = highlightColorTransform;
		}
		
		public function clearHighlight() : void {
			background.colorTransform = defaultColorTransform;
		}
		
		public function hide() : void {
			background.visible = false;
			background.y = 0;
		}
		
		public function show() : void {
			background.visible = true;
			background.y = index * height;
		}
	}
}