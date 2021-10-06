package global {
	
	import core.ArrayUtil;
	import core.StageUtil;
	import core.StateManager;
	
	import core.stateTypes.BooleanState;
	import core.stateTypes.BooleanStateReference;
	import core.stateTypes.MovieClipState;
	import core.stateTypes.MovieClipStateReference;
	import core.stateTypes.NumberState;
	import core.stateTypes.NumberStateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class GlobalState {
		
		private static var stateManager : StateManager;
		
		// The actual states are only accessible on a single instance of GlobalState
		// They start with an underscore, as AS2 can't have more than one property with the same same, even if the accessor is different
		
		// The state references are available to all classes, where the state value is readonly,
		// This is to prevent other classes from interacting with the state in unintended ways
		
		/** The stage width for the external swf */
		public var _animationWidth : NumberState;
		public static var animationWidth : NumberStateReference;
		
		/** The stage height for the external swf */
		public var _animationHeight : NumberState;
		public static var animationHeight : NumberStateReference;
		
		/** The child that is curently selected */
		public var _selectedChild : MovieClipState;
		public static var selectedChild : MovieClipStateReference;
		
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
		
		public function GlobalState(_stateManager : StateManager) {
			if (GlobalState.stateManager != null) {
				throw "Unable to create a new instance of GlobalState, there can only be one instance of it";
			}
			
			GlobalState.stateManager = _stateManager;
			
			var added : Object;
			
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
		}
		
		public static function listen(_scope : * , _handler : Function, _stateReferences : Array) : void {
			stateManager.listen(_scope, _handler, _stateReferences);
		}
	}
}