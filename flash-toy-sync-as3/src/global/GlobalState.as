package global {
	
	import core.ArrayUtil;
	import core.StageUtil;
	import core.stateTypes.BooleanState;
	import core.stateTypes.MovieClipState;
	import core.stateTypes.NumberState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class GlobalState {
		
		private static var listeners : Array = [];
		
		public static var animationWidth : NumberState;
		public static var animationHeight : NumberState;
		public static var selectedChild : MovieClipState;
		public static var selectedChildCurrentFrame : NumberState;
		public static var isForceStopped : BooleanState;
		
		private static var allStates : Array;
		private static var currentStateValues : Array;
		
		public static function init() : void {
			allStates = [
				animationWidth = new NumberState(StageUtil.getWidth()),
				animationHeight = new NumberState(StageUtil.getHeight()),
				selectedChild = new MovieClipState(null),
				selectedChildCurrentFrame = new NumberState( -1),
				isForceStopped = new BooleanState(false)
			];
			
			currentStateValues = [];
			for (var i : Number = 0; i < allStates.length; i++) {
				currentStateValues.push(undefined);
			}
		}
		
		private static function getStateValues() : Array {
			var values : Array = [];
			for (var i : Number = 0; i < allStates.length; i++) {
				values.push(allStates[i].getState());
			}
			return values;
		}
		
		public static function notifyListeners() : void {
			var i : Number = 0;
			var newStateValues : Array = getStateValues();
			var updatedStates : Array = [];
			
			// updatedStates includes either true or false at each index depending on if the state is different from last time
			for (i = 0; i < allStates.length; i++) {
				updatedStates.push(newStateValues[i] != currentStateValues[i]);
			}
			
			currentStateValues = newStateValues;
			
			// If it has any updated states, notify each listener
			if (ArrayUtil.indexOf(updatedStates, true) >= 0) {
				var snapshot : GlobalStateSnapshot = new GlobalStateSnapshot();
				for (i = 0; i < listeners.length; i++) {
					notifyListener(listeners[i], updatedStates, snapshot);
				}
			}
		}
		
		private static function notifyListener(_listener : Object, _updatedStates : Array, _snapshot : GlobalStateSnapshot) : void {
			var shouldNotify : Boolean = false;
			for (var i : Number = 0; i < _listener.stateIndexes.length; i++) {
				if (_updatedStates[_listener.stateIndexes[i]] == true) {
					shouldNotify = true;
					break;
				}
			}
			
			if (shouldNotify == false) {
				return;
			}
			
			_listener.handler.apply(_listener.scope, [_snapshot]);
		}
		
		public static function listen(_states : Array, _scope : * , _handler : Function) : Object {
			var stateIndexes : Array = [];
			for (var i : Number = 0; i < _states.length; i++) {
				stateIndexes.push(ArrayUtil.indexOf(allStates, _states[i]));
			}
			
			var listener : Object = {stateIndexes: stateIndexes, scope: _scope, handler: _handler}
			listeners.push(listener);
			return listener;
		}
		
		public static function stopListening(_listener : Object) : void {
			ArrayUtil.remove(listeners, _listener);
		}
	}
}