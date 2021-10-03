package core {
	
	public class ArrayUtil {
		
		public static function indexOf(_array : Array, _searchElement : *) : Number {
			return _array.indexOf(_searchElement);
		}
		
		public static function lastIndexOf(_array : Array, _searchElement : *) : Number {
			return _array.lastIndexOf(_searchElement);
		}
		
		/**
		 * Attemps to remove an element from an array
		 * @param	_array			The array to remove from
		 * @param	_searchElement	The element to remove
		 * @return 	Whether it was successful in removing the element or not
		 */
		public static function remove(_array : Array, _searchElement : *) : Boolean {
			var index : Number = _array.indexOf(_searchElement);
			if (index >= 0) {
				_array.splice(index, 1);
				return true;
			}
			return false;
		}
	}
}