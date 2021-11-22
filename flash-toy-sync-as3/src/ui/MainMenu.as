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
		public var toyConnectionTypeChangeEvent : CustomEvent;
		public var theHandyConnectionKeyChangeEvent : CustomEvent;
		
		private var menuContainer : TPMovieClip;
		private var theHandyContainer : TPMovieClip;
		private var intifaceContainer : TPMovieClip;
		
		private var menuWidth : Number = 300;
		
		private var selectedAnimationText : TextElement;
		
		private var browseButton : UIButton;
		private var playButton : UIButton;
		private var editButton : UIButton;
		
		private var toyConnectionTypeDropdown : UIDropdown;
		
		private var connectionKeyInputText : TextElement;
		
		private var qualityDropdown : UIDropdown;
		
		public function MainMenu(_container : TPMovieClip) {
			menuContainer = TPMovieClip.create(_container, "mainMenu");
			
			browseAnimationEvent = new CustomEvent();
			playAnimationEvent = new CustomEvent();
			editAnimationEvent = new CustomEvent();
			toyConnectionTypeChangeEvent = new CustomEvent();
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
			
			var qualityTitleText : TextElement = new TextElement(menuContainer, "Quality:");
			TextStyles.applyParagraphStyle(qualityTitleText);
			qualityTitleText.element.y = 130;
			qualityTitleText.element.width = menuWidth;
			
			qualityDropdown = new UIDropdown(menuContainer, ["HIGH", "MEDIUM", "LOW"], TPStage.quality, menuWidth);
			qualityDropdown.element.y = 150;
			qualityDropdown.selectEvent.listen(this, onQualityDropdownSelect);
			
			var toyConnectionTypeTitleText : TextElement = new TextElement(menuContainer, "Toy Connection Type:");
			TextStyles.applyParagraphStyle(toyConnectionTypeTitleText);
			toyConnectionTypeTitleText.element.y = 180;
			toyConnectionTypeTitleText.element.width = menuWidth;
			
			toyConnectionTypeDropdown = new UIDropdown(menuContainer, [ToyStates.THE_HANDY_CONNECTION_TYPE, ToyStates.INTIFACE_CONNECTION_TYPE], ToyStates.toyConnectionType.value, menuWidth);
			toyConnectionTypeDropdown.element.y = 200;
			toyConnectionTypeDropdown.selectEvent.listen(this, onToyConnectionTypeDropdownSelect);
			
			theHandyContainer = TPMovieClip.create(menuContainer, "theHandyOptions");
			theHandyContainer.y = 230;
			
			var connectionKeyTitleText : TextElement = new TextElement(theHandyContainer, "theHandy Connection Key:");
			TextStyles.applyParagraphStyle(connectionKeyTitleText);
			connectionKeyTitleText.element.width = menuWidth;
			
			connectionKeyInputText = new TextElement(theHandyContainer, ToyStates.theHandyConnectionKey.value);
			TextStyles.applyInputStyle(connectionKeyInputText);
			connectionKeyInputText.convertToInputField(this, onTheHandyConnectionKeyInputTextChange);
			connectionKeyInputText.element.y = 20;
			connectionKeyInputText.element.width = menuWidth;
			connectionKeyInputText.element.height = 20;
			
			intifaceContainer = TPMovieClip.create(menuContainer, "intifaceOptions");
			intifaceContainer.y = 230;
			
			var intifaceInfoText : TextElement = new TextElement(intifaceContainer, "You need to run intiface-bridge in order to connect with Intiface Desktop");
			TextStyles.applyParagraphStyle(intifaceInfoText);
			intifaceInfoText.element.width = menuWidth;
			intifaceInfoText.wordWrap = true;
			
			menuContainer.x = (TPStage.stageWidth - menuWidth) / 2;
			menuContainer.y = (TPStage.stageHeight - menuContainer.height) / 2;
			
			AnimationInfoStates.listen(this, onAnimationInfoStatesChange, [AnimationInfoStates.isStandalone, AnimationInfoStates.name, AnimationInfoStates.isLoaded]);
			ToyStates.listen(this, onToyConnectionTypeStateChange, [ToyStates.toyConnectionType]);
			ToyStates.listen(this, onTheHandyConnectionKeyStateChange, [ToyStates.theHandyConnectionKey]);
		}
		
		private function onAnimationInfoStatesChange() : void {
			if (AnimationInfoStates.name.value == "") {
				selectedAnimationText.text = "Animation: -";
			} else {
				selectedAnimationText.text = "Animation: " + AnimationInfoStates.name.value;
			}
			
			browseButton.setEnabled(AnimationInfoStates.isStandalone.value == false);
			playButton.setEnabled(AnimationInfoStates.name.value != "");
			editButton.setEnabled(AnimationInfoStates.name.value != "");
			
			if (AnimationInfoStates.isLoaded.value == true) {
				menuContainer.visible = false;
			} else {
				menuContainer.visible = true;
				qualityDropdown.setSelectedOption(TPStage.quality);
			}
		}
		
		private function onTheHandyConnectionKeyInputTextChange(_key : String) : void {
			theHandyConnectionKeyChangeEvent.emit(_key);
		}
		
		private function onToyConnectionTypeStateChange() : void {
			toyConnectionTypeDropdown.setSelectedOption(ToyStates.toyConnectionType.value);
			
			theHandyContainer.visible = ToyStates.toyConnectionType.value == ToyStates.THE_HANDY_CONNECTION_TYPE;
			intifaceContainer.visible = ToyStates.toyConnectionType.value == ToyStates.INTIFACE_CONNECTION_TYPE;
		}
		
		private function onTheHandyConnectionKeyStateChange() : void {
			connectionKeyInputText.text = ToyStates.theHandyConnectionKey.value;
		}
		
		private function onQualityDropdownSelect(_value : String) : void {
			TPStage.quality = _value;
		}
		
		private function onToyConnectionTypeDropdownSelect(_value : String) : void {
			toyConnectionTypeChangeEvent.emit(_value);
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