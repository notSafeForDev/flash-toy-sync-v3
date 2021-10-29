/**
 * ...
 * @author notSafeForDev
 */
class core.TranspiledObjectFunctions{
	
	public static function hasOwnProperty(_object : Object, _propertyName : String) : Boolean {
		return _object[_propertyName] != undefined;
	}
}