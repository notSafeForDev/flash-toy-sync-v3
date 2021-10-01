package core {
	
	public class ArrayUtil {
		
		public static function indexOf(_array : Array, _searchElement : *) : Number {
			return _array.indexOf(_searchElement);
		}
		
		public static function lastIndexOf(_array : Array, _searchElement : *) : Number {
			return _array.lastIndexOf(_searchElement);
		}
		
		public static function remove(_array : Array, _searchElement : *) : void {
			var index : Number = _array.indexOf(_searchElement);
			if (index >= 0) {
				_array.splice(index, 1);
			}
		}
	}
}