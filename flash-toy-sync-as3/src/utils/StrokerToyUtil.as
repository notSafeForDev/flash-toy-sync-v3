package utils {
	
	import api.StrokerToyScriptPosition;
	import core.TPStage;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StrokerToyUtil {
		
		public static function getMilisecondsAtFrame(_frame : Number) : Number {
			return Math.floor(_frame * 1000 / TPStage.frameRate);
		}
		
		public static function depthsToPositions(_depths : Vector.<Number>, _startTime : Number) : Vector.<StrokerToyScriptPosition> {
			var output : Vector.<StrokerToyScriptPosition> = new Vector.<StrokerToyScriptPosition>();
			var frameRate : Number = TPStage.frameRate;
			
			for (var i : Number = 0; i < _depths.length; i++) {
				var time : Number = _startTime + Math.floor(i * 1000 / frameRate);
				output.push(new StrokerToyScriptPosition(_depths[i], time));
			}
			
			return output;
		}
		
		public static function getRepeatedPositions(_positions : Vector.<StrokerToyScriptPosition>, _repeatCount : Number, _loopPadding : Number) : Vector.<StrokerToyScriptPosition> {
			var output : Vector.<StrokerToyScriptPosition> = new Vector.<StrokerToyScriptPosition>();
			
			var frameRate : Number = TPStage.frameRate;
			var singleFrameDuration : Number = getMilisecondsAtFrame(1);
			var scriptDuration : Number = (_positions[_positions.length - 1].time - _positions[0].time);
			
			scriptDuration += singleFrameDuration;
			
			for (var i : Number = 0; i < _repeatCount; i++) {
				var startTime : Number = i * (scriptDuration + _loopPadding);
				var loop : Vector.<StrokerToyScriptPosition> = offsetTimeForPositions(_positions, startTime);
				output = output.concat(loop);
			}
			
			return output;
		}
		
		public static function offsetTimeForPositions(_positions : Vector.<StrokerToyScriptPosition>, _offset : Number) : Vector.<StrokerToyScriptPosition> {
			var output : Vector.<StrokerToyScriptPosition> = new Vector.<StrokerToyScriptPosition>();
			
			for (var i : Number = 0; i < _positions.length; i++) {
				output.push(new StrokerToyScriptPosition(_positions[i].position, _positions[i].time + _offset));
			}
			
			return output;
		}
		
		public static function timeStretchPositions(_positions : Vector.<StrokerToyScriptPosition>, _stretchAmount : Number) : Vector.<StrokerToyScriptPosition> {
			var output : Vector.<StrokerToyScriptPosition> = new Vector.<StrokerToyScriptPosition>();
			if (_positions.length == 0) {
				return output;
			}
			
			var startTime : Number = _positions[0].time;
			
			for (var i : Number = 0; i < _positions.length; i++) {
				var elapsedTime : Number = _positions[i].time - startTime;
				var stretchedElapsedTime : Number = Math.round(elapsedTime * _stretchAmount);
				output.push(new StrokerToyScriptPosition(_positions[i].position, startTime + stretchedElapsedTime));
			}
			
			return output;
		}
		
		public static function reducePositions(_positions : Vector.<StrokerToyScriptPosition>) : Vector.<StrokerToyScriptPosition> {
			if (_positions.length <= 1) {
				return _positions.slice();
			}
			
			var reduced : Vector.<StrokerToyScriptPosition> = new Vector.<StrokerToyScriptPosition>();
			
			var minDistanceForDirectionChange : Number = 0.03;
			var minTimeUntilStatic : Number = 100;
			var minTimeBetweenMovingPositions : Number = 250;
			
			var strokeDirection : Number = 0;
			var currentPeakPosition : Number = _positions[0].position; // The highest/lowest position value depending on direction
			var currentPeakTime : Number = _positions[0].time;
			
			for (var i : Number = 1; i < _positions.length; i++) {
				var position : Number = _positions[i].position;
				var time : Number = _positions[i].time;
				var peakDistance : Number;
				
				if (i == _positions.length - 1) {
					reduced.push(new StrokerToyScriptPosition(position, time));
					continue;
				}
				
				if (strokeDirection == 0) {
					peakDistance = Math.abs(position - currentPeakPosition);
					
					if (peakDistance < minDistanceForDirectionChange) {
						currentPeakTime = time;
					} else {
						strokeDirection = MathUtil.sign(position - currentPeakPosition);
						reduced.push(new StrokerToyScriptPosition(currentPeakPosition, currentPeakTime));
					}
					continue;
				}
				
				if (strokeDirection != 0) {
					peakDistance = Math.abs(position - currentPeakPosition);
					
					var timeSincePeak : Number = time - currentPeakTime;
					var isSameDirection : Boolean = MathUtil.sign(position - currentPeakPosition) == strokeDirection;
					
					if (peakDistance < minDistanceForDirectionChange && timeSincePeak >= minTimeUntilStatic) {
						strokeDirection = 0;
						reduced.push(new StrokerToyScriptPosition(currentPeakPosition, currentPeakTime));
					} else if (isSameDirection === true) {
						currentPeakPosition = position;
						currentPeakTime = time;
						if (reduced.length > 0 && time > minTimeBetweenMovingPositions + reduced[reduced.length - 1].time) {
							reduced.push(new StrokerToyScriptPosition(currentPeakPosition, currentPeakTime));
						}
					} else if (isSameDirection === false && peakDistance >= minDistanceForDirectionChange) {
						strokeDirection = -strokeDirection;
						reduced.push(new StrokerToyScriptPosition(currentPeakPosition, currentPeakTime));
					}
				}
			}
			
			if (reduced[0].time != _positions[0].time) {
				reduced.unshift(new StrokerToyScriptPosition(_positions[0].position, _positions[0].time));
			}
			
			return reduced;
		}
		
		/**
		 * Reduces the positions from a script by keeping all extreme positions and limiting the number of positions between each set of extreme positions
		 * @param	_positions					The positions to reduce
		 * @param	_minTimeBetweenPositions	The minimum time between positions, used only for positions between each set of extreme positions
		 * @return
		 */
		public static function reducePositionsSimple(_positions : Vector.<StrokerToyScriptPosition>, _minTimeBetweenPositions : Number) : Vector.<StrokerToyScriptPosition> {
			if (_positions.length <= 2) {
				return _positions.slice();
			}
			
			var reduced : Vector.<StrokerToyScriptPosition> = new Vector.<StrokerToyScriptPosition>();
			var directionChangeIndexes : Vector.<Number> = new Vector.<Number>();
			var direction : Number = MathUtil.sign(_positions[1].position - _positions[0].position);
			var i : Number;
			
			directionChangeIndexes.push(0);
			
			for (i = 1; i < _positions.length - 1; i++) {
				var currentDirection : Number = MathUtil.sign(_positions[i + 1].position - _positions[i].position);
				if (currentDirection != direction) {
					direction = currentDirection;
					directionChangeIndexes.push(i);
				}
			}
			
			directionChangeIndexes.push(_positions.length - 1);
			
			for (i = 0; i < directionChangeIndexes.length - 1; i++) {
				var currentIndex : Number = directionChangeIndexes[i];
				var nextIndex : Number = directionChangeIndexes[i + 1];
				
				reduced.push(_positions[currentIndex]);
				
				var elapsed : Number = 0;
				for (var j : Number = currentIndex + 1; j < nextIndex; j++) {
					elapsed += Math.round(1000 / TPStage.frameRate); // TODO: Change TPStage.frameRate to sceneModel.frameRate, once that is changed
					var remaining : Number = Math.round(1000 / 30) * (nextIndex - j); // TODO: Change TPStage.frameRate to sceneModel.frameRate, once that is changed
					if (elapsed >= _minTimeBetweenPositions && remaining >= _minTimeBetweenPositions) {
						elapsed = 0;
					}
				}
			}
			
			reduced.push(_positions[_positions.length - 1]);
			
			return reduced;
		}
	}
}