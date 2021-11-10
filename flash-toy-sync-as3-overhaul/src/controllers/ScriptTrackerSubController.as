package controllers {
	
	import components.DisplayObjectReference;
	import components.KeyboardInput;
	import core.CustomEvent;
	import core.TPDisplayObject;
	import flash.geom.Point;
	import models.SceneModel;
	import models.SceneScriptModel;
	import stateTypes.PointState;
	import stateTypes.TPDisplayObjectState;
	import states.AnimationInfoStates;
	import states.AnimationSceneStates;
	import states.EditorStates;
	import states.ScriptRecordingStates;
	import states.ScriptTrackerStates;
	import ui.ScriptTrackerMarker;
	import utils.ArrayUtil;
	import utils.MathUtil;
	
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
		private var globalPointState : PointState;
		private var keyboardShortcut : Array;
		
		private var isHoldingShortcut : Boolean;
		
		private var attachedToDisplayObjectReference : DisplayObjectReference;
		
		public function ScriptTrackerSubController(_marker : ScriptTrackerMarker, _attachedToState : TPDisplayObjectState, _pointState : PointState, _globalPointState : PointState, _keyboardShortcut : Array) {
			marker = _marker;
			attachedToState = _attachedToState;
			pointState = _pointState;
			globalPointState = _globalPointState;
			keyboardShortcut = _keyboardShortcut;
			
			initalAttachEvent = new CustomEvent();
			
			marker.hide();
			marker.stopDragEvent.listen(this, onMarkerStopDrag);
			
			KeyboardInput.addShortcut(_keyboardShortcut, this, onGrabMarkerShortcut, []);
			KeyboardInput.keyUpEvent.listen(this, onKeyUp);
			
			AnimationInfoStates.listen(this, onAnimationLoadedStateChange, [AnimationInfoStates.isLoaded]);
		}
		
		public function update() : void {
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			if (currentScene == null) {
				globalPointState.setValue(null);
				return;
			}
			
			if (attachedToDisplayObjectReference != null) {
				attachedToDisplayObjectReference.update();
			}

			var markerPosition : Point = marker.getPosition();
			
			var snapPoints : Vector.<Point> = new Vector.<Point>();
			
			if (marker.isDragging() == true) {
				snapPoints.push(ScriptRecordingStates.interpolatedBasePoint.value);
				snapPoints.push(ScriptRecordingStates.interpolatedStimPoint.value);
				snapPoints.push(ScriptRecordingStates.interpolatedTipPoint.value);
			}
			
			for (var i : Number = 0; i < snapPoints.length; i++) {
				if (snapPoints[i] == null) {
					continue;
				}
				
				var distance : Number = MathUtil.distanceBetween(markerPosition, snapPoints[i]);
				if (distance <= 3) {
					markerPosition = snapPoints[i];
					break;
				}
			}
			
			if (marker.isDragging() == true) {
				marker.setPosition(markerPosition.x, markerPosition.y);
			} else if (attachedToState.getValue() != null && pointState.getValue() != null) {
				var attachedTo : TPDisplayObject = attachedToState.getValue();
				var localPoint : Point = pointState.getValue();
				var globalPoint : Point = attachedTo.localToGlobal(localPoint);
				
				marker.setPosition(globalPoint.x, globalPoint.y);
			}
			
			globalPointState.setValue(marker.isVisible() ? marker.getPosition() : null);
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
			
			if (isHoldingShortcut == true || marker.isVisible() == false) {
				marker.moveToCursor();
				marker.startDrag();
				marker.show();
			} else {
				marker.hide();
			}
			
			isHoldingShortcut = true;
		}
		
		private function onKeyUp(_key : Number) : void {
			if (marker.isDragging() == false || ArrayUtil.includes(keyboardShortcut, _key) == false) {
				return;
			}
			
			isHoldingShortcut = false;
			
			marker.stopDrag();
			
			var attachedTo : TPDisplayObject = ScriptTrackerStates.childUnderDraggedMarker.value;
			if (attachedTo == null) {
				attachedTo = AnimationSceneStates.activeChild.value;
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
		
		private function onAnimationLoadedStateChange() : void {
			if (AnimationInfoStates.isLoaded.value == false) {
				marker.hide();
			}
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