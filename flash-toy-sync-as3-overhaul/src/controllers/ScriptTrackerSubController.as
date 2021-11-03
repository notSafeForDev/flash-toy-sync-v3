package controllers {
	
	import components.DisplayObjectReference;
	import components.KeyboardInput;
	import core.CustomEvent;
	import core.TPDisplayObject;
	import flash.geom.Point;
	import stateTypes.PointState;
	import stateTypes.TPDisplayObjectState;
	import states.AnimationPlaybackStates;
	import states.ScriptStates;
	import ui.ScriptTrackerMarker;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptTrackerSubController {
		
		private var marker : ScriptTrackerMarker;
		private var attachedToState : TPDisplayObjectState;
		private var pointState : PointState;
		private var keyboardShortcut : Number;
		
		private var attachedToDisplayObjectReference : DisplayObjectReference;
		
		public function ScriptTrackerSubController(_marker : ScriptTrackerMarker, _attachedToState : TPDisplayObjectState, _pointState : PointState, _keyboardShortcut : Number) {
			marker = _marker;
			attachedToState = _attachedToState;
			pointState = _pointState;
			keyboardShortcut = _keyboardShortcut;
			
			marker.hide();
			marker.stopDragEvent.listen(this, onMarkerStopDrag);
			
			KeyboardInput.addShortcut([keyboardShortcut], this, onGrabMarkerShortcut, []);
			KeyboardInput.keyUpEvent.listen(this, onKeyUp);
		}
		
		public function update() : void {
			if (attachedToDisplayObjectReference != null) {
				attachedToDisplayObjectReference.update();
			}
			
			var point : Point = pointState.getValue();
			
			if (marker.isDragging() == false && attachedToState.getValue() != null && point != null) {
				var attachedTo : TPDisplayObject = attachedToState.getValue();
				var localPoint : Point = pointState.getValue();
				var globalPoint : Point = attachedTo.localToGlobal(localPoint);
				
				marker.setPosition(globalPoint.x, globalPoint.y);
			}
		}
		
		public function isDraggingMarker() : Boolean {
			return marker.isDragging();
		}
		
		public function getAttachedToStateValue() : TPDisplayObject {
			return attachedToState.getValue();
		}
		
		private function onGrabMarkerShortcut() : void {
			clearStates();
			clearAttachedToObjectReference();
			
			marker.moveToCursor();
			marker.startDrag();
			marker.show();
		}
		
		private function onKeyUp(_key : Number) : void {
			if (_key != keyboardShortcut || marker.isDragging() == false) {
				return;
			}
			
			marker.stopDrag();
			
			var attachedTo : TPDisplayObject = ScriptStates.childUnderDraggedMarker.value;
			if (attachedTo == null) {
				attachedTo = AnimationPlaybackStates.activeChild.value;
			}
			
			if (attachedTo == null || attachedTo.isRemoved() == true) {
				clearStates();
				clearAttachedToObjectReference();
				return;
			}
			
			var localPoint : Point = attachedTo.globalToLocal(marker.getPosition());
			
			attachedToState.setValue(attachedTo);
			pointState.setValue(localPoint);
			
			attachedToDisplayObjectReference = new DisplayObjectReference(attachedTo);
			attachedToDisplayObjectReference.objectUpdateEvent.listen(this, onAttachedToObjectUpdate);
			attachedToDisplayObjectReference.objectLossEvent.listen(this, onAttachedToObjectLoss);
			attachedToDisplayObjectReference.parentLossEvent.listen(this, onAttachedToParentLoss);
		}
		
		private function onMarkerStopDrag() : void {
			var attachedTo : TPDisplayObject = attachedToState.getValue();
			if (attachedTo == null) {
				return;
			}
			
			var markerPosition : Point = marker.getPosition();
			var localPoint : Point = attachedTo.globalToLocal(markerPosition);
			
			pointState.setValue(localPoint);
		}
		
		private function onAttachedToObjectUpdate() : void {
			attachedToState.setValue(attachedToDisplayObjectReference.getObject());
		}
		
		private function onAttachedToObjectLoss() : void {
			attachedToState.setValue(null);
		}
		
		private function onAttachedToParentLoss() : void {
			clearStates();
			clearAttachedToObjectReference();
			marker.hide();
		}
		
		private function clearStates() : void {
			attachedToState.setValue(null);
			pointState.setValue(null);
		}
		
		private function clearAttachedToObjectReference() : void {
			if (attachedToDisplayObjectReference != null) {
				attachedToDisplayObjectReference.destory();
				attachedToDisplayObjectReference = null;
			}
		}
	}
}