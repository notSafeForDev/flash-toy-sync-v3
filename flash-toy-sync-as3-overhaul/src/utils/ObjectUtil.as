package utils {
	
	import core.TPObjectUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ObjectUtil {
		
		public static function hasOwnProperty(_object : Object, _propertyName : String) : Boolean {
			return TPObjectUtil.hasOwnProperty(_object, _propertyName);
		}
	}
}