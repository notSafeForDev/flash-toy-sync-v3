package core {
	
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getQualifiedClassName;
	
	import core.stateTypes.State;
	import core.stateTypes.StateReference;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StateManager {
		
		protected var listeners : Array;
		protected var states : Array;
		protected var references : Array;
		protected var lastNotificationStateValues : Array;
		
		public function StateManager() {
			listeners = [];
			states = [];
			references = [];
			lastNotificationStateValues = [];
		}
		
		/**
		 * Add a state of a specific type
		 * @param	_stateClass				The state class to use, must extend from the State class
		 * @param	_stateReferenceClass	The state reference class to use, must extend from the StateReference class
		 * @param	_defaultValue			The default value for the state
		 * 
		 * @example 
		 * var state : StringState = stateManager.addState(StringState, StringStateReference, "Some string");
		 * var reference : StringStateReference = state.reference;
		 * 
		 * @return	The instance of the state
		 */
		public function addState(_stateClass : Class, _stateReferenceClass : Class, _defaultValue : *) : * {	
			if (getQualifiedSuperclassName(_stateClass) != getQualifiedClassName(State)) {
				throw new Error("Unable to add state, the provided state class does not extend from State");
			}
			if (getQualifiedSuperclassName(_stateReferenceClass) != getQualifiedClassName(StateReference)) {
				throw new Error("Unable to add state, the provided stateReference class does not extend from StateReference");
			}
			
			var state : * = new _stateClass();
			var reference : * = new _stateReferenceClass(state);
			
			// The setValue method can not be part of the base class, as it's argument type would have to be * (any),
			// which could not be overriden, so it's required that setValue is added to each class that extends State,
			// in order to ensure that the state can not be assigned a different type than intended
			if (state.hasOwnProperty("setValue") == false) {
				throw new Error("Unable to add state, the provided state class does not have a setValue method");
			}
			
			// In case of type casting, such as a number being converted into a string, we want to make sure that
			// the provided default value matches the intended type exactly, to provent any potential issues
			state.setValue(_defaultValue);
			var raw : * = (state as State).getRawValue();
			if (_defaultValue != null && _defaultValue != undefined && typeof raw != typeof _defaultValue) {
				throw new Error("Unable to add state, the type of the provided default value is not valid for the state");
			}
			
			(state as State).reference = new _stateReferenceClass(state);
			states.push(state);
			references.push((state as State).reference);
			lastNotificationStateValues.push(_defaultValue);
			
			return state;
		}
		
		/**
		 * Calls a function when we notify the listeners, if at least one of the provided states have been changed
		 * If the provided references is an empty array, then it will call the function when any state have been changed
		 * @param	_scope				The scope for the function
		 * @param	_stateChangeHandler	The callback function
		 * @param	_statesReferences	An array of stateReferences
		 * @return An object representing the listener, which can be removed using the stopListening method
		 */
		public function listen(_scope : *, _stateChangeHandler : Function, _stateReferences : Array) : Object {
			for (var i : int = 0; i < _stateReferences.length; i++) {
				if (references.indexOf(_stateReferences[i]) < 0) {
					throw new Error("Unable to start listening for state changes, one of the states are not managed by this state manager");
				}
			}
			
			var listener : Object = {handler: _stateChangeHandler, stateReferences: _stateReferences}
			listeners.push(listener);
			
			// We want to call the handler as soon as it starts listening, to make sure it's synced with the current state
			listener.handler();
			
			return listener;
		}
		
		/**
		 * Removes an existing listener
		 * @param	_listener	An object representing the listener, returned by the listen method
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
			for (var i : int = 0; i < _listener.stateReferences.length; i++) {
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
				values.push(states[i].getRawValue());
			}
			return values;
		}
	}
}