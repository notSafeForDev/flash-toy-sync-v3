package utils {
	
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Debug {
		
		private static var performanceMeasurements : Object = null;
		private static var lastPerformanceLogTime : Number = -1;
		
		public static function startMeasuringPerformance(_id : String) : void {
			if (performanceMeasurements == null) {
				performanceMeasurements = {};
			}
			
			performanceMeasurements[_id] = {
				startTime: getTimer(),
				samples: []
			}
		}
		
		public static function addMeasurementSample(_id : String, _label : String) : void {
			if (performanceMeasurements[_id] == undefined) {
				throw new Error("Unable to add measurement sample, no measurement have been started with the id: " + _id);
			}
			
			var samples : Array = performanceMeasurements[_id].samples;
			var lastSample : Object = samples.length > 0 ? samples[samples.length - 1] : undefined;
			var lastTime : Number = lastSample ? lastSample.time : performanceMeasurements[_id].startTime;
			
			samples.push({
				label: _label,
				time: getTimer(),
				elapsedTime: getTimer() - lastTime
			});
		}
		
		public static function logMeasurements(_id : String, _minTotalDuration : Number) : void {
			if (performanceMeasurements[_id] == undefined) {
				throw new Error("Unable to log measurements, no measurement have been started with the id: " + _id);
			}
			
			var totalElapsedTime : Number = getTimer() - performanceMeasurements[_id].startTime;
			if (totalElapsedTime < _minTotalDuration) {
				return;
			}
			
			var samples : Array = performanceMeasurements[_id].samples;
			var sampleWithHighestElapsedTime : Object = null;
			var parts : Array = [];
			
			for (var i : Number = 0; i < samples.length; i++) {
				if (samples[i].elapsedTime >= _minTotalDuration) {
					parts.push(samples[i].label + ": " + samples[i].elapsedTime + "ms");
				}
				if (sampleWithHighestElapsedTime == null || samples[i].elapsedTime > sampleWithHighestElapsedTime.elapsedTime) {
					sampleWithHighestElapsedTime = samples[i];
				}
			}
			
			if (parts.length == 0) {
				parts.push(sampleWithHighestElapsedTime.label + ": " + sampleWithHighestElapsedTime.elapsedTime + "ms");
			}
			
			var message : String = _id + " | " + parts.join(", ") + " | total: " + totalElapsedTime + "ms";
			trace(message);
			
			lastPerformanceLogTime = getTimer();
		}
	}
}