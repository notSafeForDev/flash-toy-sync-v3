package {
	
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
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import states.AnimationInfoStates;
	import states.AnimationPlaybackStates;
	import states.AnimationSizeStates;
	import states.EditorStates;
	import states.ScriptStates;
	import core.TPMovieClip;
	import core.TPStage;
	import ui.HierarchyPanel;
	import ui.MainMenu;
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
		
		private var swf : MovieClip;
		
		private var hierarchyPanel : HierarchyPanel;
		
		private var previousFrameRates : Vector.<Number>;
		
		public function Index(_container : MovieClip) {
			stateManager = new StateManager();
			
			container = new TPMovieClip(_container);
			
			previousFrameRates = new Vector.<Number>();
			
			TPStage.init(_container, 30);
			KeyboardInput.init(_container);
			
			initializeStates();
			
			addAnimation(container);
			addBorders(container);
			addPanels(container);
			addMainMenu(container);
			addErrorText(container);
			addFPSText(container);
			
			initializeControllers();
			
			container.addOnEnterFrameListener(this, onEnterFrame);
		}
		
		private function onAnimationSelected(_name : String) : void {
			animationInfoStates._name.setValue(_name);
		}
		
		private function onAnimationLoaded(_swf : MovieClip, _stageWidth : Number, _stageHeight : Number, _frameRate : Number) : void {
			if (_stageWidth > 0 && _stageHeight > 0) {
				animationSizeStates._width.setValue(_stageWidth);
				animationSizeStates._height.setValue(_stageHeight);
			}
			
			animationInfoStates._movieClip.setValue(new TPMovieClip(_swf));
			animationInfoStates._isLoaded.setValue(true);
		}
		
		private function onEnterFrame() : void {
			updateControllers();
			
			stateManager.notifyListeners();
		}
		
		private function onMainMenuBrowseAnimation() : void {
			animation.browse(this, onAnimationSelected);
		}
		
		private function onMainMenuPlayAnimation() : void {
			animation.load(AnimationInfoStates.name.value);
		}
		
		private function addAnimation(_parent : TPMovieClip) : void {
			animation = new Animation(_parent);
			
			animation.loadedEvent.listen(this, onAnimationLoaded);
		}
		
		private function addBorders(_parent : TPMovieClip) : void {
			borders = new Borders(_parent, 0xFF0000);
		}
		
		private function addPanels(_parent : TPMovieClip) : void {
			var panelsContainer : TPMovieClip = TPMovieClip.create(container, "panelsContainer");
			
			hierarchyPanel = new HierarchyPanel(panelsContainer);
		}
		
		private function addMainMenu(_parent : TPMovieClip) : void {
			mainMenu = new MainMenu(_parent);
			
			mainMenu.browseAnimationEvent.listen(this, onMainMenuBrowseAnimation);
			mainMenu.playAnimationEvent.listen(this, onMainMenuPlayAnimation);
		}
		
		private function addErrorText(_parent : TPMovieClip) : void {
			errorText = new TextElement(_parent, "");
			TextStyles.applyErrorStyle(errorText);
			
			var textFormat : TextFormat = errorText.getTextFormat();
			textFormat.align = TextElement.ALIGN_CENTER;
			errorText.setTextFormat(textFormat);
			
			errorText.element.y = TPStage.stageHeight - 80;
			errorText.element.width = TPStage.stageWidth;
		}
		
		private function addFPSText(_parent : TPMovieClip) : void {
			fpsText = new TextElement(_parent, "");
			TextStyles.applyErrorStyle(fpsText);
			fpsText.element.width = 200;
		}
		
		private function initializeStates() : void {
			animationInfoStates = new AnimationInfoStates(stateManager);
			animationPlaybackStates = new AnimationPlaybackStates(stateManager);
			animationSizeStates = new AnimationSizeStates(stateManager);
			editorStates = new EditorStates(stateManager);
			scriptStates = new ScriptStates(stateManager);
		}
		
		private function initializeControllers() : void {
			animationPlaybackController = new AnimationPlaybackController(animationPlaybackStates);
			animationSizeController = new AnimationSizeController(animationSizeStates);
			hierarchyPanelController = new HierarchyPanelController(hierarchyPanel);
		}
		
		private function updateControllers() : void {
			var startTime : Number = getTimer();
			
			animationPlaybackController.update();
			animationSizeController.update();
			hierarchyPanelController.update();
			
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
	}
}