package ui {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import core.TPStage;
	import core.CustomEvent;
	import flash.display.MovieClip;
	import states.AnimationInfoStates;
	import states.ToyStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MainMenu {
		
		public var browseAnimationEvent : CustomEvent;
		public var playAnimationEvent : CustomEvent;
		public var editAnimationEvent : CustomEvent;
		public var theHandyConnectionKeyChangeEvent : CustomEvent;
		
		private var menuContainer : TPMovieClip;
		
		private var menuWidth : Number = 300;
		
		private var selectedAnimationText : TextElement;
		
		private var browseButton : UIButton;
		private var playButton : UIButton;
		private var editButton : UIButton;
		
		private var connectionKeyInputText : TextElement;
		
		public function MainMenu(_container : TPMovieClip) {
			menuContainer = TPMovieClip.create(_container, "mainMenu");
			
			browseAnimationEvent = new CustomEvent();
			playAnimationEvent = new CustomEvent();
			editAnimationEvent = new CustomEvent();
			theHandyConnectionKeyChangeEvent = new CustomEvent();
			
			selectedAnimationText = new TextElement(menuContainer, "");
			TextStyles.applyParagraphStyle(selectedAnimationText);
			
			browseButton = createButton(menuWidth, "Browse", browseAnimationEvent);
			
			selectedAnimationText.element.width = menuWidth;
			selectedAnimationText.element.y = 45;
			
			playButton = createButton(menuWidth / 2 - 5, "Play", playAnimationEvent);
			editButton = createButton(menuWidth / 2 - 5, "Edit", editAnimationEvent);
			
			playButton.element.y = 80;
			editButton.element.y = 80;
			editButton.element.x = menuWidth / 2 + 5;
			
			var connectionKeyTitleText : TextElement = new TextElement(menuContainer, "theHandy Connection Key:");
			TextStyles.applyParagraphStyle(connectionKeyTitleText);
			connectionKeyTitleText.element.y = 130;
			connectionKeyTitleText.element.width = menuWidth;
			
			connectionKeyInputText = new TextElement(menuContainer, ToyStates.theHandyConnectionKey.value);
			TextStyles.applyInputStyle(connectionKeyInputText);
			connectionKeyInputText.convertToInputField(this, onTheHandyConnectionKeyInputTextChange);
			connectionKeyInputText.element.y = 150;
			connectionKeyInputText.element.width = menuWidth;
			connectionKeyInputText.element.height = 20;
			
			menuContainer.x = (TPStage.stageWidth - menuWidth) / 2;
			menuContainer.y = (TPStage.stageHeight - menuContainer.height) / 2;
			
			AnimationInfoStates.listen(this, onAnimationInfoStatesChange, [AnimationInfoStates.name, AnimationInfoStates.isLoaded]);
			ToyStates.listen(this, onTheHandyConnectionKeyStateChange, [ToyStates.theHandyConnectionKey]);
		}
		
		private function onAnimationInfoStatesChange() : void {
			if (AnimationInfoStates.name.value == "") {
				selectedAnimationText.text = "Animation: -";
			} else {
				selectedAnimationText.text = "Animation: " + AnimationInfoStates.name.value;
			}
			
			playButton.setEnabled(AnimationInfoStates.name.value != "");
			editButton.setEnabled(AnimationInfoStates.name.value != "");
			
			if (AnimationInfoStates.isLoaded.value == true) {
				menuContainer.visible = false;
			} else {
				menuContainer.visible = true;
			}
		}
		
		private function onTheHandyConnectionKeyInputTextChange(_key : String) : void {
			theHandyConnectionKeyChangeEvent.emit(_key);
		}
		
		private function onTheHandyConnectionKeyStateChange() : void {
			connectionKeyInputText.text = ToyStates.theHandyConnectionKey.value;
		}
		
		private function createButton(_width : Number, _text : String, _event : CustomEvent) : UIButton {
			var buttonElement : TPMovieClip = TPMovieClip.create(menuContainer, "button");
			
			buttonElement.graphics.beginFill(0xFFFFFF);
			buttonElement.graphics.drawRoundedRect(0, 0, _width, 30, 10);
			
			var textElement : TextElement = new TextElement(buttonElement, _text);
			TextStyles.applyMenuButtonStyle(textElement);
			textElement.element.width = _width;
			textElement.element.height = 20;
			textElement.element.y = 4;
			
			var button : UIButton = new UIButton(buttonElement);
			button.mouseClickEvent.listen(_event, _event.emit);
			
			return button;
		}
	}
}