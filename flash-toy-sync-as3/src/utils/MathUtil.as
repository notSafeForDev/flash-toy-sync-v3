package utils {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MathUtil {
		
		/**
		 * Puts a value within a range
		 * @param	_value	The value to put in the range
		 * @param	_min	The minimum value
		 * @param	_max	The maximum value
		 * @return	The value inside the range
		 */
		public static function clamp(_value : Number, _min : Number, _max : Number) : Number {
			return Math.min(_max, Math.max(_min, _value));
		}
		
		/**
		 * Returns the value wrapped in a range
		 * 
		 * Example:
		 * value: 22, min: 0, max: 10 output: 2
		 * 
		 * @param	_value	The value to put within a range
		 * @param	_min	The minimum value in the range
		 * @param	_max	The maximum value in the range
		 * @return	The wrapped value
		 */
		public static function wrap(_value : Number, _min : Number, _max : Number) : Number {
			if (_min == _max) {
				return _min;
			}
			if (_min > _max) {
				throw new Error("Unable to calculate wrapped value, min must be greater or equal to max");
			}
			
			var range : Number = _max - _min;
			
			while (_value > _max) {
				_value -= range;
			}
			while (_value < _min) {
				_value += range;
			}
			
			return _value;
		}
		
		/**
		 * Interpolates a value between two values
		 * @param	_from		The value to use at 0 progress
		 * @param	_to			The value to use at 1 progress
		 * @param	_progress	The position between the values, can be outside of the range: 0 - 1
		 * @return	The interpolated value
		 */
		public static function lerp(_from : Number, _to : Number, _progress : Number) : Number {
			return _from + (_to - _from) * _progress;
		}
		
		/**
		 * Get the percentage of a value inside a range
		 * @param	_from	The value at 0%
		 * @param	_to		The value at 100%
		 * @param	_value	The value to check
		 * @return	The percentage, 1.0 for 100%
		 */
		public static function getPercentage(_value : Number, _from : Number, _to: Number) : Number {
			if (_value == _from) {
				return 0;
			}
			if (_from == _to) {
				throw new Error("Unable to calcuate percentage, both from and to values are the same");
			}
			
			return (_value - _from) / (_to - _from);
		}
		
		/**
		 * Get a point which have been rotated around an origin point, without modifying the original point
		 * @param	_point		The point to rate
		 * @param	_angle		The angle in degrees
		 * @param	_origin		The point to rotate around, if null is passed, it will use 0,0
		 * @return	A new rotated point
		 */
		public static function rotatePoint(_point : Point, _angle : Number, _origin : Point) : Point {
			_origin = _origin != null ? _origin : new Point();
			var radians : Number = _angle * (Math.PI / 180);
			var rotatedX : Number = Math.cos(radians) * (_point.x - _origin.x) - Math.sin(radians) * (_point.y - _origin.y) + _origin.x;
			var rotatedY : Number = Math.sin(radians) * (_point.x - _origin.x) + Math.cos(radians) * (_point.y - _origin.y) + _origin.y;
			return new Point(rotatedX, rotatedY);
		}
		
		/**
		 * Get the angle between two points in degrees
		 * @param	_pointA		The first point
		 * @param	_pointB		The second point
		 * @return	The angle in degrees
		 */
		public static function angleBetween(_pointA : Point, _pointB : Point) : Number {
			return Math.atan2(_pointB.y - _pointA.y, _pointB.x - _pointA.x) * 180 / Math.PI;
		}
		
		/**
		 * Get the distance between two points
		 * @param	_pointA		The first point
		 * @param	_pointB		The second point
		 * @return	The distance
		 */
		public static function distanceBetween(_pointA : Point, _pointB : Point) : Number {
			return _pointB.subtract(_pointA).length;
		}
		
		// TODO: Either keep and use this, or remove
		public static function reducePointsInPath(_points : Vector.<Point>, _angleThreshold : Number) : Vector.<Point> {
			if (_points.length <= 2) {
				return _points.slice();
			}
		
			var keepPoints : Vector.<Point> = new Vector.<Point>();
			keepPoints.push(_points[0]);
			
			var startPoint : Point = _points[0];
			var startAngle : Number = angleBetween(startPoint, _points[1]);
			var angleAfter : Number = angleBetween(startPoint, _points[2]);
			var startCurveDirection : Number = sign(deltaAngle(startAngle, angleAfter));
			
			for (var i : Number = 1; i < _points.length - 1; i++) {
				var currentAngle : Number = angleBetween(_points[i], _points[i + 1]);
				var previousAngle : Number = angleBetween(_points[i - 1], _points[i]);
				var startDeltaAngle : Number = deltaAngle(startAngle, currentAngle);
				var currentDeltaAngle : Number = deltaAngle(previousAngle, currentAngle);
				var curveDirection : Number = sign(currentDeltaAngle);
				
				if (Math.abs(startDeltaAngle) > _angleThreshold || Math.abs(currentDeltaAngle) > _angleThreshold || (startCurveDirection != 0 && curveDirection != 0 && curveDirection != startCurveDirection)) {
					startCurveDirection = sign(startDeltaAngle);
					startAngle = currentAngle;
					keepPoints.push(_points[i]);
				}
			}
			
			var lastPoint : Point = _points[_points.length - 1];
			var lastKeptPoint : Point = keepPoints[keepPoints.length - 1];
			
			if (lastPoint != lastKeptPoint) {
				keepPoints.push(lastPoint);
			}
			
			return keepPoints;
		}
		
		/**
		 * Can be used to calculate the distance of a point to the closest point along a line, which has an infinite length
		 * @param	_lineA		One point along the line, used as a reference for the line angle
		 * @param	_lineB		Another point along the line, used as a reference for the line angle
		 * @param	_point		The point to measure the distance to
		 * @return	A positive value for the distance
		 */
		public static function perpendicularDistance(_lineA : Point, _lineB : Point, _point : Point) : Number {
			var angle : Number = angleBetween(_lineA, _lineB);
			var rotatedPoint : Point = rotatePoint(_point, -angle, _lineA);
			return Math.abs(rotatedPoint.y - _lineA.y);
		}
		
		/**
		 * Calculate the difference between two angles, which can be both negative and positive
		 * @param	_from	The angle from
		 * @param	_to		The angle to
		 * @return	The angle between both angles
		 */
		public static function deltaAngle(_from : Number, _to : Number) : Number {
			return wrap(_to - _from, -180, 180);
		}
		
		/**
		 * Returns 1 for any positive value, -1 for any negative value and 0 for 0
		 * @param	_value
		 * @return
		 */
		public static function sign(_value : Number) : Number {
			if (_value > 0) {
				return 1;
			} else if (_value < 0) {
				return -1;
			}
			return 0;
		}
	}
}