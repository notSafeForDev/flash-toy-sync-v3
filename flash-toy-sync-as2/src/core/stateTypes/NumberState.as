import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.NumberState extends State {
	
	public function NumberState() {
		super();
	}
	
	public function setValue(_value : Number) : Void {
		value = _value;
	}
	
	public function getValue() : Number {
		return value;
	}
}