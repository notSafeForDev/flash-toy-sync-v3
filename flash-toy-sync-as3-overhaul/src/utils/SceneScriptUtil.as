package utils {
	
	import utils.MathUtil;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptUtil {
		
		/**
		 * Calculate the "penetration" depth based on base, tip and stimulation positions
		 * @param	_base	The position on the screen where the base of the "penis" is
		 * @param	_tip	The position on the screen where the tip of the "penis" is
		 * @param	_stim	The position on the screen where the stimulation takes place on the "penis"
		 * @return	The calculated depth from 0 to 1 (clamped), 0 meaning at the base, 1 meaning at the tip
		 */
		public function caclulateDepth(_base : Point, _tip : Point, _stim : Point) : Number {
			var angle : Number = MathUtil.angleBetween(_base, _tip);
			
			// We rotate the tip and stimulation points so that the tip is directly to the right of the base, at the same y position
			var rotatedTip : Point = MathUtil.rotatePoint(_tip, -angle, _base);
			var rotatedStim : Point = MathUtil.rotatePoint(_stim, -angle, _base);
			
			// Then we check where along the x axis the rotated stimulation point is, and use that get the "penetration" depth
			var depth : Number = MathUtil.getPercentage(rotatedStim.x, rotatedTip.x, _base.x);
			depth = Math.floor(depth * 1000) / 1000; // Reduces the number of decimals to 3
			
			return MathUtil.clamp(depth, 0, 1);
		}
		
		/**
		 * Get the interpolated position at a specific index
		 * @param	_positions	The positions to interpolate between, must include at least one non null value
		 * @return
		 */
		public function getInterpolatedPosition(_positions : Vector.<Point>, _index : Number) : Number {
			if (_positions[_index] != null) {
				return _positions[_index];
			}
			
			var i : Number;
			
			var positionBefore : Point;
			var positionAfter : Point;
			
			var offsetBefore : Number;
			var offsetAfter : Number;
			
			for (i = 0; i < _positions.length; i++) {
				var indexBefore : Number = MathUtil.wrap(_index - i, 0, _positions.length - 1);
				if (_positions[indexBefore] == null) {
					continue;
				}
				
				positionBefore = _positions[indexBefore];
				offsetBefore = -i;
				break;
			}
			
			for (i = 0; i < _positions.length; i++) {
				var indexAfter : Number = MathUtil.wrap(_index + i, 0, _positions.length - 1);
				if (_positions[indexAfter] == null) {
					continue;
				}
				
				positionAfter = _positions[indexAfter];
				offsetAfter = i;
				break;
			}
			
			if (positionAfter == null) {
				throw new Error("Unable to get interpolated position, there are no valid positions");
			}
			
			var progress : Number = MathUtil.getPercentage(0, offsetBefore, offsetAfter);
			var interpolatedX : Number = MathUtil.lerp(positionBefore.x, positionAfter.x, progress);
			var interpolatedY : Number = MathUtil.lerp(positionBefore.y, positionAfter.y, progress);
			
			return new Point(interpolatedX, interpolatedY);
		}
	}
}