package core {
	
	public class FunctionUtil {
		
		/**
		 * Required for porting AS3 to AS2
		 * @param	_scope		Instance of class
		 * @param	_function	The function to call
		 * @return	The bound function
		 */
		public static function bind(_scope : *, _function : Function) : Function {
			return _function;
		}
	}
}