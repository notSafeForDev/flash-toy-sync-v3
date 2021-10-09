package components {
	
	import core.CustomEvent;
	import core.DisplayObjectUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import global.GlobalState;
	
	import core.Fonts;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.TextElement;
	
	import global.GlobalEvents;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptMarkers {
		
		public var container : MovieClip;
		
		public var onMovedStimulationMarker : CustomEvent;
		public var onMovedBaseMarker : CustomEvent;
		public var onMovedTipMarker : CustomEvent;
		
		private var parent : MovieClip;
		
		private var stimulationMarker : ScriptMarker;
		private var baseMarker : ScriptMarker;
		private var tipMarker : ScriptMarker;
		
		public function ScriptMarkers(_parent : MovieClip) {
			parent = _parent;
			
			container = MovieClipUtil.create(_parent, "scriptMarkersContainer");
			
			onMovedStimulationMarker = new CustomEvent();
			onMovedBaseMarker = new CustomEvent();
			onMovedTipMarker = new CustomEvent();
			
			stimulationMarker = new ScriptMarker(container, 0xD99EC6, "STIM");
			baseMarker = new ScriptMarker(container, 0xA1D99E, "BASE");
			tipMarker = new ScriptMarker(container, 0x9ED0D9, "TIP");
			
			stimulationMarker.setVisible(false);
			baseMarker.setVisible(false);
			tipMarker.setVisible(false);
			
			stimulationMarker.onStopDrag.listen(this, onStopDragStimulationMarker);
			baseMarker.onStopDrag.listen(this, onStopDragBaseMarker);
			tipMarker.onStopDrag.listen(this, onStopDragTipMarker);
			
			GlobalEvents.enterFrame.listen(this, onEnterFrame);
		}
		
		private function onStopDragStimulationMarker() : void {
			var point : Point = DisplayObjectUtil.globalToLocal(GlobalState.stimulationMarkerAttachedTo.state, stimulationMarker.getX(), stimulationMarker.getY());
			onMovedStimulationMarker.emit(point);
		}
		
		private function onStopDragBaseMarker() : void {
			var point : Point = DisplayObjectUtil.globalToLocal(GlobalState.baseMarkerAttachedTo.state, baseMarker.getX(), baseMarker.getY());
			onMovedBaseMarker.emit(point);
		}
		
		private function onStopDragTipMarker() : void {
			var point : Point = DisplayObjectUtil.globalToLocal(GlobalState.tipMarkerAttachedTo.state, tipMarker.getX(), tipMarker.getY());
			onMovedTipMarker.emit(point);
		}
		
		private function onEnterFrame() : void {
			updateMarker(stimulationMarker, GlobalState.stimulationMarkerAttachedTo.state, GlobalState.stimulationMarkerPoint.state);
			updateMarker(baseMarker, GlobalState.baseMarkerAttachedTo.state, GlobalState.baseMarkerPoint.state);
			updateMarker(tipMarker, GlobalState.tipMarkerAttachedTo.state, GlobalState.tipMarkerPoint.state);
		}
		
		private function updateMarker(_marker : ScriptMarker, _attachedTo : DisplayObject, _point : Point) : void {
			if (_attachedTo == null) {
				_marker.setVisible(false);
				return;
			}
			
			_marker.setVisible(true);
			
			if (_marker.isDragging == true) {
				return;
			}
			
			var globalPoint : Point = DisplayObjectUtil.localToGlobal(_attachedTo, _point.x, _point.y);
			
			_marker.setX(globalPoint.x);
			_marker.setY(globalPoint.y);
		}
	}
}