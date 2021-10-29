package models {
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptModel {
		
		/** The screen position of the base of the "penis", on each frame in the scene */
		private var basePositions : Vector.<Point>;
		/** The screen position of the tip of the "penis", on each frame in the scene */
		private var tipPositions : Vector.<Point>;
		/** The screen position where the stimulation takes place on the "penis", on each frame in the scene */
		private var stimPositions : Vector.<Point>;
		
		/** The "penetration" depth on each frame in the scene */
		private var depths : Vector.<Number>;
		
		/** The scene this script is used for */
		private var scene : SceneModel;
		
		public function SceneScriptModel() {
			basePositions = new Vector.<Point>();
			tipPositions = new Vector.<Point>();
			stimPositions = new Vector.<Point>();
			
			depths = new Vector.<Number>();
		}
		
		public function clone() : SceneScriptModel {
			var cloned : SceneScriptModel = new SceneScriptModel();
			
			cloned.basePositions = basePositions.slice();
			cloned.tipPositions = tipPositions.slice();
			cloned.stimPositions = stimPositions.slice();
			cloned.depths = depths.slice();
			
			return cloned;
		}
	}
}