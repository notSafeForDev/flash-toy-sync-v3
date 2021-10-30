package utils {
	
	import core.TPArrayUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ArrayUtil {
		
		/**
		 * Get the index of a value in an array
		 * @param	_array			The array to search through
		 * @param	_searchElement	The value we are looking for
		 * @return
		 */
		public static function indexOf(_array : *, _searchElement : *) : Number {
			return TPArrayUtil.indexOf(_array, _searchElement);
		}
		
		/**
		 * Get the last index of a value in an array
		 * @param	_array			The array to search through
		 * @param	_searchElement	The value we are looking for
		 * @return
		 */
		public static function lastIndexOf(_array : *, _searchElement : *) : Number {
			return TPArrayUtil.lastIndexOf(_array, _searchElement);
		}
		
		/**
		 * Check if the array includes a value
		 * @param	_array			The array to search through
		 * @param	_searchElement	The value we are looking for
		 * @return
		 */
		public static function includes(_array : *, _searchElement : * ) : Boolean {
			return TPArrayUtil.indexOf(_array, _searchElement) >= 0;
		}
		
		/**
		 * Remove a value from an array
		 * @param	_array
		 * @param	_searchElement
		 * @return	Wether the element could be found and removed
		 */
		public static function remove(_array : *, _searchElement : *) : Boolean {
			var index : Number = TPArrayUtil.indexOf(_array, _searchElement);
			if (index >= 0) {
				_array.splice(index, 1);
				return true;
			}
			
			return false;
		}
	}
}