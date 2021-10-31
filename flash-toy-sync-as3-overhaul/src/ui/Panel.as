package ui {
	
	import core.DraggableObject;
	import core.MouseEvents;
	import core.SimpleDraggableObject;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import core.TPStage;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Panel {
		
		private var container : TPMovieClip;
		
		private var titleBarHeight : Number = 24;
		
		private var background : TPMovieClip;
		private var titleBar : TPMovieClip;
		private var titleText : TextElement;
		
		protected var content : TPMovieClip;
		
		protected var contentWidth : Number;
		protected var contentHeight : Number;
		
		protected var layoutPadding : Number = 10;
		protected var layoutElementsSpacing : Number = 5;
		
		private var layoutElements : Vector.<TPDisplayObject>;
		
		public function Panel(_parent : TPMovieClip, _name : String, _contentWidth : Number, _contentHeight : Number) {
			contentWidth = _contentWidth;
			contentHeight = _contentHeight;
			
			layoutElements = new Vector.<TPDisplayObject>();
			
			var instanceName : String = _name.split(" ").join("");
			container = TPMovieClip.create(_parent, instanceName);
			background = TPMovieClip.create(container, "background");
			content = TPMovieClip.create(background, "content");
			
			background.y = titleBarHeight;
			
			titleBar = addTitleBar(container);
			titleText = addTitleText(container, _name);
			addMinimizeButton(container);
			
			var draggable : DraggableObject = new DraggableObject(container, titleBar);
			draggable.bringToFrontOnDrag = true;
			draggable.dragBounds = new Rectangle(0, 0, TPStage.stageWidth - contentWidth, TPStage.stageHeight - titleBarHeight);
			
			updateBackground();
		}
		
		public function setPosition(_x : Number, _y : Number) : void {
			container.x = _x;
			container.y = _y;
		}
		
		public function isMinimized() : Boolean {
			return background.visible == false;
		}
		
		public function hide() : void {
			container.visible = false;
		}
		
		public function show() : void {
			container.visible = true;
		}
		
		private function addTitleBar(_parent : TPMovieClip) : TPMovieClip {
			var element : TPMovieClip = TPMovieClip.create(_parent, "titleBar");
			element.buttonMode = true;
			element.graphics.beginFill(0x222222, 0.75);
			element.graphics.drawRect(0, 0, contentWidth, titleBarHeight);
			
			return element;
		}
		
		private function addTitleText(_parent : TPMovieClip, _text : String) : TextElement {
			var text : TextElement = new TextElement(_parent, _text);
			TextStyles.applyPanelTitleStyle(text);
			
			text.element.width = contentWidth - 3;
			text.element.x = 3;
			text.element.y = 1;
			
			return text;
		}
		
		private function addMinimizeButton(_parent : TPMovieClip) : UIButton {
			var movieClip : TPMovieClip = TPMovieClip.create(_parent, "minimizeButton");
			var button : UIButton = new UIButton(movieClip);
			
			button.element.graphics.beginFill(0xFFFFFF);
			button.element.graphics.drawRect(0, 0, 20, 20);
			button.element.graphics.beginFill(0x000000);
			button.element.graphics.drawRect(4, 12, 12, 3);
			
			button.element.x = contentWidth - 22;
			button.element.y = 2;
			
			button.mouseClickEvent.listen(this, onToggleMinimize);
			
			return button;
		}
		
		private function onToggleMinimize() : void {
			content.visible = !content.visible;
			background.visible = !background.visible;
		}
		
		private function updateBackground() : void {
			var layoutHeight : Number = -1;
			
			if (layoutElements.length > 0) {
				var lastLayoutElement : TPDisplayObject = layoutElements[layoutElements.length - 1];
				var y : Number = lastLayoutElement.y;
				var height : Number = lastLayoutElement.height;
				layoutHeight = y + height + layoutPadding;
			}
			
			background.graphics.clear();
			background.graphics.beginFill(0x000000, 0.5);
			background.graphics.drawRect(0, 0, contentWidth, Math.max(layoutHeight, contentHeight));
		}
		
		protected function addElementToLayout(_element : TPDisplayObject, _keepYPosition : Boolean) : TPDisplayObject {
			if (_keepYPosition == false && layoutElements.length == 0) {
				_element.y = layoutPadding;
			}
			
			if (_keepYPosition == false && layoutElements.length > 0) {
				var lastLayoutElement : TPDisplayObject = layoutElements[layoutElements.length - 1];
				var y : Number = lastLayoutElement.y;
				var height : Number = lastLayoutElement.height;
				_element.y = y + height + layoutElementsSpacing;
			}
			
			layoutElements.push(_element);
			
			updateBackground();
			
			return _element;
		}
		
		protected function addDivider() : TPDisplayObject {						
			var divider : TPMovieClip = TPMovieClip.create(content, "divider");
			divider.graphics.beginFill(0xFF0000, 0);
			divider.graphics.drawRect(0, 0, contentWidth, layoutElementsSpacing * 3);
			divider.graphics.lineStyle(1, 0xFFFFFF, 0.25);
			divider.graphics.moveTo(layoutPadding, layoutElementsSpacing * 1.5);
			divider.graphics.lineTo(contentWidth - layoutPadding, layoutElementsSpacing * 1.5);
			
			return addElementToLayout(divider, false);
		}
		
		protected function createText(_parent : TPMovieClip, _text : String, _height : Number) : TextElement {
			var textElement : TextElement = new TextElement(_parent, _text);
			TextStyles.applyListItemStyle(textElement);
			textElement.sourceTextField.wordWrap = true;
			textElement.element.height = _height;
			textElement.element.width = contentWidth - layoutPadding * 2;
			
			return textElement;
		}
		
		protected function addText(_text : String, _height : Number) : TextElement {
			var textWrapper : TPMovieClip = TPMovieClip.create(content, "textWrapper");
			textWrapper.x = layoutPadding;
			
			var textElement : TextElement = createText(textWrapper, _text, _height);
			
			addElementToLayout(textWrapper, false);
			
			return textElement;
		}
		
		protected function createInputText(_parent : TPMovieClip, _defaultText : String, _scope : *, _onChangeHandler : Function) : TextElement {
			var textElement : TextElement = new TextElement(_parent, _defaultText);
			TextStyles.applyInputStyle(textElement);
			textElement.element.width = contentWidth - layoutPadding * 2;
			textElement.convertToInputField(_scope, _onChangeHandler);
			
			return textElement;
		}
		
		protected function addInputText(_defaultText : String, _scope : * , _onChangeHandler : Function) : TextElement {
			var textWrapper : TPMovieClip = TPMovieClip.create(content, "inputTextWrapper");
			textWrapper.x = layoutPadding;
			
			var textElement : TextElement = createInputText(textWrapper, _defaultText, _scope, _onChangeHandler);
			
			addElementToLayout(textWrapper, false);
			
			return textElement;
		}
		
		protected function addButton(_text : String) : UIButton {
			var movieClip : TPMovieClip = TPMovieClip.create(content, _text.split(" ").join("") + "Button");
			var button : UIButton = new UIButton(movieClip);
			
			var buttonWidth : Number = contentWidth - layoutPadding * 2;
			
			button.element.graphics.beginFill(0xFFFFFF);
			button.element.graphics.drawRect(0, 0, buttonWidth, 30);
			button.element.x = layoutPadding;
			
			var text : TextElement = new TextElement(movieClip, _text);
			TextStyles.applyButtonStyle(text);
			text.element.width = buttonWidth;
			text.element.y = 6;
			
			addElementToLayout(movieClip, false);
			
			return button;
		}
	}
}