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
	import controllers.StrokerToyEditorController;
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
	import states.ScriptRecordingStates;
	import states.ScriptTrackerStates;
	import core.TPMovieClip;
	import core.TPStage;
	import ui.HierarchyPanel;
	import ui.MainMenu;
	import ui.ScenesPanel;
	import ui.TextElement;
	import ui.TextStyles;
	import visualComponents.Animation;
	import visualComponents.Borders;
	import visualComponents.StageElementHighlighter;
	
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
		
		private var animationSceneController : AnimationScenesController;
		private var animationSizeController : AnimationSizeController;
		private var hierarchyPanelController : HierarchyPanelController;
		private var saveDataController : SaveDataController;
		private var scriptTrackersController : ScriptTrackersController;
		private var scriptRecordingController : ScriptRecordingController;
		private var strokerToyController : StrokerToyController;
		private var strokerToyEditorController : StrokerToyEditorController;
		
		private var container : TPMovieClip;
		private var panelsContainer : TPMovieClip;
		private var sampleMarkersContainer : TPMovieClip;
		private var trackingMarkersContainer : TPMovieClip;
		private var mainMenu : MainMenu;
		private var borders : Borders;
		private var animation : Animation;
		private var errorText : TextElement;
		private var fpsText : TextElement;
		
		private var hierarchyPanel : HierarchyPanel;
		private var scenesPanel : ScenesPanel;
		
		private var previousFrameRates : Vector.<Number>;
		
		public function Index(_container : MovieClip) {
			enterFrameEvent = new CustomEvent();
			
			stateManager = new StateManager();
			
			container = new TPMovieClip(_container);
			
			previousFrameRates = new Vector.<Number>();
			
			TPStage.init(_container, 30);
			KeyboardInput.init(container);
			
			initializeStates();
			
			addAnimation();
			addBorders();
			addStageElementHighlighter();
			addSampleMarkersContainer();
			addTrackingMarkersContainer();
			addPanels();
			addMainMenu();
			addErrorText();
			addFPSText();
			
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
			
			initializeControllers();
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
			
			fpsText.text = "avg: " + average + "ms";
		}
		
		private function onMainMenuBrowseAnimation() : void {
			animation.browse(this, onAnimationSelected);
		}
		
		private function onMainMenuPlayAnimation() : void {
			animation.load(AnimationInfoStates.name.value);
		}
		
		private function onMainMenuEditAnimation() : void {
			animation.load(AnimationInfoStates.name.value);
			
			hierarchyPanel.show();
			scenesPanel.show();
			
			editorStates._isEditor.setValue(true);
		}
		
		private function addAnimation() : void {
			animation = new Animation(container);
			
			animation.loadedEvent.listen(this, onAnimationLoaded);
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
			
			hierarchyPanel.hide();
			scenesPanel.hide();
		}
		
		private function addMainMenu() : void {
			mainMenu = new MainMenu(container);
			
			mainMenu.browseAnimationEvent.listen(this, onMainMenuBrowseAnimation);
			mainMenu.playAnimationEvent.listen(this, onMainMenuPlayAnimation);
			mainMenu.editAnimationEvent.listen(this, onMainMenuEditAnimation);
		}
		
		private function addErrorText() : void {
			errorText = new TextElement(container, "");
			TextStyles.applyErrorStyle(errorText);
			
			var textFormat : TextFormat = errorText.getTextFormat();
			textFormat.align = TextElement.ALIGN_CENTER;
			errorText.setTextFormat(textFormat);
			
			errorText.element.y = TPStage.stageHeight - 80;
			errorText.element.width = TPStage.stageWidth;
		}
		
		private function addFPSText() : void {
			fpsText = new TextElement(container, "");
			TextStyles.applyErrorStyle(fpsText);
			fpsText.element.width = 200;
		}
		
		private function initializeStates() : void {
			animationInfoStates = new AnimationInfoStates(stateManager);
			hierarchyStates = new HierarchyStates(stateManager);
			animationSceneStates = new AnimationSceneStates(stateManager);
			animationSizeStates = new AnimationSizeStates(stateManager);
			editorStates = new EditorStates(stateManager);
			scriptTrackerStates = new ScriptTrackerStates(stateManager);
			scriptRecordingStates = new ScriptRecordingStates(stateManager);
		}
		
		private function initializeControllers() : void {
			if (EditorStates.isEditor.value == true) {
				animationSceneController = new AnimationScenesControllerEditor(animationSceneStates, hierarchyPanel, scenesPanel);
			} else {
				animationSceneController = new AnimationScenesController(animationSceneStates);
			}
			
			hierarchyPanelController = new HierarchyPanelController(hierarchyStates, hierarchyPanel);
			animationSizeController = new AnimationSizeController(animationSizeStates);
			scriptTrackersController = new ScriptTrackersController(scriptTrackerStates, trackingMarkersContainer);
			scriptRecordingController = new ScriptRecordingController(scriptRecordingStates, sampleMarkersContainer);
		}
		
		private function updateControllers() : void {
			hierarchyPanelController.update();
			animationSizeController.update();
			animationSceneController.update();
			scriptTrackersController.update();
			scriptRecordingController.update();
		}
	}
}