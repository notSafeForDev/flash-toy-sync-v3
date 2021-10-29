/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import components.*
import core.JSON

// import flash.utils.getQualifiedSuperclassName;
// import flash.utils.getQualifiedClassName;
import stateTypes.State;
import stateTypes.StateReference;
import core.TranspiledObjectFunctions;
import utils.ArrayUtil;
import utils.ObjectUtil;

/**
 * ...
 * @author notSafeForDev
 */
class components.StateManager {
	
	public var listeners : Array;
	public var statesList : Array;
	public var references : Array;
	public var lastNotificationStateValues : Array;
	
	public function StateManager() {
		listeners = [];
		statesList = [];
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
	public function addState(_stateClass , _defaultValue  )  {
		// Works in AS3
		/* if (getQualifiedSuperclassName(_stateClass) != getQualifiedClassName(State)) {
			var returnValue; trace("Error: " + "Unable to add state, the provided state class does not extend from State"); return returnValue;
		} */
		
		var state  = new _stateClass(_defaultValue);
		
		// The setValue method can not be part of the base class, as it's argument type would have to be * (any),
		// which could not be overriden, so it's required that setValue is added to each class that extends State,
		// in order to ensure that the state can not be assigned a different type than intended
		if (ObjectUtil.hasOwnProperty(state, "setValue") == false) {
			var returnValue; trace("Error: " + "Unable to add state, the provided state class does not have a setValue method"); return returnValue;
		}
		
		// In case of type casting, such as a number being converted into a string, we want to make sure that
		// the provided default value matches the intended type exactly, to provent any potential issues
		state.setValue(_defaultValue);
		var raw  = state.getRawValue();
		if (_defaultValue != null && _defaultValue != undefined && typeof raw != typeof _defaultValue) {
			var returnValue; trace("Error: " + "Unable to add state, the type of the provided default value does not match the type for the state"); return returnValue;
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
	public function listen(_scope , _stateChangeHandler : Function, _stateReferences : Array) : StateManagerListener {
		var stateRefrences : Array = [];
		
		for (var i : Number = 0; i < _stateReferences.length; i++) {
			if (ArrayUtil.includes(references, _stateReferences[i]) == false) {
				var returnValue; trace("Error: " + "Unable to start listening for state changes, one of the states are not managed by this state manager"); return returnValue;
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
	public function stopListening(_listener : StateManagerListener) : Void {
		var index : Number = ArrayUtil.indexOf(listeners, _listener);
		if (index >= 0) {
			listeners.splice(index, 1);
		}
	}
	
	/**
	 * Triggers each listener's function if it provided at least one reference to a state that was changed, or no references
	 */
	public function notifyListeners() : Void {
		var i : Number = 0;
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
	
	private function notifyListener(_listener : StateManagerListener, _updatedStatesReferences : Array) : Void {
		for (var i : Number = 0; i < _listener.references.length; i++) {
			if (ArrayUtil.indexOf(_updatedStatesReferences, _listener.references[i]) >= 0) {
				_listener.handler.apply(_listener.scope);
				break;
			}
		}
	}
	
	private function getStateValues() : Array {
		var values : Array = [];
		for (var i : Number = 0; i < statesList.length; i++) {
			values.push(statesList[i].getRawValue());
		}
		return values;
	}
}