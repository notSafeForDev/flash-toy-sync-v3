import flash.geom.Point;

class core.MathUtil {
	
	public static function getPercentage(_value : Number, _from : Number, _to : Number) : Number {
		if (_value == _from) {
			return 0;
		}
		if (_from == _to) {
			throw "Unable to get percentage, both from and to values are the same";
		}
		
		return (_value - _from) / (_to - _from);
	}
	
	public static function lerp(_from : Number, _to : Number, _progress : Number) : Number {
		return (1 - _progress) * _from + _progress * _to;
	}
	
	public static function rotatePoint(_point : Point, _angle : Number, _origin : Point) : Point {
		_origin = _origin != undefined ? _origin : new Point();
		var radians : Number = _angle * (Math.PI / 180);
		var rotatedX : Number = Math.cos(radians) * (_point.x - _origin.x) - Math.sin(radians) * (_point.y - _origin.y) + _origin.x;
		var rotatedY : Number = Math.sin(radians) * (_point.x - _origin.x) + Math.cos(radians) * (_point.y - _origin.y) + _origin.y;
		return new Point(rotatedX, rotatedY);
	}
	
	public static function angleBetween(_pointA : Point, _pointB : Point) : Number {
		return Math.atan2(_pointB.y - _pointA.y, _pointB.x - _pointA.x) * 180 / Math.PI;
	}
	
	public static function clamp(_value : Number, _min : Number, _max : Number) : Number {
		return Math.min(_max, Math.max(_min, _value)); 
	}
}