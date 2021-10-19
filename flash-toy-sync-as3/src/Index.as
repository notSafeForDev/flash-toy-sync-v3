package {
	
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	
	import core.GraphicsUtil;
	import core.DisplayObjectUtil;
	import core.TextElement;
	import core.VersionUtil;
	import core.Debug;
	import core.MovieClipUtil;
	import core.StageUtil;
	import core.MovieClipEvents;
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	import controllers.UserSettingsController;
	import controllers.AnimationScalingController;
	import controllers.ScriptMarkersController;
	import controllers.ScriptSampleMarkersController;
	import controllers.ScriptRecordingController;
	import controllers.HierarchyPanelController;
	import controllers.TheHandyController;
	import controllers.TheHandyEditorController;
	import controllers.ScenesController;
	import controllers.SceneScriptsController;
	import controllers.SaveDataController;
	
	import components.CustomStateManager;
	import components.Borders;
	import components.ExternalSWF;
	
	import ui.StartupMenu;
	import ui.SaveDataPanel;
	import ui.TextStyles;
	import ui.DebugPanel;
	import ui.ScenesPanel;
	import ui.ScriptingPanel;
	import ui.HierarchyPanel;
	import ui.ToyPanel;
	import ui.UIButton;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Index {
		private var globalStateManager : CustomStateManager;
		private var globalState : GlobalState;
		
		private var container : MovieClip;
		private var animationContainer : MovieClip;
		private var overlayContainer : MovieClip;
		private var panelContainer : MovieClip;
		
		private var externalSWF : ExternalSWF;
		private var externalSWFName : String;
		private var animation : MovieClip;
		
		private var prepareScriptButton : UIButton;
		
		private var startUpMenu : StartupMenu;
		
		private var borders : Borders;
		
		private var userSettingsController : UserSettingsController;
		private var scenesController : ScenesController;
		private var animationScalingController : AnimationScalingController;
		private var hierarchyPanelController : HierarchyPanelController;
		private var scriptSampleMarkersController : ScriptSampleMarkersController;
		private var scriptMarkersController : ScriptMarkersController;
		private var scriptRecordingController : ScriptRecordingController;
		private var saveDataController : SaveDataController;
		
		private var errorText : TextElement;
		
		public function Index(_container : MovieClip, _animationPath : String) {
			if (_container == null) {
				throw new Error("Unable construct Index, the container is not valid");
			}
			
			GlobalEvents.init();
			
			globalStateManager = new CustomStateManager();
			globalState = new GlobalState(globalStateManager);
			
			userSettingsController = new UserSettingsController(globalState);
			
			container = _container;
			animationContainer = MovieClipUtil.create(_container, "animationContainer");
			borders = new Borders(_container, 0x000000);
			overlayContainer = MovieClipUtil.create(_container, "overlayContainer");
			panelContainer = MovieClipUtil.create(_container, "panelContainer");
			
			externalSWF = new ExternalSWF(animationContainer);
			externalSWF.onLoaded.listen(this, onSWFLoaded);
			externalSWF.onError.listen(this, onSWFError);
			
			errorText = new TextElement(_container, "", TextElement.AUTO_SIZE_LEFT);
			errorText.setAutoSize(TextElement.AUTO_SIZE_CENTER);
			TextStyles.applyErrorStyle(errorText);
			errorText.setX(StageUtil.getWidth() / 2);
			errorText.setY(StageUtil.getHeight() - 90);
			errorText.setMouseEnabled(false);
			
			prepareScriptButton = createPrepareScriptButton();
			DisplayObjectUtil.setY(prepareScriptButton.element, StageUtil.getHeight() - 60);
			DisplayObjectUtil.setVisible(prepareScriptButton.element, false);
			
			startUpMenu = new StartupMenu(container);
			startUpMenu.onTheHandyConnectionKeyChange.listen(this, onStartUpMenuTheHandyConnectionKeyChange);
			startUpMenu.onBrowseSWF.listen(this, onStartUpMenuBrowseSWF);
			startUpMenu.onEnterPlayer.listen(this, onStartUpMenuEnterPlayer);
			startUpMenu.onEnterEditor.listen(this, onStartUpMenuEnterEditor);
			
			MovieClipEvents.addOnEnterFrame(this, container, onEnterFrame);
			
			GlobalState.listen(this, onToyErrorStateChange, [GlobalState.toyError]);
		}
		
		private function onStartUpMenuTheHandyConnectionKeyChange(_key : String) : void {
			globalState._theHandyConnectionKey.setState(_key);
		}
		
		private function onStartUpMenuBrowseSWF() : void {
			externalSWF.browse(this, onSWFSelected);
		}
		
		private function onStartUpMenuEnterPlayer() : void {
			globalState._isEditor.setState(false);
			externalSWF.load(GlobalState.animationName.state);
		}
		
		private function onStartUpMenuEnterEditor() : void {
			globalState._isEditor.setState(true);
			externalSWF.load(GlobalState.animationName.state);
		}
		
		private function onToyErrorStateChange() : void {		
			if (GlobalState.toyError.state != "") {
				errorText.setText("Toy error: " + GlobalState.toyError.state);
			} else {
				errorText.setText("");
			}
		}
		
		private function onSWFSelected(_name : String) : void {
			globalState._animationName.setState(_name);
		}
		
		private function onSWFLoaded(_swf : MovieClip, _width : Number, _height : Number, _fps : Number) : void {
			if (VersionUtil.isActionscript3() == true) {
				StageUtil.setFrameRate(_fps);
			}
			
			errorText.setText("");
			DisplayObjectUtil.setVisible(startUpMenu.container, false);
			
			animation = _swf;
			
			var toyPanel : ToyPanel = new ToyPanel(panelContainer);
			toyPanel.setPosition(1280 - 150, 550);
			DisplayObjectUtil.setVisible(toyPanel.container, false);
			
			var saveDataPanel : SaveDataPanel = new SaveDataPanel(panelContainer);
			saveDataPanel.setPosition(1280 - 150, 400);
			DisplayObjectUtil.setVisible(saveDataPanel.container, false);
			
			saveDataController = new SaveDataController(globalState, animation, saveDataPanel);
			scenesController = new ScenesController(globalState, animation);
			var sceneScriptsController : SceneScriptsController = new SceneScriptsController(globalState);
			
			if (GlobalState.isEditor.state == true) {
				var hierarchyPanel : HierarchyPanel = new HierarchyPanel(panelContainer, animation);
				hierarchyPanel.setPosition(0, 0);
				
				var scenesPanel : ScenesPanel = new ScenesPanel(panelContainer);
				scenesPanel.setPosition(0, 350);
				
				var scriptingPanel : ScriptingPanel = new ScriptingPanel(panelContainer);
				scriptingPanel.setPosition(1280 - 200, 0);
				
				var debugPanel : DebugPanel = new DebugPanel(panelContainer);
				debugPanel.setPosition(1280 - 200, 720 - 20);
				
				DisplayObjectUtil.setVisible(toyPanel.container, true);
				DisplayObjectUtil.setVisible(saveDataPanel.container, true);
				
				animationScalingController = new AnimationScalingController(globalState, animation, _width, _height);
				hierarchyPanelController = new HierarchyPanelController(globalState, hierarchyPanel, animation);
				scriptSampleMarkersController = new ScriptSampleMarkersController(globalState, animation, overlayContainer);
				scriptMarkersController = new ScriptMarkersController(globalState, scriptingPanel, animation, overlayContainer);
				scriptRecordingController = new ScriptRecordingController(globalState, scriptingPanel, scenesPanel, animation, overlayContainer);
				
				var theHandyEditorController : TheHandyEditorController = new TheHandyEditorController(globalState, prepareScriptButton, toyPanel);
			}
			
			if (GlobalState.isEditor.state == false) {
				var theHandyController : TheHandyController = new TheHandyController(globalState, prepareScriptButton);
			}
			
			// animation.gotoAndStop(256); // midna-3x-pleasure
		}
		
		public function onEnterFrame() : void {
			// var startTime : Number = Debug.getTime();
			if (animation != null) {
				scenesController.onEnterFrame();
				
				if (GlobalState.isEditor.state == true) {
					scriptSampleMarkersController.onEnterFrame();
					scriptMarkersController.onEnterFrame();
					scriptRecordingController.onEnterFrame();
				}
			}
			
			globalStateManager.notifyListeners();
			GlobalEvents.enterFrame.emit();
			// var endTime : Number = Debug.getTime();
			// trace(endTime - startTime);
			
			// For animations that hides the cursor, make it always visible while in the editor
			if (GlobalState.isEditor.state == true) {
				Mouse.show();
			}
		}
		
		private function onSWFError(_error : String) : void {
			var missingAnimationInfo : String = "The selected file doesn't appear to be in the animations folder";
			
			// AS3
			if (_error == "Error #2035" || _error.indexOf("URL Not Found") >= 0) {
				errorText.setText(missingAnimationInfo);
				return;
			}
			
			// AS2
			if (_error == "URLNotFound") {
				errorText.setText(missingAnimationInfo);
				return;
			}
			
			errorText.setText(_error);
		}
		
		private function createPrepareScriptButton() : UIButton {
			var width : Number = 220;
			
			var button : MovieClip = MovieClipUtil.create(container, "prepareScriptButton");
			DisplayObjectUtil.setX(button, StageUtil.getWidth() / 2 - width / 2);
			
			var text : TextElement = new TextElement(button, "Prepare Script");
			text.setAlign(TextElement.ALIGN_CENTER); // Setting it left and then center is required to make this work, for some reason
			TextStyles.applyStartUpMenuButtonStyle(text);
			
			text.setWidth(width);
			text.setY(10);
			text.setMouseEnabled(false);
			
			GraphicsUtil.beginFill(button, 0xFFFFFF);
			GraphicsUtil.drawRoundedRect(button, 0, 0, width, 40, 10);
			
			var uiButton : UIButton = new UIButton(button);
			uiButton.disabledAlpha = 0.5;
			
			return uiButton;
		}
	}
}