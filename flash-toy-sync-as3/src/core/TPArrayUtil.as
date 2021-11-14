package core {
	
	/**
	 * Provides array related functions for things that work differently in Actionscript 3.0 and 2.0
	 * 
	 * @author notSafeForDev
	 */
	public class TPArrayUtil {
		
		public static function indexOf(_array : *, _value : *, _fromIndex : Number = 0) : Number {
			return _array.indexOf(_value, _fromIndex);
		}
		
		public static function lastIndexOf(_array : *, _value : *, _fromIndex : Number = 0) : Number {
			return _array.lastIndexOf(_value, _fromIndex);
		}
	}
}