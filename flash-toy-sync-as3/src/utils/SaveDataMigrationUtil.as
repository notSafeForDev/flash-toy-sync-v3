package utils {
	
	import core.TPStage;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SaveDataMigrationUtil {
		
		public static var currentFormatVersion : Number = 3;
		
		public static function migrate(_saveData : Object) : Object {
			var migrators : Array = [version1To2, version2To3];
			
			var totalVersionsOutOfDate : Number = currentFormatVersion - _saveData.formatVersion;
			var currentSaveData : Object = JSON.parse(JSON.stringify(_saveData));
			
			for (var i : Number = migrators.length - totalVersionsOutOfDate; i < migrators.length; i++) {
				currentSaveData = migrators[i](currentSaveData);
			}
			
			return currentSaveData;
		}
		
		private static function version1To2(_saveData : Object) : Object {
			for (var i : Number = 0; i < _saveData.scenes.length; i++) {
				_saveData.scenes[i].endsAtLastFrame = false;
				_saveData.scenes[i].totalTimelineFrames = [];
				for (var j : Number = 0; j < _saveData.scenes[i].startFrames.length; j++) {
					_saveData.scenes[i].totalTimelineFrames.push(-1);
				}
			}
			
			return _saveData;
		}
		
		private static function version2To3(_saveData : Object) : Object {
			for (var i : Number = 0; i < _saveData.scenes.length; i++) {
				_saveData.scenes[i].frameRate = TPStage.frameRate;
			}
			
			return _saveData;
		}
	}
}