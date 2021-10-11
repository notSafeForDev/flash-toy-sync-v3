package data {
	
	import core.DisplayObjectUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import core.MathUtil;
	
	import global.GlobalState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class MarkerSceneScriptData extends SceneScriptData {
		
		private var stimulationMarkerAttachedToPath : Array = null;
		private var baseMarkerAttachedToPath : Array = null;
		private var tipMarkerAttachedToPath : Array = null;
		
		private var stimulationMarkerPoint : Point = null;
		private var baseMarkerPoint : Point = null;
		private var tipMarkerPoint : Point = null;
		
		public function MarkerSceneScriptData(_topParent : MovieClip, _animationRootPath : Array, _stimulationPath : Array, _basePath : Array, _tipPath : Array, _stimulationPoint : Point, _basePoint : Point, _tipPoint : Point) {			
			stimulationMarkerAttachedToPath = _stimulationPath;
			baseMarkerAttachedToPath = _basePath;
			tipMarkerAttachedToPath = _tipPath;
			
			stimulationMarkerPoint = _stimulationPoint;
			baseMarkerPoint = _basePoint;
			tipMarkerPoint = _tipPoint;
			
			super(_topParent, _animationRootPath);
		}
		
		public static function fromGlobalState(_topParent : MovieClip) : MarkerSceneScriptData {
			var animationRootPath : Array = DisplayObjectUtil.getChildPath(_topParent, GlobalState.selectedChild.state);
			
			var stimulationPath : Array = DisplayObjectUtil.getChildPath(_topParent, GlobalState.stimulationMarkerAttachedTo.state);
			var basePath : Array = DisplayObjectUtil.getChildPath(_topParent, GlobalState.baseMarkerAttachedTo.state);
			var tipPath : Array = DisplayObjectUtil.getChildPath(_topParent, GlobalState.tipMarkerAttachedTo.state);
			
			var stimulationPoint : Point = GlobalState.stimulationMarkerPoint.state;
			var basePoint : Point = GlobalState.baseMarkerPoint.state;
			var tipPoint : Point = GlobalState.tipMarkerPoint.state;
			
			return new MarkerSceneScriptData(_topParent, animationRootPath, stimulationPath, basePath, tipPath, stimulationPoint, basePoint, tipPoint);
		}
		
		public override function updateRecording(_topParent : MovieClip, _depth : Number) : void {
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
			
			super.updateRecording(_topParent, depth);
		}
		
		private function getMarkerPosition(_attachedTo : DisplayObject, _point : Point) : Point {
			return DisplayObjectUtil.localToGlobal(_attachedTo, _point.x, _point.y);
		}
	}
}