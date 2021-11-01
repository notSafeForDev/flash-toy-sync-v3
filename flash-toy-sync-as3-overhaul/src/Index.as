package {
	
	import components.KeyboardInput;
	import components.StateManager;
	import controllers.AnimationPlaybackController;
	import controllers.AnimationPlaybackEditorController;
	import controllers.AnimationSizeController;
	import controllers.HierarchyPanelController;
	import controllers.SaveDataController;
	import controllers.ScriptSampleMarkersEditorController;
	import controllers.ScriptTrackerMarkersEditorController;
	import controllers.StrokerToyController;
	import controllers.StrokerToyEditorController;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import states.AnimationInfoStates;
	import states.AnimationPlaybackStates;
	import states.AnimationSizeStates;
	import states.EditorStates;
	import states.HierarchyStates;
	import states.ScriptStates;
	import core.TPMovieClip;
	import core.TPStage;
	import ui.HierarchyPanel;
	import ui.MainMenu;
	import ui.ScenesPanel;
	import ui.TextElement;
	import ui.TextStyles;
	import visualComponents.Animation;
	import visualComponents.Borders;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Index {
		
		private var stateManager : StateManager;
		
		private var animationInfoStates : AnimationInfoStates;
		private var hierarchyStates : HierarchyStates;
		private var animationPlaybackStates : AnimationPlaybackStates;
		private var animationSizeStates : AnimationSizeStates;
		private var editorStates : EditorStates;
		private var scriptStates : ScriptStates;
		
		private var animationPlaybackController : AnimationPlaybackController;
		private var animationSizeController : AnimationSizeController;
		private var hierarchyPanelController : HierarchyPanelController;
		private var saveDataController : SaveDataController;
		private var scriptSampleMarkersEditorController : ScriptSampleMarkersEditorController;
		private var scriptTrackermarkersEditorController : ScriptTrackerMarkersEditorController;
		private var strokerToyController : StrokerToyController;
		private var strokerToyEditorController : StrokerToyEditorController;
		
		private var container : TPMovieClip;
		private var mainMenu : MainMenu;
		private var borders : Borders;
		private var animation : Animation;
		private var errorText : TextElement;
		private var fpsText : TextElement;
		
		private var hierarchyPanel : HierarchyPanel;
		private var scenesPanel : ScenesPanel;
		
		private var previousFrameRates : Vector.<Number>;
		
		public function Index(_container : MovieClip) {
			stateManager = new StateManager();
			
			container = new TPMovieClip(_container);
			
			previousFrameRates = new Vector.<Number>();
			
			TPStage.init(_container, 30);
			KeyboardInput.init(_container);
			
			initializeStates();
			
			addAnimation();
			addBorders();
			addPanels();
			addMainMenu();
			addErrorText();
			addFPSText();
			
			container.addEnterFrameListener(this, onEnterFrame);
		}
		
		private function onAnimationSelected(_name : String) : void {
			animationInfoStates._name.setValue(_name);
		}
		
		private function onAnimationLoaded(_swf : MovieClip, _stageWidth : Number, _stageHeight : Number, _frameRate : Number) : void {
			if (_stageWidth > 0 && _stageHeight > 0) {
				animationSizeStates._width.setValue(_stageWidth);
				animationSizeStates._height.setValue(_stageHeight);
			}
			
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
			borders = new Borders(container, 0xFF0000);
		}
		
		private function addPanels() : void {
			var panelsContainer : TPMovieClip = TPMovieClip.create(container, "panelsContainer");
			
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
			animationPlaybackStates = new AnimationPlaybackStates(stateManager);
			animationSizeStates = new AnimationSizeStates(stateManager);
			editorStates = new EditorStates(stateManager);
			scriptStates = new ScriptStates(stateManager);
		}
		
		private function initializeControllers() : void {
			if (EditorStates.isEditor.value == true) {
				animationPlaybackController = new AnimationPlaybackEditorController(animationPlaybackStates, hierarchyPanel, scenesPanel);
			} else {
				animationPlaybackController = new AnimationPlaybackController(animationPlaybackStates);
			}
			
			hierarchyPanelController = new HierarchyPanelController(hierarchyStates, hierarchyPanel);
			animationSizeController = new AnimationSizeController(animationSizeStates);
		}
		
		private function updateControllers() : void {
			hierarchyPanelController.update();
			animationSizeController.update();
			animationPlaybackController.update();
		}
	}
}