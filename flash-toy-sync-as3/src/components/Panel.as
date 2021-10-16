package components {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import core.StageUtil;
	import core.DisplayObjectUtil;
	import core.Fonts;
	import core.TextElement;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.DraggableObject;
	import core.MouseEvents;
	
	import config.TextStyles;

	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Panel {
		
		private var titleBarHeight : Number = 24;
		
		public var container : MovieClip;
		public var titleBar : MovieClip;
		public var background : MovieClip;
		public var content : MovieClip;
		
		protected var contentWidth : Number;
		protected var contentHeight : Number;
		
		protected var layoutPadding : Number = 10;
		protected var layoutElementsSpacing : Number = 5;
		
		private var layoutElements : Array;
		
		public function Panel(_parent : MovieClip, _name : String, _contentWidth : Number, _contentHeight : Number) {
			contentWidth = _contentWidth;
			contentHeight = _contentHeight;
			
			layoutElements = [];
			
			var instanceName : String = _name.split(" ").join("");
			container = MovieClipUtil.create(_parent, instanceName);
			titleBar = MovieClipUtil.create(container,  "titleBar");
			background = MovieClipUtil.create(container, "background");
			content = MovieClipUtil.create(background, "content");
			
			titleBar.buttonMode = true;
			
			DisplayObjectUtil.setY(background, titleBarHeight);
			
			var titleText : TextElement = new TextElement(titleBar, _name);
			titleText.setWidth(_contentWidth - 3);
			titleText.setX(3);
			titleText.setY(1);
			TextStyles.applyPanelTitleStyle(titleText);
			titleText.setMouseEnabled(false);
			
			GraphicsUtil.beginFill(titleBar, 0x222222, 0.75);
			GraphicsUtil.drawRect(titleBar, 0, 0, _contentWidth, titleBarHeight);
			
			updateBackground();
			
			var minimizeButton : MovieClip = MovieClipUtil.create(container, "minimizeButton");
			minimizeButton.buttonMode = true;
			DisplayObjectUtil.setX(minimizeButton, _contentWidth - 22);
			DisplayObjectUtil.setY(minimizeButton, 2);
			GraphicsUtil.beginFill(minimizeButton, 0xFFFFFF);
			GraphicsUtil.drawRect(minimizeButton, 0, 0, 20, 20);
			GraphicsUtil.beginFill(minimizeButton, 0x000000);
			GraphicsUtil.drawRect(minimizeButton, 4, 12, 12, 3);
			MouseEvents.addOnMouseDown(this, minimizeButton, onToggleMinimize);
			
			var draggable : DraggableObject = new DraggableObject(container, titleBar);
			draggable.bringToFrontOnDrag = true;
			draggable.screenBounds = new Rectangle(0, 0, StageUtil.getWidth(), StageUtil.getHeight());
		}
		
		public function addElementToLayout(_element : DisplayObject, _keepYPosition : Boolean) : void {
			if (_keepYPosition == false && layoutElements.length > 0) {
				var lastLayoutElement : DisplayObject = layoutElements[layoutElements.length - 1];
				var y : Number = DisplayObjectUtil.getY(lastLayoutElement);
				var height : Number = DisplayObjectUtil.getHeight(lastLayoutElement);
				DisplayObjectUtil.setY(_element, y + height + layoutElementsSpacing);
			}
			
			if (_keepYPosition == false && layoutElements.length == 0) {
				DisplayObjectUtil.setY(_element, layoutPadding);
			}
			
			var addedY : Number = DisplayObjectUtil.getY(_element);
			var addedHeight : Number = DisplayObjectUtil.getHeight(_element);
			
			layoutElements.push(_element);
			
			updateBackground();
		}
		
		public function clearContent() : void {
			MovieClipUtil.remove(content);
			content = MovieClipUtil.create(background, "content");
		}
		
		public function setPosition(_x : Number, _y : Number) : void {
			DisplayObjectUtil.setX(container, _x);
			DisplayObjectUtil.setY(container, _y);
		}
		
		private function onToggleMinimize() : void {
			var shouldShow : Boolean = !DisplayObjectUtil.isVisible(content);
			DisplayObjectUtil.setVisible(content, shouldShow);
			DisplayObjectUtil.setVisible(background, shouldShow);
		}
		
		private function updateBackground() : void {
			var layoutHeight : Number = -1;
			
			if (layoutElements.length > 0) {
				var lastLayoutElement : DisplayObject = layoutElements[layoutElements.length - 1];
				var y : Number = DisplayObjectUtil.getY(lastLayoutElement);
				var height : Number = DisplayObjectUtil.getHeight(lastLayoutElement);
				layoutHeight = y + height + layoutPadding;
			}
			
			GraphicsUtil.clear(background);
			GraphicsUtil.beginFill(background, 0x000000, 0.5);
			GraphicsUtil.drawRect(background, 0, 0, contentWidth, Math.max(layoutHeight, contentHeight));
		}
		
		protected function addDivider() : MovieClip {
			var divider : MovieClip = MovieClipUtil.create(content, "divider");
			GraphicsUtil.beginFill(divider, 0xFF0000, 0);
			GraphicsUtil.drawRect(divider, 0, 0, contentWidth, layoutElementsSpacing * 3);
			GraphicsUtil.setLineStyle(divider, 1, 0xFFFFFF, 0.25);
			GraphicsUtil.moveTo(divider, layoutPadding, layoutElementsSpacing * 1.5);
			GraphicsUtil.lineTo(divider, contentWidth - layoutPadding, layoutElementsSpacing * 1.5);
			
			addElementToLayout(divider, false);
			
			return divider;
		}
		
		protected function createText(_parent : MovieClip, _text : String, _height : Number) : TextElement {
			var textElement : TextElement = new TextElement(_parent, _text);
			TextStyles.applyListItemStyle(textElement);
			textElement.element.wordWrap = true;
			textElement.setHeight(_height);
			textElement.setWidth(contentWidth - layoutPadding * 2);
			
			return textElement;
		}
		
		protected function addText(_text : String, _height : Number) : TextElement {
			var textElement : TextElement = createText(content, _text, _height);
			textElement.setX(layoutPadding);
			
			addElementToLayout(textElement.element, false);
			
			return textElement;
		}
		
		protected function createInputText(_parent : MovieClip, _defaultText : String, _scope : *, _onChangeHandler : Function) : TextElement {
			var textElement : TextElement = new TextElement(_parent, _defaultText);
			TextStyles.applyInputStyle(textElement);
			textElement.convertToInputField();
			textElement.setWidth(contentWidth - layoutPadding * 2);
			
			if (_onChangeHandler != null) {
				textElement.onChange.listen(_scope, _onChangeHandler);
			}
			
			return textElement;
		}
		
		protected function addInputText(_defaultText : String, _scope : *, _onChangeHandler : Function) : TextElement {
			var textElement : TextElement = createInputText(content, _defaultText, _scope, _onChangeHandler);
			textElement.setX(layoutPadding);
			
			addElementToLayout(textElement.element, false);
			
			return textElement;
		}
		
		protected function addButton(_text : String) : UIButton {
			var element : MovieClip = MovieClipUtil.create(content, _text.split(" ").join("") + "Button");
			element.buttonMode = true;
			element.mouseEnabled = true;
			
			var buttonWidth : Number = contentWidth - layoutPadding * 2;
			
			GraphicsUtil.beginFill(element, 0xFFFFFF);
			GraphicsUtil.drawRect(element, 0, 0, buttonWidth, 30);
			
			var text : TextElement = new TextElement(element, _text);
			text.setWidth(buttonWidth);
			text.setAutoSize(TextElement.AUTO_SIZE_CENTER);
			text.setMouseEnabled(false);
			text.setY(6);
			TextStyles.applyButtonStyle(text);
			
			DisplayObjectUtil.setX(element, layoutPadding);
			
			var button : UIButton = new UIButton(element);
			button.disabledAlpha = 0.5;
			
			addElementToLayout(element, false);
			
			return button;
		}
	}
}