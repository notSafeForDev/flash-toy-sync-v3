package components {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import core.ArrayUtil;
	import core.DisplayObjectUtil;
	import core.MathUtil;
	
	import global.GlobalState;
	
	import components.Scene;
	import components.SceneScript;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MarkerSceneScript extends SceneScript {
		
		public static var sceneScriptType : String = "MARKER_SCENE_SCRIPT";
		
		public var stimulationPositions : Array;
		public var basePositions : Array;
		public var tipPositions : Array;
		
		public function MarkerSceneScript(_scene : Scene) {
			super(_scene);
			
			stimulationPositions = [];
			basePositions = [];
			tipPositions = [];
		}
		
		public static function asMarkerSceneScript(_sceneScript : SceneScript) : MarkerSceneScript {
			if (_sceneScript == null || _sceneScript.getType() != sceneScriptType) {
				return null;
			}
			
			var script : * = _sceneScript;
			return script;
		}
		
		public static function fromGlobalState(_topParent : MovieClip) : MarkerSceneScript {
			var currentScene : Scene = GlobalState.currentScene.state;
			var markerSceneScript : MarkerSceneScript = new MarkerSceneScript(currentScene);
			
			return markerSceneScript;
		}
		
		public override function getType() : String {
			return sceneScriptType;
		}
		
		public override function canRecord() : Boolean {
			var dependencies : Array = [
				GlobalState.stimulationMarkerAttachedTo.state,
				GlobalState.stimulationMarkerPoint.state,
				GlobalState.baseMarkerAttachedTo.state,
				GlobalState.baseMarkerPoint.state,
				GlobalState.tipMarkerAttachedTo.state,
				GlobalState.tipMarkerPoint.state
			];
			
			return ArrayUtil.indexOf(dependencies, null) < 0;
		}
		
		protected override function addBlankDataToBeginning() : void {
			stimulationPositions.unshift(new Point());
			basePositions.unshift(new Point());
			tipPositions.unshift(new Point());
			super.addBlankDataToBeginning();
		}
		
		protected override function addDataForCurrentFrame(_index : Number, _depth : Number) : void {
			var stimulation : Point = getMarkerPosition(GlobalState.stimulationMarkerAttachedTo.state, GlobalState.stimulationMarkerPoint.state);
			var base : Point = getMarkerPosition(GlobalState.baseMarkerAttachedTo.state, GlobalState.baseMarkerPoint.state);
			var tip : Point = getMarkerPosition(GlobalState.tipMarkerAttachedTo.state, GlobalState.tipMarkerPoint.state);
			
			var angle : Number = MathUtil.angleBetween(base, tip);
			
			// We rotate the tip and stimulation points so that the tip is to the right of the base, at the same y position
			var rotatedTip : Point = MathUtil.rotatePoint(tip, -angle, base);
			var rotatedStimulation : Point = MathUtil.rotatePoint(stimulation, -angle, base);
			
			// Then we check where along the x axis the rotated stimulation point is, and use that get the "penetration" depth
			var depth : Number = MathUtil.getPercentage(rotatedStimulation.x, rotatedTip.x, base.x);
			depth = MathUtil.clamp(depth, 0, 1);
			
			if (_index >= stimulationPositions.length) {
				stimulationPositions.push(stimulation);
				basePositions.push(base);
				tipPositions.push(tip);
			} else {
				stimulationPositions[_index] = stimulation;
				basePositions[_index] = base;
				tipPositions[_index] = tip;
			}
			
			super.addDataForCurrentFrame(_index, depth);
		}
		
		private function getMarkerPosition(_attachedTo : DisplayObject, _point : Point) : Point {
			return DisplayObjectUtil.localToGlobal(_attachedTo, _point.x, _point.y);
		}
	}
}