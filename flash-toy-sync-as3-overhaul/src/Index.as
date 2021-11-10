package {
	
	import components.KeyboardInput;
	import components.StateManager;
	import controllers.AnimationScenesController;
	import controllers.AnimationScenesControllerEditor;
	import controllers.AnimationSizeController;
	import controllers.HierarchyPanelController;
	import controllers.SaveDataController;
	import controllers.ScriptRecordingController;
	import controllers.ScriptTrackersController;
	import controllers.StrokerToyController;
	import controllers.StrokerToyControllerEditor;
	import core.CustomEvent;
	import core.JSONLoader;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import states.AnimationInfoStates;
	import states.AnimationSceneStates;
	import states.AnimationSizeStates;
	import states.EditorStates;
	import states.HierarchyStates;
	import states.SaveDataStates;
	import states.ScriptRecordingStates;
	import states.ScriptTrackerStates;
	import core.TPMovieClip;
	import core.TPStage;
	import states.ToyStates;
	import ui.DialogueBox;
	import ui.HierarchyPanel;
	import ui.MainMenu;
	import ui.MenuBar;
	import ui.ScenesPanel;
	import ui.TextElement;
	import ui.TextStyles;
	import visualComponents.Animation;
	import visualComponents.Borders;
	import visualComponents.StageElementHighlighter;
	import visualComponents.StatusText;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Index {
		
		/** Emitted after all controllers have been updated and all state listeners have been notified */
		public static var enterFrameEvent : CustomEvent;
		
		private var stateManager : StateManager;
		
		private var animationInfoStates : AnimationInfoStates;
		private var hierarchyStates : HierarchyStates;
		private var animationSceneStates : AnimationSceneStates;
		private var animationSizeStates : AnimationSizeStates;
		private var editorStates : EditorStates;
		private var scriptTrackerStates : ScriptTrackerStates;
		private var scriptRecordingStates : ScriptRecordingStates;
		private var saveDataStates : SaveDataStates;
		private var toyStates : ToyStates;
		
		private var animationSceneController : AnimationScenesController;
		private var animationSizeController : AnimationSizeController;
		private var hierarchyPanelController : HierarchyPanelController;
		private var scriptTrackersController : ScriptTrackersController;
		private var scriptRecordingController : ScriptRecordingController;
		private var strokerToyController : StrokerToyController;
		private var saveDataController : SaveDataController;
		
		private var container : TPMovieClip;
		private var sampleMarkersContainer : TPMovieClip;
		private var trackingMarkersContainer : TPMovieClip;
		private var panelsContainer : TPMovieClip;
		private var mainMenu : MainMenu;
		private var borders : Borders;
		private var animation : Animation;
		private var statusText : StatusText;
		private var fpsText : TextElement;
		
		private var hierarchyPanel : HierarchyPanel;
		private var scenesPanel : ScenesPanel;
		
		private var previousFrameRates : Vector.<Number>;
		
		private var previousFrameTime : Number = 0;
		
		public function Index(_container : MovieClip) {
			enterFrameEvent = new CustomEvent();
			
			stateManager = new StateManager();
			
			container = new TPMovieClip(_container);
			
			previousFrameRates = new Vector.<Number>();
			
			TPStage.init(_container, 30);
			KeyboardInput.init(container);
			
			initializeStates();
			
			// This is intentionally initialized outside of initializeControllers, as it updates states which the main menu depends on
			saveDataController = new SaveDataController(saveDataStates, animationSizeStates, animationSceneStates, toyStates);
			
			addAnimation();
			addBorders();
			addStageElementHighlighter();
			addSampleMarkersContainer();
			addTrackingMarkersContainer();
			addPanels();
			addMainMenu();
			addStatusText();
			addFPSText();
			addMenuBar();
			
			DialogueBox.init(container);
			
			container.addEnterFrameListener(this, onEnterFrame);
			
			JSONLoader.load("flash-toy-sync-standalone.json", this, onStandaloneJSONLoaded);
		}
		
		private function onStandaloneJSONLoaded(_json : Object) : void {
			if (_json.swf != undefined) {
				animationInfoStates._name.setValue(_json.swf);
			}
			
			animationInfoStates._isStandalone.setValue(_json.swf != undefined);
		}
		
		private function onAnimationSelected(_name : String) : void {
			animationInfoStates._name.setValue(_name);
		}
		
		private function onAnimationLoaded(_swf : MovieClip, _stageWidth : Number, _stageHeight : Number, _frameRate : Number) : void {
			if (_stageWidth > 0 && _stageHeight > 0) {
				animationSizeStates._width.setValue(_stageWidth);
				animationSizeStates._height.setValue(_stageHeight);
			}
			
			animationSizeStates._isUsingInitialSize.setValue(true);
			
			animationInfoStates._animationRoot.setValue(new TPMovieClip(_swf));
			animationInfoStates._isLoaded.setValue(true);
			animationInfoStates._loadStatus.setValue("");
			
			if (EditorStates.isEditor.value == true) {
				panelsContainer.visible = true;
			}
			
			initializeControllers();
		}
		
		private function onAnimationLoadError(_error : String) : void {
			var missingAnimationStatus : String = "The selected file doesn't appear to be in the animations folder";
			
			// AS3
			if (_error == "Error #2035" || _error.indexOf("URL Not Found") >= 0) {
				animationInfoStates._loadStatus.setValue(missingAnimationStatus);
				return;
			}
			
			// AS2
			if (_error == "URLNotFound") {
				animationInfoStates._loadStatus.setValue(missingAnimationStatus);
				return;
			}
			
			animationInfoStates._loadStatus.setValue(_error);
		}
		
		private function onEnterFrame() : void {	
			var startTime : Number = getTimer();
			// TEMP ^
			
			if (AnimationInfoStates.isLoaded.value == true) {
				updateControllers();
			}
			
			stateManager.notifyListeners();
			
			if (EditorStates.isEditor.value == true) {
				Mouse.show();
			}
			
			enterFrameEvent.emit();
			
			// TEMP v
			previousFrameRates.push(getTimer() - startTime);
			if (previousFrameRates.length > 30) {
				previousFrameRates.shift();
			}
			
			var total : Number = 0; 
			for (var i : Number = 0; i < previousFrameRates.length; i++) {
				total += previousFrameRates[i];
			}
			var average : Number = Math.floor((total / previousFrameRates.length) * 10) / 10;
			var fps : Number = Math.ceil(1000 / Math.max(1, getTimer() - previousFrameTime));
			
			// fpsText.text = "avg: " + average + "ms";
			fpsText.text = "fps: " + fps;
			
			previousFrameTime = getTimer();
		}
		
		private function onMainMenuBrowseAnimation() : void {
			animation.browse(this, onAnimationSelected);
		}
		
		private function onMainMenuPlayAnimation() : void {
			animation.load(AnimationInfoStates.name.value);
		}
		
		private function onMainMenuEditAnimation() : void {
			animation.load(AnimationInfoStates.name.value);
			
			editorStates._isEditor.setValue(true);
		}
		
		private function onMainMenuTheHandyConnectionKeyChange(_key : String) : void {
			toyStates._theHandyConnectionKey.setValue(_key);
		}
		
		private function onMenuBarExit() : void {
			var theHandyConnectionKey : String = ToyStates.theHandyConnectionKey.value;
			
			// We set is loaded to false before resetting all states, to give controllers the chance to reset things based on the current states 
			animationInfoStates._isLoaded.setValue(false);
			
			animation.unload();
			stateManager.resetToInitialStates();
			panelsContainer.visible = false;
			
			toyStates._theHandyConnectionKey.setValue(theHandyConnectionKey);
		}
		
		private function onMenuBarShowKeyboardShortcuts() : void {
			
		}
		
		private function addAnimation() : void {
			animation = new Animation(container);
			
			animation.loadedEvent.listen(this, onAnimationLoaded);
			animation.loadErrorEvent.listen(this, onAnimationLoadError);
		}
		
		private function addBorders() : void {
			borders = new Borders(container, 0x000000);
		}
		
		private function addStageElementHighlighter() : void {
			var stageElementHighlighter : StageElementHighlighter = new StageElementHighlighter(container);
		}
		
		private function addSampleMarkersContainer() : void {
			sampleMarkersContainer = TPMovieClip.create(container, "sampleMarkersContainer");
		}
		
		private function addTrackingMarkersContainer() : void {
			trackingMarkersContainer = TPMovieClip.create(container, "trackingMarkersContainer");
		}
		
		private function addPanels() : void {
			panelsContainer = TPMovieClip.create(container, "panelsContainer");
			
			hierarchyPanel = new HierarchyPanel(panelsContainer, 240, 200);
			
			scenesPanel = new ScenesPanel(panelsContainer, 240, 120);
			scenesPanel.setPosition(0, 300);
			
			panelsContainer.visible = false;
		}
		
		private function addMainMenu() : void {
			mainMenu = new MainMenu(container);
			
			mainMenu.browseAnimationEvent.listen(this, onMainMenuBrowseAnimation);
			mainMenu.playAnimationEvent.listen(this, onMainMenuPlayAnimation);
			mainMenu.editAnimationEvent.listen(this, onMainMenuEditAnimation);
			mainMenu.theHandyConnectionKeyChangeEvent.listen(this, onMainMenuTheHandyConnectionKeyChange);
		}
		
		private function addStatusText() : void {
			statusText = new StatusText(container);
		}
		
		private function addFPSText() : void {
			fpsText = new TextElement(container, "");
			TextStyles.applyStatusStyle(fpsText);
			fpsText.element.width = 200;
		}
		
		private function addMenuBar() : void {
			var menuBar : MenuBar = new MenuBar(container);
			menuBar.exitEvent.listen(this, onMenuBarExit);
			menuBar.showKeyboardShortcutsEvent.listen(this, onMenuBarShowKeyboardShortcuts);
		}
		
		private function initializeStates() : void {
			animationInfoStates = new AnimationInfoStates(stateManager);
			hierarchyStates = new HierarchyStates(stateManager);
			animationSceneStates = new AnimationSceneStates(stateManager);
			animationSizeStates = new AnimationSizeStates(stateManager);
			editorStates = new EditorStates(stateManager);
			scriptTrackerStates = new ScriptTrackerStates(stateManager);
			scriptRecordingStates = new ScriptRecordingStates(stateManager);
			saveDataStates = new SaveDataStates(stateManager);
			toyStates = new ToyStates(stateManager);
		}
		
		private function initializeControllers() : void {
			if (EditorStates.isEditor.value == true) {
				animationSceneController = new AnimationScenesControllerEditor(animationSceneStates, hierarchyPanel, scenesPanel);
				hierarchyPanelController = new HierarchyPanelController(hierarchyStates, hierarchyPanel);
				animationSizeController = new AnimationSizeController(animationSizeStates);
				scriptTrackersController = new ScriptTrackersController(scriptTrackerStates, trackingMarkersContainer);
				scriptRecordingController = new ScriptRecordingController(scriptRecordingStates, sampleMarkersContainer);
			}
			
			if (EditorStates.isEditor.value == false) {
				animationSceneController = new AnimationScenesController(animationSceneStates);
			}
			
			if (EditorStates.isEditor.value == true) {
				strokerToyController = new StrokerToyControllerEditor(toyStates);
			} else {
				strokerToyController = new StrokerToyController(toyStates);
			}
		}
		
		private function updateControllers() : void {
			if (EditorStates.isEditor.value == true) {
				hierarchyPanelController.update();
				animationSizeController.update();
			}
			
			animationSceneController.update();
			
			if (EditorStates.isEditor.value == true) {
				scriptTrackersController.update();
				scriptRecordingController.update();
			}
		}
	}
}