package core {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPObjectUtil {
		
		/**
		 * Check if an object has a property, for AS2 we check if it isn't undefined, meaning that valid properties should never be assigned as undefined
		 * @param	_object			The object to check the property on
		 * @param	_propertyName	The name of the property
		 * @return	Whether the property exists
		 */
		public static function hasOwnProperty(_object : Object, _propertyName : String) : Boolean {
			return _object.hasOwnProperty(_propertyName);
		}
	}
}