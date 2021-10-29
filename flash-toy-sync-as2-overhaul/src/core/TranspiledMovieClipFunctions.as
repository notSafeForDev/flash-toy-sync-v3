/**
 * ...
 * @author notSafeForDev
 */
class core.TranspiledMovieClipFunctions{
	
	public static function create(_parent : MovieClip, _name : String) : MovieClip {
		return _parent.createEmptyMovieClip(_name, _parent.getNextHighestDepth());
	}
}