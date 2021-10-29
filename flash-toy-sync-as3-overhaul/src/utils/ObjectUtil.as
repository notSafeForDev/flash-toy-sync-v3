package utils {
	
	import core.TranspiledObjectFunctions;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ObjectUtil {
		
		public static function hasOwnProperty(_object : Object, _propertyName : String) : Boolean {
			return TranspiledObjectFunctions.hasOwnProperty(_object, _propertyName);
		}
	}
}