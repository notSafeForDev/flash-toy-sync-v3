import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.StringState extends State {
	
	public function StringState() {
		super();
	}
	
	public function setValue(_value : String) : Void {
		value = _value;
	}
	
	public function getValue() : String {
		return value;
	}
}