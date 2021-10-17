package {
	
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	
	import core.VersionUtil;
	import core.Debug;
	import core.MovieClipUtil;
	import core.StageUtil;
	import core.MovieClipEvents;
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	import controllers.AnimationScalingController;
	import controllers.ScriptMarkersController;
	import controllers.ScriptSampleMarkersController;
	import controllers.ScriptRecordingController;
	import controllers.HierarchyPanelController;
	import controllers.TheHandyController;
	import controllers.ScenesController;
	
	import components.CustomStateManager;
	import components.Borders;
	import components.ExternalSWF;
	import components.DebugPanel;
	import components.ScenesPanel;
	import components.ScriptingPanel;
	import components.HierarchyPanel;
	import components.ToyPanel;
	
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
		private var animation : MovieClip;
		
		private var borders : Borders;
		
		private var scenesController : ScenesController;
		private var animationScalingController : AnimationScalingController;
		private var hierarchyPanelController : HierarchyPanelController;
		private var scriptSampleMarkersController : ScriptSampleMarkersController;
		private var scriptMarkersController : ScriptMarkersController;
		private var scriptRecordingController : ScriptRecordingController;
		private var theHandyController : TheHandyController;
		
		public function Index(_container : MovieClip, _animationPath : String) {
			if (_container == null) {
				throw new Error("Unable construct Index, the container is not valid");
			}
			
			GlobalEvents.init();
			
			globalStateManager = new CustomStateManager();
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
			
			var hierarchyPanel : HierarchyPanel = new HierarchyPanel(panelContainer, animation);
			hierarchyPanel.setPosition(0, 0);
			
			var scenesPanel : ScenesPanel = new ScenesPanel(panelContainer);
			scenesPanel.setPosition(0, 350);
			
			var toyPanel : ToyPanel = new ToyPanel(panelContainer);
			toyPanel.setPosition(1280 - 150, 500);
			
			var debugPanel : DebugPanel = new DebugPanel(panelContainer);
			debugPanel.setPosition(1280 - 200, 720 - 20);
			
			var scriptingPanel : ScriptingPanel = new ScriptingPanel(panelContainer);
			scriptingPanel.setPosition(1280 - 200, 0);
			
			scenesController = new ScenesController(globalState, animation);
			animationScalingController = new AnimationScalingController(globalState, animation, _width, _height);
			hierarchyPanelController = new HierarchyPanelController(globalState, hierarchyPanel, animation);
			scriptSampleMarkersController = new ScriptSampleMarkersController(globalState, animation, overlayContainer);
			scriptMarkersController = new ScriptMarkersController(globalState, scriptingPanel, animation, overlayContainer);
			scriptRecordingController = new ScriptRecordingController(globalState, scriptingPanel, scenesPanel, animation, overlayContainer);
			theHandyController = new TheHandyController(globalState, toyPanel);
			
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
			
			scenesController.onEnterFrame();
			scriptSampleMarkersController.onEnterFrame();
			scriptMarkersController.onEnterFrame();
			scriptRecordingController.onEnterFrame();
			
			globalStateManager.notifyListeners();
			GlobalEvents.enterFrame.emit();
			var endTime : Number = Debug.getTime();
			// trace(endTime - startTime);
			
			// For animations that hides the cursor, make it always visible
			// TODO: Only make it work like this while in the editor
			Mouse.show();
		}
		
		private function onSWFError(_error : Error) : void {
			trace(_error);
		}
	}
}