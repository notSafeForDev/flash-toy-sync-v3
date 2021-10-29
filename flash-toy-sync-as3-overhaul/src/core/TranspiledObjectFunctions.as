package core {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TranspiledObjectFunctions {
		
		/**
		 * Check if an object has a property, for AS2 we check if it isn't undefined, meaning that valid properties should never be assigned as undefined
		 * @param	_object			The object to check the property on
		 * @param	_propertyName	The name of the property
		 * @return	Whether the property exists
		 */
		public static function hasOwnProperty(_object : Object, _propertyName : String) : Boolean {
			return _object.hasOwnProperty(_propertyName);
		}
		
		/**
		 * Binds a scope to a function, most useful for AS2 where the scope isn't bound to the file, but from where the function was called
		 * @param	_scope		Instance of class
		 * @param	_function	The function to call
		 * @return	The bound function
		 */
		public static function bind(_scope : *, _function : Function, ...args) : Function {
			if (args.length == 0) {
				return _function;
			}
			return function(...args2) : void {
				_function.apply(_scope, args.concat(args2));
			}
		}
	}
}