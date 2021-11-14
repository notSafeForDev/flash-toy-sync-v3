/**
 * ...
 * @author notSafeForDev
 */
class core.TPObjectUtil{
	
	public static function hasOwnProperty(_object : Object, _propertyName : String) : Boolean {
		return _object[_propertyName] != undefined;
	}
}