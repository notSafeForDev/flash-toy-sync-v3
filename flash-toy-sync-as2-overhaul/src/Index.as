/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import core.JSON

import components.KeyboardInput;
import components.StateManager;
import controllers.AnimationPlaybackController;
import controllers.AnimationSizeController;
import controllers.HierarchyPanelController;
import controllers.SaveDataController;
import controllers.ScriptSampleMarkersEditorController;
import controllers.ScriptTrackerMarkersEditorController;
import controllers.StrokerToyController;
import controllers.StrokerToyEditorController;
import states.AnimationInfoStates;
import states.AnimationPlaybackStates;
import states.AnimationSizeStates;
import states.EditorStates;
import states.ScriptStates;
import core.TranspiledDisplayObjectEventFunctions;
import core.TranspiledMovieClip;
import core.TranspiledStage;
import ui.MainMenu;
import ui.TextElement;
import ui.TextStyles;
import visualComponents.Animation;
import visualComponents.Borders;

/**
 * ...
 * @author notSafeForDev
 */
class Index {
	
	private var stateManager : StateManager;
	
	private var animationInfoStates : AnimationInfoStates;
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
	
	private var container : TranspiledMovieClip;
	private var mainMenu : MainMenu;
	private var borders : Borders;
	private var animation : Animation;
	private var errorText : TextElement;
	
	public function Index(_container : MovieClip) {
		stateManager = new StateManager();
		
		container = new TranspiledMovieClip(_container);
		
		TranspiledStage.init(_container, 30);
		KeyboardInput.init(_container);
		
		initializeStates();
		initializeControllers();
		addVisualComponents();
		
		errorText.text = "A test error to see if the text works";
		
		TranspiledDisplayObjectEventFunctions.addEnterFrameEventListener(_container, this, onEnterFrame, null);
	}
	
	private function onAnimationSelected(_name : String) : Void {
		animationInfoStates._name.setValue(_name);
	}
	
	private function onAnimationLoaded(_swf : MovieClip, _stageWidth : Number, _stageHeight : Number, _frameRate : Number) : Void {
		if (_stageWidth > 0 && _stageHeight > 0) {
			animationSizeStates._width.setValue(_stageWidth);
			animationSizeStates._height.setValue(_stageHeight);
		}
		
		animationInfoStates._isLoaded.setValue(true);
	}
	
	private function onEnterFrame() : Void {
		updateControllers();
		
		stateManager.notifyListeners();
	}
	
	private function onMainMenuBrowseAnimation() : Void {
		animation.browse(this, onAnimationSelected);
	}
	
	private function onMainMenuPlayAnimation() : Void {
		animation.load(AnimationInfoStates.name.value);
	}
	
	private function addVisualComponents() : Void {
		addAnimation();
		addBorders();
		addMainMenu();
		addErrorText();
	}
	
	private function addAnimation() : Void {
		animation = new Animation(container.sourceMovieClip);
		
		animation.loadedEvent.listen(this, onAnimationLoaded);
	}
	
	private function addBorders() : Void {
		borders = new Borders(container.sourceMovieClip, 0xFF0000);
	}
	
	private function addMainMenu() : Void {
		mainMenu = new MainMenu(container.sourceMovieClip);
		
		mainMenu.browseAnimationEvent.listen(this, onMainMenuBrowseAnimation);
		mainMenu.playAnimationEvent.listen(this, onMainMenuPlayAnimation);
	}
	
	private function addErrorText() : Void {
		errorText = new TextElement(container.sourceMovieClip);
		TextStyles.applyErrorStyle(errorText);
		
		var errorTextTextFormat : TextFormat = errorText.getTextFormat();
		errorTextTextFormat.align = TextElement.ALIGN_CENTER;
		errorText.setTextFormat(errorTextTextFormat);
		
		errorText.element.y = TranspiledStage.stageHeight - 80;
		errorText.element.width = TranspiledStage.stageWidth;
	}
	
	private function initializeStates() : Void {
		animationInfoStates = new AnimationInfoStates(stateManager);
		animationPlaybackStates = new AnimationPlaybackStates(stateManager);
		animationSizeStates = new AnimationSizeStates(stateManager);
		editorStates = new EditorStates(stateManager);
		scriptStates = new ScriptStates(stateManager);
	}
	
	private function initializeControllers() : Void {
		animationPlaybackController = new AnimationPlaybackController(animationPlaybackStates);
		animationSizeController = new AnimationSizeController(animationSizeStates);
	}
	
	private function updateControllers() : Void {
		animationPlaybackController.update();
		animationSizeController.update();
	}
}