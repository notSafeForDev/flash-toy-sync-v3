/**
 * ...
 * @author notSafeForDev
 */
class core.TranspiledTextField{
	
	public static function create(_parent : MovieClip) : TextField {
		return _parent.createTextField("TextField", _parent.getNextHighestDepth(), 0, 0, 100, 100);
	}
}