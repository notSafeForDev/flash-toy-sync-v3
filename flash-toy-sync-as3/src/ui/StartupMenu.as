package ui {
	import core.CustomEvent;
	import core.DisplayObjectUtil;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.StageUtil;
	import core.TextElement;
	import flash.display.MovieClip;
	import global.GlobalState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StartupMenu {
		
		public var container : MovieClip;
		
		public var onTheHandyConnectionKeyChange : CustomEvent;
		public var onBrowseSWF : CustomEvent;
		public var onEnterPlayer : CustomEvent;
		public var onEnterEditor : CustomEvent;
		
		private var animationNameText : TextElement;
		
		private var playerButton : UIButton;
		private var editorButton : UIButton;
		
		public function StartupMenu(_parent : MovieClip) {
			container = MovieClipUtil.create(_parent, "StartUpMenu");
			
			onTheHandyConnectionKeyChange = new CustomEvent();
			onBrowseSWF = new CustomEvent();
			onEnterPlayer = new CustomEvent();
			onEnterEditor = new CustomEvent();
			
			var centerX : Number = StageUtil.getWidth() / 2;
			
			var connectionKeyHeader : TextElement = new TextElement(container, "theHandy Connection Key:");
			TextStyles.applyListItemStyle(connectionKeyHeader);
			connectionKeyHeader.setWidth(220);
			connectionKeyHeader.setX(centerX - 110);
			connectionKeyHeader.setY(270);
			
			var connectionKeyInput : TextElement = new TextElement(container, GlobalState.theHandyConnectionKey.state);
			TextStyles.applyInputStyle(connectionKeyInput);
			connectionKeyInput.setWidth(220);
			connectionKeyInput.setX(centerX - 110);
			connectionKeyInput.setY(290);
			connectionKeyInput.convertToInputField();
			connectionKeyInput.onChange.listen(this, onTheHandyConnectionKeyInputChange);
			
			var browseButton : UIButton = createButton("Browse Animation", 220, onBrowseButtonClick);
			
			DisplayObjectUtil.setX(browseButton.element, centerX - 110);
			DisplayObjectUtil.setY(browseButton.element, 340);
			
			animationNameText = new TextElement(container, "Animation: -");
			TextStyles.applyListItemStyle(animationNameText);
			animationNameText.setWidth(220);
			animationNameText.setX(centerX - 110);
			animationNameText.setY(395);
			
			playerButton = createButton("Play", 100, onPlayerButtonClick);
			editorButton = createButton("Edit", 100, onEditorButtonClick);
			
			playerButton.disable();
			editorButton.disable();
			
			DisplayObjectUtil.setX(playerButton.element, centerX - 110);
			DisplayObjectUtil.setY(playerButton.element, 430);
			DisplayObjectUtil.setX(editorButton.element, centerX + 10);
			DisplayObjectUtil.setY(editorButton.element, 430);
			
			GlobalState.listen(this, onAnimationNameStateChange, [GlobalState.animationName]);
		}
		
		private function createButton(_text : String, _width : Number, _clickHandler : Function) : UIButton {
			var button : MovieClip = MovieClipUtil.create(container, _text.split(" ").join("") + "Button");
			
			var text : TextElement = new TextElement(button, _text);
			text.setAlign(TextElement.ALIGN_CENTER); // Setting it left and then center is required to make this work, for some reason
			TextStyles.applyStartUpMenuButtonStyle(text);
			
			text.setWidth(_width);
			text.setY(10);
			text.setMouseEnabled(false);
			
			GraphicsUtil.beginFill(button, 0xFFFFFF);
			GraphicsUtil.drawRoundedRect(button, 0, 0, _width, 40, 10);
			
			var uiButton : UIButton = new UIButton(button);
			uiButton.disabledAlpha = 0.5;
			
			uiButton.onMouseClick.listen(this, _clickHandler);
			
			return uiButton;
		}
		
		private function onTheHandyConnectionKeyInputChange(_value : String) : void {
			onTheHandyConnectionKeyChange.emit(_value);
		}
		
		private function onBrowseButtonClick() : void {
			onBrowseSWF.emit();
		}
		
		private function onPlayerButtonClick() : void {
			onEnterPlayer.emit();
		}
		
		private function onEditorButtonClick() : void {
			onEnterEditor.emit();
		}
		
		private function onAnimationNameStateChange() : void {
			if (GlobalState.animationName.state != "") {
				var nameText : String = "Animation: " + GlobalState.animationName.state;
				
				if (GlobalState.animationName.state.length > 20) {
					nameText = "Animation: " + GlobalState.animationName.state.substring(0, 17) + "...";
				}
				
				animationNameText.setText(nameText);
				playerButton.enable();
				editorButton.enable();
			} else {
				animationNameText.setText("Animation: -");
				playerButton.disable();
				editorButton.disable();
			}
		}
	}
}