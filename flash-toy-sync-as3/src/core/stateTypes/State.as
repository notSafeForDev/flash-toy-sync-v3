/*
// When extending this class, the following function are intended to be added, replace the * (any) type with the type that the state is intended to store

// If the state stores a mutable object, this should return a copy of the value, to prevent the state from being altered unintentionally
public function getValue() : * {
	return value; // Boolean, Number, String, etc
	return value.slice(); // Array
	return JSON.parse(JSON.stringify(value)); // Object
}

public function setValue(_value : *) : void {
	value = _value; // Boolean, Number, String, etc
	value = _value.slice(); // Array
	value = JSON.parse(JSON.stringify(_value)); // Object
}
*/

package core.stateTypes {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class State {
		
		protected var value : *;
		
		/** The reference to the state, provides a read only way to read the state, extends StateReference */
		public var reference : *;
		
		public function State() {
			
		}
		
		/** 
		 * This returns the value, and in case of the state storing a mutable object, it returns the actual instance 
		 * This is used to determine if the state have changed 
		 */
		public function getRawValue() : * {
			return value;
		}
	}
}