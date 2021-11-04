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
	import utils.ArrayUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScriptTrackerSubController {
		
		/** Emitted when the marker is released without previously being attached to any object */
		public var initalAttachEvent : CustomEvent;
		
		private var marker : ScriptTrackerMarker;
		private var attachedToState : TPDisplayObjectState;
		private var pointState : PointState;
		private var keyboardShortcut : Array;
		
		private var attachedToDisplayObjectReference : DisplayObjectReference;
		
		public function ScriptTrackerSubController(_marker : ScriptTrackerMarker, _attachedToState : TPDisplayObjectState, _pointState : PointState, _keyboardShortcut : Array) {
			marker = _marker;
			attachedToState = _attachedToState;
			pointState = _pointState;
			keyboardShortcut = _keyboardShortcut;
			
			initalAttachEvent = new CustomEvent();
			
			marker.hide();
			marker.stopDragEvent.listen(this, onMarkerStopDrag);
			
			KeyboardInput.addShortcut(_keyboardShortcut, this, onGrabMarkerShortcut, []);
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
			if (marker.isDragging() == false || ArrayUtil.includes(keyboardShortcut, _key) == false) {
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
			
			initalAttachEvent.emit(attachedTo);
			
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