import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.ArrayState extends State {
	
	public function ArrayState() {
		super();
	}
	
	public function setValue(_value : Array) : Void {
		value = _value != null ? _value.slice() : null;
	}
	
	public function getValue() : Array {
		return value.slice();
	}
}