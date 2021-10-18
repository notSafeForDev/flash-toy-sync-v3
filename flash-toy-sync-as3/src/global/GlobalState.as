package global {
	
	import components.stateTypes.SceneScriptState;
	import components.stateTypes.SceneScriptStateReference;
	import core.StageUtil;
	import core.stateTypes.ArrayState;
	import core.stateTypes.ArrayStateReference;
	import core.stateTypes.DisplayObjectState;
	import core.stateTypes.DisplayObjectStateReference;
	import core.stateTypes.PointState;
	import core.stateTypes.PointStateReference;
	import core.stateTypes.StringState;
	import core.stateTypes.StringStateReference;
	import core.stateTypes.BooleanState;
	import core.stateTypes.BooleanStateReference;
	import core.stateTypes.MovieClipState;
	import core.stateTypes.MovieClipStateReference;
	import core.stateTypes.NumberState;
	import core.stateTypes.NumberStateReference;
	
	import components.CustomStateManager;
	import components.stateTypes.SceneState;
	import components.stateTypes.SceneStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class GlobalState {
		
		private static var stateManager : CustomStateManager;
		
		// The actual states are only accessible on a single instance of GlobalState
		// They start with an underscore, as AS2 can't have more than one property with the same same, even if the accessor is different
		
		// The state references are available to all classes, where the state value is readonly,
		// This is to prevent other classes from interacting with the state in unintended ways
		
		/** If it's currently in the editor mode */
		public var _isEditor : BooleanState;
		public static var isEditor : BooleanStateReference;
		
		/** The name of the external swf */
		public var _animationName : StringState;
		public static var animationName : StringStateReference;
		
		/** The stage width for the external swf */
		public var _animationWidth : NumberState;
		public static var animationWidth : NumberStateReference;
		
		/** The stage height for the external swf */
		public var _animationHeight : NumberState;
		public static var animationHeight : NumberStateReference;
		
		/** The child that is currently selected */
		public var _selectedChild : MovieClipState;
		public static var selectedChild : MovieClipStateReference;
		
		/** The path to child that is currently selected */
		public var _selectedChildPath : ArrayState;
		public static var selectedChildPath : ArrayStateReference;
		
		/** The child that the user have clicked on */
		public var _clickedChild : DisplayObjectState;
		public static var clickedChild : DisplayObjectStateReference;

		/** The child that the stimulation marker is attached to */
		public var _stimulationMarkerAttachedTo : DisplayObjectState;
		public static var stimulationMarkerAttachedTo : DisplayObjectStateReference;
		
		/** The child that the base marker is attached to */
		public var _baseMarkerAttachedTo : DisplayObjectState;
		public static var baseMarkerAttachedTo : DisplayObjectStateReference;
		
		/** The child that the tip marker is attached to */
		public var _tipMarkerAttachedTo : DisplayObjectState;
		public static var tipMarkerAttachedTo : DisplayObjectStateReference;
		
		/** The local position inside the attached to object where the marker should be placed */
		public var _stimulationMarkerPoint : PointState;
		public static var stimulationMarkerPoint : PointStateReference;
		
		/** The local position inside the attached to object where the marker should be placed */
		public var _baseMarkerPoint : PointState;
		public static var baseMarkerPoint : PointStateReference;
		
		/** The local position inside the attached to object where the marker should be placed */
		public var _tipMarkerPoint : PointState;
		public static var tipMarkerPoint : PointStateReference;
		
		/** The current frame for the selected child */
		public var _currentFrame : NumberState;
		public static var currentFrame : NumberStateReference;
		
		/** If the selected child have been force stopped */
		public var _isForceStopped : BooleanState;
		public static var isForceStopped : BooleanStateReference;
		
		/** If the selected child is playing */
		public var _isPlaying : BooleanState;
		public static var isPlaying : BooleanStateReference;
		
		/** 
		 * The last frame the child was at which caused it to skip to another frame,
		 * which could have been caused by a gotoAndPlay/Stop on that frame or a button event.
		 * It could also be set as the last frame if it didn't stop at it 
		 */
		public var _skippedFromFrame : NumberState;
		public static var skippedFromFrame : NumberStateReference;
		
		/** The frame the child last skipped to, which will be set to 1 if it naturally goes from the last to the first frame */
		public var _skippedToFrame : NumberState;
		public static var skippedToFrame : NumberStateReference;
		
		/** The frame that the child last stopped at on it's own */
		public var _stoppedAtFrame : NumberState;
		public static var stoppedAtFrame : NumberStateReference;
		
		/** Children that can't be selected with the mouse */
		public var _disabledMouseSelectForChildren : ArrayState;
		public static var disabledMouseSelectForChildren : ArrayStateReference;
		
		/** Parts of words to use to filter out elements that can be clicked */
		public var _mouseSelectFilter : StringState;
		public static var mouseSelectFilter : StringStateReference;
		
		public var _scenes : ArrayState;
		public static var scenes : ArrayStateReference;
		
		public var _currentScene : SceneState;
		public static var currentScene : SceneStateReference;
		
		/** All the scripted scenes */
		public var _sceneScripts : ArrayState;
		public static var sceneScripts : ArrayStateReference;
		
		/** The current scripted scene */
		public var _currentSceneScript : SceneScriptState;
		public static var currentSceneScript : SceneScriptStateReference;
		
		/** The connection key for theHandy sex toy */
		public var _theHandyConnectionKey : StringState;
		public static var theHandyConnectionKey : StringStateReference;
		
		/** The status of the currently connected sex toy */
		public var _toyStatus : StringState;
		public static var toyStatus : StringStateReference;
		
		/** The error for the currently connected sex toy */
		public var _toyError : StringState;
		public static var toyError : StringStateReference;
		
		public function GlobalState(_stateManager : CustomStateManager) {
			if (GlobalState.stateManager != null) {
				throw "Unable to create a new instance of GlobalState, there can only be one instance of it";
			}
			
			GlobalState.stateManager = _stateManager;
			
			var added : Object;
			
			// isEditor
			added = _stateManager.addBooleanState(false);
			_isEditor = added.state;
			GlobalState.isEditor = added.reference;
			
			// animationName
			added = _stateManager.addStringState("");
			_animationName = added.state;
			GlobalState.animationName = added.reference;
			
			// animationWidth
			added = _stateManager.addNumberState(StageUtil.getWidth());
			_animationWidth = added.state;
			GlobalState.animationWidth = added.reference;
			
			// animationHeight
			added = _stateManager.addNumberState(StageUtil.getHeight());
			_animationHeight = added.state;
			GlobalState.animationHeight = added.reference;
			
			// selectedChild
			added = _stateManager.addMovieClipState(null);
			_selectedChild = added.state;
			GlobalState.selectedChild = added.reference;
			
			// selectedChildPath
			added = _stateManager.addArrayState(null);
			_selectedChildPath = added.state;
			GlobalState.selectedChildPath = added.reference;
			
			// clickedChild
			added = _stateManager.addDisplayObjectState(null);
			_clickedChild = added.state;
			GlobalState.clickedChild = added.reference;
			
			// stimulationMarkerAttachedTo
			added = _stateManager.addDisplayObjectState(null);
			_stimulationMarkerAttachedTo = added.state;
			GlobalState.stimulationMarkerAttachedTo = added.reference;
			
			// baseMarkerAttachedTo
			added = _stateManager.addDisplayObjectState(null);
			_baseMarkerAttachedTo = added.state;
			GlobalState.baseMarkerAttachedTo = added.reference;
			
			// tipMarkerAttachedTo
			added = _stateManager.addDisplayObjectState(null);
			_tipMarkerAttachedTo = added.state;
			GlobalState.tipMarkerAttachedTo = added.reference;
			
			// stimulationMarkerPoint
			added = _stateManager.addPointState(null);
			_stimulationMarkerPoint = added.state;
			GlobalState.stimulationMarkerPoint = added.reference;
			
			// baseMarkerPoint
			added = _stateManager.addPointState(null);
			_baseMarkerPoint = added.state;
			GlobalState.baseMarkerPoint = added.reference;
			
			// tipMarkerPoint
			added = _stateManager.addPointState(null);
			_tipMarkerPoint = added.state;
			GlobalState.tipMarkerPoint = added.reference;
			
			// currentFrame
			added = _stateManager.addNumberState(-1);
			_currentFrame = added.state;
			GlobalState.currentFrame = added.reference;
			
			// isForceStopped
			added = _stateManager.addBooleanState(false);
			_isForceStopped = added.state;
			GlobalState.isForceStopped = added.reference;
			
			// isPlaying
			added = _stateManager.addBooleanState(false);
			_isPlaying = added.state;
			GlobalState.isPlaying = added.reference;
			
			// skippedFromFrame
			added = _stateManager.addNumberState(-1);
			_skippedFromFrame = added.state;
			GlobalState.skippedFromFrame = added.reference;
			
			// skippedToFrame
			added = _stateManager.addNumberState(-1);
			_skippedToFrame = added.state;
			GlobalState.skippedToFrame = added.reference;
			
			// stoppedAtFrame
			added = _stateManager.addNumberState(-1);
			_stoppedAtFrame = added.state;
			GlobalState.stoppedAtFrame = added.reference;
			
			// disabledMouseSelectForChildren
			added = _stateManager.addArrayState([]);
			_disabledMouseSelectForChildren = added.state;
			GlobalState.disabledMouseSelectForChildren = added.reference;
			
			// mouseSelectFilter
			added = _stateManager.addStringState("");
			_mouseSelectFilter = added.state;
			GlobalState.mouseSelectFilter = added.reference;
			
			// scenes
			added = _stateManager.addArrayState([]);
			_scenes = added.state;
			GlobalState.scenes = added.reference;
			
			// currentScene
			added = _stateManager.addSceneState(null);
			_currentScene = added.state;
			GlobalState.currentScene = added.reference;
			
			// sceneScripts
			added = _stateManager.addArrayState([]);
			_sceneScripts = added.state;
			GlobalState.sceneScripts = added.reference;
			
			// currentSceneScript
			added = _stateManager.addSceneScriptState(null);
			_currentSceneScript = added.state;
			GlobalState.currentSceneScript = added.reference;
			
			// theHandyConnectionKey
			added = _stateManager.addStringState("");
			_theHandyConnectionKey = added.state;
			GlobalState.theHandyConnectionKey = added.reference;
			
			// toyStatus
			added = _stateManager.addStringState("");
			_toyStatus = added.state;
			GlobalState.toyStatus = added.reference;
			
			// toyError
			added = _stateManager.addStringState("");
			_toyError = added.state;
			GlobalState.toyError = added.reference;
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}