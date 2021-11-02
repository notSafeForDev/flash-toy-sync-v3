package models {
	
	import stateTypes.PointState;
	import stateTypes.TPDisplayObjectState;
	import visualComponents.ScriptTrackingMarker;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptTrackingMarkerModel {
		
		public var element : ScriptTrackingMarker;
		public var attachedToState : TPDisplayObjectState;
		public var pointState : PointState;
		
		public function ScriptTrackingMarkerModel(_element : ScriptTrackingMarker, _attachedToState : TPDisplayObjectState, _pointState : PointState) {
			element = _element;
			attachedToState = attachedToState;
			pointState = pointState;
		}
	}
}