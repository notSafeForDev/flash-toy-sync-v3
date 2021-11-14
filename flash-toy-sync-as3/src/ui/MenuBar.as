package ui {
	import components.Timeout;
	import core.CustomEvent;
	import core.MouseEvents;
	import core.TPMovieClip;
	import core.TPStage;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MenuBar {
		
		public static var height : Number = 30;
		
		public var exitEvent : CustomEvent;
		public var showKeyboardShortcutsEvent : CustomEvent;
		
		private var container : TPMovieClip;
		private var openHitArea : TPMovieClip;
		private var bar : TPMovieClip;
		private var buttonsContainer : TPMovieClip;
		
		private var buttons : Vector.<UIButton>;
		
		private var closeTimeout : Number = -1;
		
		public function MenuBar(_container : TPMovieClip) {
			container = TPMovieClip.create(_container, "menuBarContainer");
			
			exitEvent = new CustomEvent();
			showKeyboardShortcutsEvent = new CustomEvent();
			
			openHitArea = TPMovieClip.create(container, "menuBarOpenHitArea");
			bar = TPMovieClip.create(container, "menuBar");
			
			openHitArea.graphics.beginFill(0xFF0000, 0);
			openHitArea.graphics.drawRect(0, 0, TPStage.stageWidth, 10);
			
			bar.graphics.beginFill(0x000000, 0.75);
			bar.graphics.drawRect(0, 0, TPStage.stageWidth, height);
			
			buttonsContainer = TPMovieClip.create(container, "buttonsContainer");
			
			bar.visible = false;
			buttonsContainer.visible = false;
			
			buttons = new Vector.<UIButton>();
			
			addButton("Exit", 60, onExitButtonClick);
			// addButton("Keyboard Shortcuts", 150, onKeyboardShortcutsButtonClick);
			
			MouseEvents.addOnMouseOver(this, openHitArea.sourceDisplayObject, onOpenHitAreaMouseOver);
			
			Index.enterFrameEvent.listen(this, onEnterFrame);
		}
		
		private function onEnterFrame() : void {
			if (bar.visible == true && closeTimeout < 0 && TPStage.mouseY > height) {
				closeTimeout = Timeout.set(this, onCloseTimeoutDone, 1000);
			}
			
			if (bar.visible == true && closeTimeout >= 0 && TPStage.mouseY <= height) {
				Timeout.clear(closeTimeout);
				closeTimeout = -1;
			}
		}
		
		private function onOpenHitAreaMouseOver() : void {			
			bar.visible = true;
			buttonsContainer.visible = true;
		}
		
		private function onCloseTimeoutDone() : void {
			bar.visible = false;
			buttonsContainer.visible = false;
		}
		
		private function onExitButtonClick() : void {
			exitEvent.emit();
		}
		
		private function onKeyboardShortcutsButtonClick() : void {
			showKeyboardShortcutsEvent.emit();
		}
		
		private function addButton(_text : String, _width : Number, _handler : Function) : void {
			var buttonElement : TPMovieClip = TPMovieClip.create(buttonsContainer, "button" + buttons.length);
			buttonElement.graphics.beginFill(0xFF0000, 0);
			buttonElement.graphics.drawRect(0, 0, _width, height);
			
			var text : TextElement = new TextElement(buttonElement, _text);
			TextStyles.applyMenuBarButtonStyle(text);
			text.element.width = _width;
			text.element.y = 5;
			
			var button : UIButton = new UIButton(buttonElement); 
			
			button.mouseClickEvent.listen(this, _handler);
			
			if (buttons.length == 0) {
				buttons.push(button);
				return;
			}
			
			var lastButton : UIButton = buttons[buttons.length - 1];
			button.element.x = lastButton.element.x + lastButton.element.width;
			
			buttons.push(button);
		}
	}
}