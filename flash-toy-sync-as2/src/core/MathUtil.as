class core.MathUtil {
	
	static function getPercentage(_value : Number, _from : Number, _to : Number) : Number {
		if (_value == _from) {
			return 0;
		}
		if (_from == _to) {
			throw "Unable to get percentage, both from and to values are the same";
		}
		
		return (_value - _from) / (_to - _from);
	}
	
	static function lerp(_from : Number, _to : Number, _progress : Number) : Number {
		return (1 - _progress) * _from + _progress * _to;
	}
}