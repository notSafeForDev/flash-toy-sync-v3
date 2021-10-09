package core {
	
	import core.stateTypes.ArrayState;
	import core.stateTypes.ArrayStateReference;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import core.stateTypes.BooleanState;
	import core.stateTypes.BooleanStateReference;
	import core.stateTypes.MovieClipState;
	import core.stateTypes.MovieClipStateReference;
	import core.stateTypes.NumberState;
	import core.stateTypes.NumberStateReference;
	import core.stateTypes.DisplayObjectState;
	import core.stateTypes.DisplayObjectStateReference;
	import core.stateTypes.PointState;
	import core.stateTypes.PointStateReference;
	
	/**
	 * Used to hold different states, with the ability to listen for changes to specific state changes
	 * 
	 * @author notSafeForDev
	 */
	public class StateManager {
		
		private var listeners : Array = [];
		private var states : Array;
		private var references : Array;
		private var lastNotificationStateValues : Array;
		
		/**
		 * Used to hold different states, with the ability to listen for changes to specific state changes
		 */
		public function StateManager() {
			states = [];
			references = [];
			lastNotificationStateValues = [];
			
			for (var i : int = 0; i < states.length; i++) {
				lastNotificationStateValues.push(undefined);
			}
		}
		
		/**
		 * Add a state that holds a Number
		 * @param	_default	The default value for the state
		 * @return	{state: NumberState, reference: NumberStateReference} - An object with the added state and reference
		 */
		public function addNumberState(_default : Number = 0) : Object {
			var state : NumberState = new NumberState(_default);
			var reference : NumberStateReference = new NumberStateReference(state);
			states.push(state);
			references.push(reference);
			return {state: state, reference: reference};
		}
		
		/**
		 * Add a state that holds a Boolean
		 * @param	_default	The default value for the state
		 * @return	{state: BooleanState, reference: BooleanStateReference} - An object with the added state and reference
		 */
		public function addBooleanState(_default : Boolean = false) : Object {
			var state : BooleanState = new BooleanState(_default);
			var reference : BooleanStateReference = new BooleanStateReference(state);
			states.push(state);
			references.push(reference);
			return {state: state, reference: reference};
		}
		
		/**
		 * Add a state that holds a Point
		 * @param	_default	The default value for the state
		 * @return	{state: PointState, reference: PointStateReference} - An object with the added state and reference
		 */
		public function addPointState(_default : Point = null) : Object {
			var state : PointState = new PointState(_default);
			var reference : PointStateReference = new PointStateReference(state);
			states.push(state);
			references.push(reference);
			return {state: state, reference: reference};
		}
		
		/**
		 * Add a state that holds a DisplayObject
		 * @param	_default	The default value for the state
		 * @return	{state: DisplayObjectState, reference: DisplayObjectStateReference} - An object with the added state and reference
		 */
		public function addDisplayObjectState(_default : DisplayObject = null) : Object {
			var state : DisplayObjectState = new DisplayObjectState(_default);
			var reference : DisplayObjectStateReference = new DisplayObjectStateReference(state);
			states.push(state);
			references.push(reference);
			return {state: state, reference: reference};
		}
		
		/**
		 * Add a state that holds a MovieClip
		 * @param	_default	The default value for the state
		 * @return	{state: MovieClipState, reference: MovieClipStateReference} - An object with the added state and reference
		 */
		public function addMovieClipState(_default : MovieClip = null) : Object {
			var state : MovieClipState = new MovieClipState(_default);
			var reference : MovieClipStateReference = new MovieClipStateReference(state);
			states.push(state);
			references.push(reference);
			return {state: state, reference: reference};
		}
		
		/**
		 * Add a state that holds an Array
		 * @param	_default	The default value for the state
		 * @return	{state: ArrayState, reference: ArrayStateReference} - An object with the added state and reference
		 */
		public function addArrayState(_default : Array = null) : Object {
			var state : ArrayState = new ArrayState(_default);
			var reference : ArrayStateReference = new ArrayStateReference(state);
			states.push(state);
			references.push(reference);
			return {state: state, reference: reference};
		}
		
		/**
		 * Calls a function when one of the states have been changed, if the provided references are an empty array, then it will call the function when any state have been changed
		 * @param	_scope				The scope for the function
		 * @param	_handler			The callback function
		 * @param	_statesReferences	An array of stateReferences
		 * @return An object representing the listener, which can be removed using stopListening
		 */
		public function listen(_scope : * , _handler : Function, _statesReferences : Array) : Object {
			for (var i : int = 0; i < _statesReferences.length; i++) {
				if (references.indexOf(_statesReferences[i]) < 0) {
					throw new Error("Unable to start listening for state changes, one of the states are not managed by this state manager");
				}
			}
			
			var listener : Object = {handler: _handler, stateReferences: _statesReferences}
			listeners.push(listener);
			return listener;
		}
		
		/**
		 * Removes a listener
		 * @param	_listener	An object representing the listener, returned by listen
		 */
		public function stopListening(_listener : Object) : void {
			var index : int = listeners.indexOf(_listener);
			if (index >= 0) {
				listeners.splice(index, 1);
			}
		}
		
		/**
		 * Triggers each listener's function if it provided at least one reference to a state that was changed, or no references
		 */
		public function notifyListeners() : void {
			var i : int = 0;
			var newStateValues : Array = getStateValues();
			var updatedStatesReferences : Array = [];
			
			for (i = 0; i < references.length; i++) {
				if (newStateValues[i] != lastNotificationStateValues[i]) {
					updatedStatesReferences.push(references[i]);
				}
			}
			
			lastNotificationStateValues = newStateValues;
			
			if (updatedStatesReferences.length > 0) {
				for (i = 0; i < listeners.length; i++) {
					notifyListener(listeners[i], updatedStatesReferences);
				}
			}
		}
		
		private function notifyListener(_listener : Object, _updatedStatesReferences : Array) : void {
			var shouldNotify : Boolean = _listener.stateReferences.length == 0;
			for (var i : Number = 0; i < _listener.stateReferences.length; i++) {
				if (_updatedStatesReferences.indexOf(_listener.stateReferences[i]) >= 0) {
					shouldNotify = true;
					break;
				}
			}
			
			if (shouldNotify == false) {
				return;
			}
			
			_listener.handler();
		}
		
		private function getStateValues() : Array {
			var values : Array = [];
			for (var i : int = 0; i < states.length; i++) {
				values.push(states[i].getState());
			}
			return values;
		}
	}
}