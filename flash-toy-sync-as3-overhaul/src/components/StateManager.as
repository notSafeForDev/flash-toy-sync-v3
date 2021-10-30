package components {
	
	// import flash.utils.getQualifiedSuperclassName;
	// import flash.utils.getQualifiedClassName;
	import stateTypes.State;
	import stateTypes.StateReference;
	import core.TPObjectUtil;
	import utils.ArrayUtil;
	import utils.ObjectUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StateManager {
		
		protected var listeners : Vector.<StateManagerListener>;
		protected var statesList : Vector.<State>;
		protected var references : Vector.<StateReference>;
		protected var lastNotificationStateValues : Vector.<*>;
		
		public function StateManager() {
			listeners = new Vector.<StateManagerListener>();
			statesList = new Vector.<State>();
			references = new Vector.<stateTypes.StateReference>();
			lastNotificationStateValues = new Vector.<*>();
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
		public function addState(_stateClass : Class, _defaultValue : * ) : * {
			// Works in AS3
			/* if (getQualifiedSuperclassName(_stateClass) != getQualifiedClassName(State)) {
				throw new Error("Unable to add state, the provided state class does not extend from State");
			} */
			
			var state : * = new _stateClass(_defaultValue);
			
			// The setValue method can not be part of the base class, as it's argument type would have to be * (any),
			// which could not be overriden, so it's required that setValue is added to each class that extends State,
			// in order to ensure that the state can not be assigned a different type than intended
			if (TPObjectUtil.hasOwnProperty(state, "setValue") == false) {
				throw new Error("Unable to add state, the provided state class does not have a setValue method");
			}
			
			// In case of type casting, such as a number being converted into a string, we want to make sure that
			// the provided default value matches the intended type exactly, to provent any potential issues
			state.setValue(_defaultValue);
			var raw : * = state.getRawValue();
			if (_defaultValue != null && _defaultValue != undefined && typeof raw != typeof _defaultValue) {
				throw new Error("Unable to add state, the type of the provided default value does not match the type for the state");
			}
			
			statesList.push(state);
			references.push(state.reference);
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
		public function listen(_scope : *, _stateChangeHandler : Function, _stateReferences : Array) : StateManagerListener {
			var stateRefrences : Vector.<StateReference> = new Vector.<StateReference>();
			
			for (var i : Number = 0; i < _stateReferences.length; i++) {
				if (ArrayUtil.includes(references, _stateReferences[i]) == false) {
					throw new Error("Unable to start listening for state changes, one of the states are not managed by this state manager");
				}
				stateRefrences.push(_stateReferences[i]);
			}
			
			var listener : StateManagerListener = new StateManagerListener(_scope, _stateChangeHandler, stateRefrences);
			
			listeners.push(listener);
			
			// We want to call the handler as soon as it starts listening, to make sure it's synced with the current state
			listener.handler.apply(listener.scope);
			
			return listener;
		}
		
		/**
		 * Removes an existing listener
		 * @param	_listener	An object representing the listener, returned by the listen method
		 */
		public function stopListening(_listener : StateManagerListener) : void {
			var index : Number = ArrayUtil.indexOf(listeners, _listener);
			if (index >= 0) {
				listeners.splice(index, 1);
			}
		}
		
		/**
		 * Triggers each listener's function if it provided at least one reference to a state that was changed, or no references
		 */
		public function notifyListeners() : void {
			var i : Number = 0;
			var newStateValues : Vector.<*> = getStateValues();
			var updatedStatesReferences : Vector.<StateReference> = new Vector.<StateReference>();
			
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
		
		private function notifyListener(_listener : StateManagerListener, _updatedStatesReferences : Vector.<StateReference>) : void {
			for (var i : Number = 0; i < _listener.references.length; i++) {
				if (ArrayUtil.indexOf(_updatedStatesReferences, _listener.references[i]) >= 0) {
					_listener.handler.apply(_listener.scope);
					break;
				}
			}
		}
		
		private function getStateValues() : Vector.<*> {
			var values : Vector.<*> = new Vector.<*>();
			for (var i : Number = 0; i < statesList.length; i++) {
				values.push(statesList[i].getRawValue());
			}
			return values;
		}
	}
}