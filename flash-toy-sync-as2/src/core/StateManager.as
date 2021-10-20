import core.ArrayUtil;
/**
 * ...
 * @author notSafeForDev
 */
class core.StateManager {
	
	private var listeners : Array;
	private var states : Array;
	private var references : Array;
	private var lastNotificationStateValues : Array;
	
	public function StateManager() {
		listeners = [];
		states = [];
		references = [];
		lastNotificationStateValues = [];
	}
	
	public function addState(_stateClass, _stateReferenceClass, _defaultValue) {
		var state = new _stateClass();
		var reference = new _stateReferenceClass(state)
		
		state.setValue(_defaultValue);
		
		state.reference = new _stateReferenceClass(state);
		states.push(state);
		references.push(state.reference);
		lastNotificationStateValues.push(_defaultValue);
		
		return state;
	}
	
	public function listen(_scope, _stateChangeHandler : Function, _stateReferences : Array) : Object {
		for (var i : Number = 0; i < _stateReferences.length; i++) {
			if (ArrayUtil.indexOf(references, _stateReferences[i]) < 0) {
				throw new Error("Unable to start listening for state changes, one of the states are not managed by this state manager");
			}
		}
		
		var handler : Function = function() {
			_stateChangeHandler.apply(_scope);
		}
		
		var listener : Object = {handler: handler, stateReferences: _stateReferences}
		listeners.push(listener);
		
		listener.handler();
		
		return listener;
	}
	
	public function stopListening(_listener : Object) : Void {
		var index : Number = ArrayUtil.indexOf(listeners, _listener);
		if (index >= 0) {
			listeners.splice(index, 1);
		}
	}
	
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
	
	private function notifyListener(_listener : Object, _updatedStatesReferences : Array) : Void {
		var shouldNotify : Boolean = _listener.stateReferences.length == 0;
		for (var i : Number = 0; i < _listener.stateReferences.length; i++) {
			if (ArrayUtil.indexOf(_updatedStatesReferences, _listener.stateReferences[i]) >= 0) {
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
		for (var i : Number = 0; i < states.length; i++) {
			values.push(states[i].getRawValue());
		}
		return values;
	}
}