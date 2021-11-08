package ui {
	import core.MouseEvents;
	import core.TPMovieClip;
	import core.TPStage;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DialogueBox {
		
		private static var fade : TPMovieClip;
		private static var box : TPMovieClip;
		private static var text : TextElement;
		
		private static var confirmHandler : Function;
		
		public static function init(_container : TPMovieClip) : void {
			var boxWidth : Number = 400;
			var boxHeight : Number = 200;
			
			var textWidth : Number = 250;
			
			fade = TPMovieClip.create(_container, "dialogueBoxScreenFade");
			fade.graphics.beginFill(0x000000, 0.25);
			fade.graphics.drawRect(0, 0, TPStage.stageWidth, TPStage.stageHeight);
			
			box = TPMovieClip.create(_container, "dialogueBox");
			box.x = TPStage.stageWidth / 2;
			box.y = TPStage.stageHeight / 2;
			
			box.graphics.beginFill(0x000000, 0.5);
			box.graphics.drawRoundedRect(-boxWidth / 2, -boxHeight / 2, boxWidth, boxHeight, 10);
			
			text = new TextElement(box, "Placeholder");
			text.element.width = textWidth;
			text.element.x = -textWidth / 2;
			text.element.y = -boxHeight * 0.3;
			text.wordWrap = true;
			TextStyles.applyListItemStyle(text);
			
			var confirmButton : UIButton = addButton("Confirm", 150);
			confirmButton.element.x = -160;
			confirmButton.element.y = boxHeight * 0.2;
			
			var cancelButton : UIButton = addButton("Cancel", 150);
			cancelButton.element.x = 10;
			cancelButton.element.y = boxHeight * 0.2;
			
			confirmButton.mouseClickEvent.listen(DialogueBox, onConfirmButtonClick);
			cancelButton.mouseClickEvent.listen(DialogueBox, onCancelButtonClick);
			
			box.visible = false;
			fade.visible = false;
			
			// Makes it so that the container can't be clicked through for AS2
			MouseEvents.addOnMouseDown(fade, fade.sourceDisplayObject, function() : void {});
			fade.buttonMode = false;
		}
		
		public static function open(_text : String, _scope : *, _confirmHandler : Function) : void {
			confirmHandler = function() : void {
				_confirmHandler.apply(_scope);
			}
			
			text.text = _text;
			fade.visible = true;
			box.visible = true;
		}
		
		private static function onConfirmButtonClick() : void {
			if (confirmHandler != null) {
				confirmHandler();
			}
			
			fade.visible = false;
			box.visible = false;
		}
		
		private static function onCancelButtonClick() : void {
			fade.visible = false;
			box.visible = false;
		}
		
		private static function addButton(_text : String, _width : Number) : UIButton {
			var buttonElement : TPMovieClip = TPMovieClip.create(box, _text + "Button");
			
			buttonElement.graphics.beginFill(0xFFFFFF);
			buttonElement.graphics.drawRoundedRect(0, 0, _width, 30, 10);
			
			var text : TextElement = new TextElement(buttonElement, _text);
			TextStyles.applyMainMenuButtonStyle(text);
			text.element.width = _width;
			text.element.y = 4;
			
			return new UIButton(buttonElement);
		}
	}
}