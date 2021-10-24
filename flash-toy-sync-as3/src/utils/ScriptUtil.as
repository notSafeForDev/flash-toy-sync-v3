package utils {
	
	import components.SceneScript;
	import core.ArrayUtil;
	import core.StageUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptUtil {
		
		public static function getMilisecondsAtFrame(_frame : Number) : Number {
			return Math.floor(_frame * 1000 / StageUtil.getFrameRate());
		}
		
		public static function getDurationForSceneScript(_sceneScript : SceneScript) : Number {
			return Math.floor(_sceneScript.calculateDepths().length * 1000 / StageUtil.getFrameRate());
		}
		
		public static function depthsToScriptFormat(_depths : Array, _startTime : Number) : Array {
			var output : Array = [];
			var frameRate : Number = StageUtil.getFrameRate();
			
			for (var i : Number = 0; i < _depths.length; i++) {
				var time : Number = _startTime + Math.floor(i * 1000 / frameRate);
				var position : Number = 100 - Math.floor(_depths[i] * 100);
				output.push({time: time, position: position});
			}
			
			return output;
		}
		
		// This one is not used
		public static function reducePositionsInScript(_script : Array, _strength : Number) : Array {
			var direction : Number = 0;
			var output : Array = [];
			var i : Number;
			
			var directionChangeIndexes : Array = [0];
			
			for (i = 1; i < _script.length; i++) {
				var directionBefore : Number = direction;
				var position : Number = _script[i].position;
				var positionBefore : Number = _script[i - 1].position;
				
				if (position > positionBefore) {
					direction = 1;
				} else if (position < positionBefore) {
					direction = -1;
				} else {
					direction = 0;
				}
				
				if (directionBefore != direction && i > 1) {
					directionChangeIndexes.push(i - 1);
				}
			}
			
			directionChangeIndexes.push(_script.length - 1);
			
			for (i = 1; i < directionChangeIndexes.length; i++) {
				var fromIndex : Number = directionChangeIndexes[i - 1];
				var toIndex : Number = directionChangeIndexes[i];
				var scriptPart : Array = _script.slice(fromIndex, toIndex + 1);
				var reducedScriptPart : Array = reducePostionsInScriptPart(scriptPart, _strength);
				
				if (i < directionChangeIndexes.length - 1) {
					output = output.concat(reducedScriptPart.slice(0, reducedScriptPart.length - 1));
				} else {
					output = output.concat(reducedScriptPart);
				}
			}
			
			return output;
		}
		
		// This one is not used
		public static function  reducePostionsInScriptPart(_script : Array, _strength : Number) : Array {
			var velocityChangeThreshold : Number = _strength;
			var skipIndexes : Array = [];
			var velocities : Array = [];
			var maxVelocity : Number = 0;
			var output : Array = [];
			var i : Number;
			
			for (i = 1; i < _script.length; i++) {
				var duration : Number = Math.max(_script[i].time - _script[i - 1].time, 0.00001);
				var velocity : Number = Math.abs(_script[i].position - _script[i - 1].position) / duration;
				if (velocity > maxVelocity) {
					maxVelocity = velocity;
				}
				velocities.push(velocity);
			}
			
			var referenceVelocity : Number = velocities[0];
			for (i = 1; i < velocities.length; i++) {
				var velocityChange : Number = Math.abs(referenceVelocity - velocities[i]);
				if (velocityChange < maxVelocity * velocityChangeThreshold) {
					skipIndexes.push(i);
				} else {
					referenceVelocity = velocities[i];
				}
			}
			
			for (i = 0; i < _script.length; i++) {
				if (ArrayUtil.indexOf(skipIndexes, i) < 0) {
					output.push(_script[i]);
				}
			}
			
			return output;
		}
		
		public static function getLoopedScript(_script : Array, _loopCount : Number) : Array {
			var output : Array = [];
			
			var frameRate : Number = StageUtil.getFrameRate();
			var scriptDuration : Number = _script[_script.length - 1].time - _script[0].time;
			var loopPadding : Number = 1.5; // Used to make sync a bit better
			
			for (var i : Number = 0; i < _loopCount; i++) {
				var startTime : Number = i * scriptDuration + getMilisecondsAtFrame(i * loopPadding);
				var loop : Array = offsetTimeInScript(_script, startTime);
				if (i > 0) {
					loop = loop.slice(1);
				}
				output = output.concat(loop);
			}
			
			return output;
		}
		
		public static function offsetTimeInScript(_script : Array, _offset : Number) : Array {
			var output : Array = [];
			
			for (var i : Number = 0; i < _script.length; i++) {
				output.push({time: _script[i].time + _offset, position: _script[i].position});
			}
			
			return output;
		}
		
		public static function reduceKeyframes(keyframes : Array) : Array {
			if (keyframes.length == 0) {
				return [];
			}
			
			var reduced : Array = [];
			
			var minDistanceForDirectionChange : Number = 0.05;
			var minTimeUntilStatic : Number = 100;
			var minTimeBetweenMovingKeys : Number = 250;
			
			var strokeDirection : Number = 0;
			var currentPeakPosition : Number = keyframes[0].position; // The highest/lowest position value depending on direction
			var currentPeakTime : Number = keyframes[0].time;
			
			for (var i : Number = 1; i < keyframes.length; i++) {
				var position : Number = keyframes[i].position;
				var time : Number = keyframes[i].time;
				var peakDistance : Number;
				
				if (i == keyframes.length - 1) {
					reduced.push({position: position, time: time});
					continue;
				}
				
				if (strokeDirection == 0) {
					peakDistance = Math.abs(position - currentPeakPosition);
					
					if (peakDistance < minDistanceForDirectionChange) {
						currentPeakTime = time;
					} else {
						strokeDirection = sign(position - currentPeakPosition);
						reduced.push({position: currentPeakPosition, time: currentPeakTime});
					}
					continue;
				}
				
				if (strokeDirection != 0) {
					peakDistance = Math.abs(position - currentPeakPosition);
					
					var timeSincePeak : Number = time - currentPeakTime;
					var isSameDirection : Boolean = sign(position - currentPeakPosition) == strokeDirection;
					
					if (peakDistance < minDistanceForDirectionChange && timeSincePeak >= minTimeUntilStatic) {
						strokeDirection = 0;
						reduced.push({position: currentPeakPosition, time: currentPeakTime});
					} else if (isSameDirection === true) {
						currentPeakPosition = position;
						currentPeakTime = time;
						if (reduced.length > 0 && time > minTimeBetweenMovingKeys + reduced[reduced.length - 1].time) {
							reduced.push({position: currentPeakPosition, time: currentPeakTime});
						}
					} else if (isSameDirection === false && peakDistance >= minDistanceForDirectionChange) {
						strokeDirection = -strokeDirection;
						reduced.push({position: currentPeakPosition, time: currentPeakTime});
					}
				}
			}
			
			return reduced;
		}
		
		private static function sign(_value : Number) : Number {
			if (_value > 0) {
				return 1;
			}
			if (_value < 0) {
				return -1;
			}
			return 0;
		}
	}
}