import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.BooleanState extends State {
	
	public function BooleanState() {
		super();
	}
	
	public function setValue(_value : Boolean) : Void {
		value = _value;
	}
	
	public function getValue() : Boolean {
		return value;
	}
}