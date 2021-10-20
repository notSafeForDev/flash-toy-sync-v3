import core.stateTypes.State;

/**
 * ...
 * @author notSafeForDev
 */
class core.stateTypes.MovieClipState extends State {
	
	public function MovieClipState() {
		super();
	}
	
	public function setValue(_value : MovieClip) : Void {
		value = _value;
	}
	
	public function getValue() : MovieClip {
		return value;
	}
}