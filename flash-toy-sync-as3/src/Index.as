package {
	
	import core.StageUtil;
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import core.Debug;
	import core.KeyboardManager;
	import core.MovieClipUtil;
	import core.MovieClipEvents;
	
	import components.HierarchyPanel;
	import components.ExternalSWF;
	import components.StageElementSelector;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Index {
		
		private var container : MovieClip;
		private var externalSWF : ExternalSWF;
		private var animation : MovieClip;
		private var stageElementSelector : StageElementSelector;
		private var animationContainer : MovieClip;
		private var stageElementSelectorOverlay : MovieClip;
		private var hierarchyPanel : HierarchyPanel;
		private var keyboardManager : KeyboardManager;
		
		public function Index(_container : MovieClip, _animationPath : String) {
			if (_container == null) {
				throw new Error("Unable construct Index, the container is not valid");
			}
			
			container = _container;
			animationContainer = MovieClipUtil.create(_container, "animationContainer");
			stageElementSelectorOverlay = MovieClipUtil.create(_container, "stageElementSelectorOverlay");
			
			keyboardManager = new KeyboardManager(container);
			
			externalSWF = new ExternalSWF(_animationPath, animationContainer);
			externalSWF.onLoaded.listen(this, onSWFLoaded);
			externalSWF.onError.listen(this, onSWFError);
		}
		
		private function onSWFLoaded(_swf : MovieClip, _width : Number, _height : Number, _fps : Number) : void {
			StageUtil.setFrameRate(_fps);
			
			animation = _swf;
			stageElementSelector = new StageElementSelector(_swf, stageElementSelectorOverlay);
			hierarchyPanel = new HierarchyPanel(container, _swf);
			hierarchyPanel.excludeChildrenWithoutNestedAnimations = true;
			
			if (externalSWF.isWidthSet() == false || externalSWF.isHeightSet() == false) {
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.RIGHT], onKeyboardShortcutDecreaseSWFWidth);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.LEFT], onKeyboardShortcutIncreaseSWFWidth);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.DOWN], onKeyboardShortcutDecreaseSWFHeight);
				keyboardManager.addShortcut(this, [Keyboard.S, Keyboard.UP], onKeyboardShortcutIncreaseSWFHeight);
			}
			
			// We add the onEnterFrame listener on the container, instead of the animation, for better compatibility with AS2
			// As the contents of _swf can be replaced by the loaded swf file
			MovieClipEvents.addOnEnterFrame(this, container, onEnterFrame);
		}
		
		private function onKeyboardShortcutDecreaseSWFWidth() : void {
			externalSWF.decreaseWidth(50);
		}
		
		private function onKeyboardShortcutIncreaseSWFWidth() : void {
			externalSWF.increaseWidth(50);
		}
		
		private function onKeyboardShortcutDecreaseSWFHeight() : void {
			externalSWF.decreaseHeight(50);
		}
		
		private function onKeyboardShortcutIncreaseSWFHeight() : void {
			externalSWF.increaseHeight(50);
		}
		
		private function onSWFError(_error : Error) : void {
			trace(_error);
		}
		
		private function onEnterFrame() : void {
			var startTime : Number = Debug.getTime();
			externalSWF.update();
			hierarchyPanel.update();
			var endTime : Number = Debug.getTime();
			// trace(endTime - startTime);
		}
	}
}