package {
	
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	
	import core.VersionUtil;
	import core.DisplayObjectUtil;
	import core.StateManager;
	import core.Debug;
	import core.MovieClipUtil;
	import core.StageUtil;
	import core.MovieClipEvents;
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	import controllers.AnimationController;
	import controllers.ScriptingController;
	import controllers.HierarchyPanelController;
	import controllers.ToysController;
	
	import components.Borders;
	import components.ExternalSWF;
	import components.DebugPanel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Index {
		// Remove extra s later
		/* [Embed(source = "../assets/Monoid-Regular.ttf", fontName = "MonoidRegular", embedAsCFF = "false", mimeType="application/x-font")]
		private var monoidRegular : Classs;
		
		[Embed(source = "../assets/Monoid-Bold.ttf", fontName = "MonoidBold", embedAsCFF = "false", mimeType="application/x-font")]
		private var monoidBold : Classs; */
		
		private var globalStateManager : StateManager;
		private var globalState : GlobalState;
		
		private var container : MovieClip;
		private var animationContainer : MovieClip;
		private var overlayContainer : MovieClip;
		private var panelContainer : MovieClip;
		
		private var externalSWF : ExternalSWF;
		private var animation : MovieClip;
		
		private var borders : Borders;
		private var debugPanel : DebugPanel;
		
		private var animationController : AnimationController;
		private var hierarchyPanelController : HierarchyPanelController;
		private var scriptingController : ScriptingController;
		private var toysController : ToysController;
		
		public function Index(_container : MovieClip, _animationPath : String) {
			if (_container == null) {
				throw new Error("Unable construct Index, the container is not valid");
			}
			
			GlobalEvents.init();
			
			globalStateManager = new StateManager();
			globalState = new GlobalState(globalStateManager);
			
			container = _container;
			animationContainer = MovieClipUtil.create(_container, "animationContainer");
			borders = new Borders(_container, 0x000000);
			overlayContainer = MovieClipUtil.create(_container, "overlayContainer");
			panelContainer = MovieClipUtil.create(_container, "panelContainer");
			
			externalSWF = new ExternalSWF(_animationPath, animationContainer);
			externalSWF.onLoaded.listen(this, onSWFLoaded);
			externalSWF.onError.listen(this, onSWFError);
		}
		
		private function onSWFLoaded(_swf : MovieClip, _width : Number, _height : Number, _fps : Number) : void {
			if (VersionUtil.isActionscript3() == true) {
				StageUtil.setFrameRate(_fps);
			}
			
			animation = _swf;
			
			animationController = new AnimationController(globalState, panelContainer, animation, _width, _height);
			hierarchyPanelController = new HierarchyPanelController(globalState, panelContainer, animation);
			scriptingController = new ScriptingController(globalState, panelContainer, animation, overlayContainer);
			toysController = new ToysController(globalState, panelContainer);
			
			debugPanel = new DebugPanel(container);
			debugPanel.setPosition(700, 0);
			
			// We add the onEnterFrame listener on the container, instead of the animation, for better compatibility with AS2
			// As the contents of _swf can be replaced by the loaded swf file
			MovieClipEvents.addOnEnterFrame(this, container, onEnterFrame);
			
			// animation.gotoAndStop(256); // midna-3x-pleasure
		}
		
		public function onEnterFrame() : void {
			if (animation == null) {
				return;
			}
			
			var startTime : Number = Debug.getTime();
			
			animationController.onEnterFrame();
			scriptingController.onEnterFrame();
			
			globalStateManager.notifyListeners();
			GlobalEvents.enterFrame.emit();
			var endTime : Number = Debug.getTime();
			// trace(endTime - startTime);
			
			// For animations that hides the cursor, make it always visible
			// Later it should only work like this while in the editor
			Mouse.show();
		}
		
		private function onSWFError(_error : Error) : void {
			trace(_error);
		}
	}
}