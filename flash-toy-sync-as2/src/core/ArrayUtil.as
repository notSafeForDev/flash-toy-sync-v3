class core.ArrayUtil {
	
	static function indexOf(_array : Array, _searchElement) : Number {
		for (var i : Number = 0; i < _array.length; i++) {
			if (_array[i] == _searchElement) {
				return i;
			}
		}
		
		return -1;
	}
	
	static function lastIndexOf(_array : Array, _searchElement) : Number {
		for (var i : Number = _array.length - 1; i >= 0; i--) {
			if (_array[i] == _searchElement) {
				return i;
			}
		}
		
		return -1;
	}
	
	static function remove(_array : Array, _searchElement) : Boolean {
		var index : Number = indexOf(_array, _searchElement);
		if (index >= 0) {
			_array.splice(index, 1);
			return true;
		}
		return false;
	}
}