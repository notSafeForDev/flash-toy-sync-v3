import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.DisplayObjectState extends State {
	
	public function DisplayObjectState() {
		super();
	}
	
	public function setValue(_value : MovieClip) : Void {
		value = _value;
	}
	
	public function getValue() : MovieClip {
		return value;
	}
}