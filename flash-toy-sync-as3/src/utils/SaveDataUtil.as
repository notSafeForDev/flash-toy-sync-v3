package utils {
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SaveDataUtil {
		
		/**
		 * Convert an array of points into an array with a more compact format:
		 * Points are represented as arrays ([x,y])
		 * null are still represented as null
		 * Any repeated values after the first one are represented as a positive value for each additional repeated value
		 * 
		 * Input: [{x:0, y:0}, {x:1, y:1}, {x:1,y:1}, null, null, null, null]
		 * Output: [[0,0], [1,1], 1, null, 3]
		 * 
		 * @param	_points
		 * @return
		 */
		public static function convertPointsToSaveData(_points : Array) : Array {
			var saveData : Array = [];
			var duplicateCount : Number = 0;
			
			for (var i : Number = 0; i < _points.length; i++) {
				if (i > 0 && areDuplicatePoints(_points[i], _points[i - 1]) == true) {
					duplicateCount++;
					continue;
				}
				
				if (duplicateCount > 0) {
					saveData.push(duplicateCount);
					duplicateCount = 0;
				}
				
				saveData.push(convertPointToSavePoint(_points[i]));
			}
			
			if (duplicateCount > 0) {
				saveData.push(duplicateCount);
			}
			
			return saveData;
		}
		
		public static function getPointsFromSaveData(_saveData : Array) : Array {
			var points : Array = [];
			var lastAdded : Point = null;
			for (var i : Number = 0; i < _saveData.length; i++) {				
				if (typeof _saveData[i] == "number") {
					var repeatCount : Number = _saveData[i];
					for (var j : Number = 0; j < repeatCount; j++) {
						points.push(lastAdded == null ? null : lastAdded.clone());
					}
				} else {
					lastAdded = convertSavePointToPoint(_saveData[i]);
					points.push(lastAdded);
				}
			}
			return points;
		}
		
		private static function areDuplicatePoints(_a : Point, _b : Point) : Boolean {
			if (_a == null && _b == null) {
				return true;
			}
			if (_a == null || _b == null) {
				return false;
			}
			return _a.x == _b.x && _a.y == _b.y;
		}
		
		private static function convertPointToSavePoint(_point : Point) : Array {
			if (_point != null) {
				return [_point.x, _point.y];
			}
			return null;
		}
		
		private static function convertSavePointToPoint(_savePoint : Array) : Point {
			if (_savePoint != null) {
				return new Point(_savePoint[0], _savePoint[1]);
			}
			return null;
		}
	}
}