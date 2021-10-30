package ui {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import core.TPStage;
	import core.CustomEvent;
	import flash.display.MovieClip;
	import states.AnimationInfoStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MainMenu {
		
		public var browseAnimationEvent : CustomEvent;
		public var playAnimationEvent : CustomEvent;
		public var editAnimationEvent : CustomEvent;
		
		private var menuContainer : TPMovieClip;
		
		private var menuWidth : Number = 300;
		
		private var selectedAnimationText : TextElement;
		
		private var browseButton : UIButton;
		private var playButton : UIButton;
		private var editButton : UIButton;
		
		public function MainMenu(_container : TPMovieClip) {
			menuContainer = TPMovieClip.create(_container, "mainMenu");
			
			browseAnimationEvent = new CustomEvent();
			playAnimationEvent = new CustomEvent();
			editAnimationEvent = new CustomEvent();
			
			selectedAnimationText = new TextElement(menuContainer, "");
			TextStyles.applyListItemStyle(selectedAnimationText);
			
			browseButton = createButton(menuWidth, "Browse", browseAnimationEvent);
			
			selectedAnimationText.element.width = 250;
			selectedAnimationText.element.y = 45;
			
			playButton = createButton(menuWidth / 2 - 5, "Play", playAnimationEvent);
			editButton = createButton(menuWidth / 2 - 5, "Edit", editAnimationEvent);
			
			playButton.element.y = 80;
			editButton.element.y = 80;
			editButton.element.x = menuWidth / 2 + 5;
			
			menuContainer.x = (TPStage.stageWidth - menuWidth) / 2;
			menuContainer.y = (TPStage.stageHeight - menuContainer.height) / 2;
			
			AnimationInfoStates.listen(this, onAnimationInfoStatesChange, [AnimationInfoStates.name, AnimationInfoStates.isLoaded]);
		}
		
		private function onAnimationInfoStatesChange() : void {
			if (AnimationInfoStates.name.value == "") {
				selectedAnimationText.text = "Animation: -";
				playButton.disable();
				editButton.disable();
			} else {
				selectedAnimationText.text = "Animation: " + AnimationInfoStates.name.value;
				playButton.enable();
				editButton.enable();
			}
			
			if (AnimationInfoStates.isLoaded.value == true) {
				menuContainer.visible = false;
			} else {
				menuContainer.visible = true;
			}
		}
		
		private function createButton(_width : Number, _text : String, _event : CustomEvent) : UIButton {
			var buttonElement : TPMovieClip = TPMovieClip.create(menuContainer, "button");
			
			buttonElement.graphics.beginFill(0xFFFFFF);
			buttonElement.graphics.drawRoundedRect(0, 0, _width, 30, 10);
			
			var textElement : TextElement = new TextElement(buttonElement, _text);
			TextStyles.applyMainMenuButtonStyle(textElement);
			textElement.element.width = _width;
			textElement.element.height = 20;
			textElement.element.y = 4;
			
			var button : UIButton = new UIButton(buttonElement);
			button.mouseClickEvent.listen(_event, _event.emit);
			
			return button;
		}
	}
}