package components {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.DisplayObjectUtil;
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectReference {
		
		private var object : DisplayObject;
		private var originalParent : DisplayObjectContainer;
		private var depth : Number;
		private var bounds : Rectangle;
		private var inactiveForFrames : Number;
		
		public function DisplayObjectReference(_object : DisplayObject) {
			object = _object;
			
			var parents : Array = DisplayObjectUtil.getParents(object);
			
			originalParent = parents[0];
			depth = parents.length;
			bounds = DisplayObjectUtil.getBounds(object, originalParent);
			
			GlobalState.listen(this, onCurrentFrameStateChange, [GlobalState.currentFrame]); // TODO: add stopListening function
		}
		
		public function getObject() : DisplayObject {
			return object;
		}
		
		public function getBounds(_targetCoordinateSpace : DisplayObject) : Rectangle {
			if (hasValidParent() == true) {
				return DisplayObjectUtil.getBounds(object, _targetCoordinateSpace);
			}
			
			var topLeft : Point = DisplayObjectUtil.localToGlobal(originalParent, bounds.x, bounds.y);
			var bottomRight : Point = DisplayObjectUtil.localToGlobal(originalParent, bounds.right, bounds.bottom);
			
			var targetTopLeft : Point = DisplayObjectUtil.globalToLocal(_targetCoordinateSpace, topLeft.x, topLeft.y);
			var targetBottomRight : Point = DisplayObjectUtil.globalToLocal(_targetCoordinateSpace, bottomRight.x, bottomRight.y);
			var targetWidth : Number = targetBottomRight.x - targetTopLeft.x;
			var targetHeight : Number = targetBottomRight.y - targetTopLeft.y;
			
			return new Rectangle(targetTopLeft.x, targetTopLeft.y, targetWidth, targetHeight);
		}
		
		private function hasValidParent() : Boolean {
			var parents : Array = DisplayObjectUtil.getParents(object);
			return DisplayObjectUtil.getParent(object) != null && parents.length == depth;
		}
		
		private function onCurrentFrameStateChange() : void {
			var parents : Array = DisplayObjectUtil.getParents(object);
			if (hasValidParent() == true) {
				bounds = DisplayObjectUtil.getBounds(object, originalParent);
			} else {
				handleParentLoss();
			}
			
			if (hasValidParent() == true) {
				inactiveForFrames = 0;
			} else {
				inactiveForFrames++;
			}
		}
		
		private function handleParentLoss() : void {
			var children : Array = DisplayObjectUtil.getChildren(originalParent);
			var sizeThreshold : Number = 0.05;
			var positionThreshold : Number = 20;
			
			for (var i : Number = 0; i < children.length; i++) {
				var child : DisplayObject = children[i];
				var childBounds : Rectangle = DisplayObjectUtil.getBounds(child, originalParent);
				
				var hasSimiliarWidth : Boolean = Math.abs(bounds.width - childBounds.width) <= bounds.width * sizeThreshold;
				var hasSimiliarHeight : Boolean = Math.abs(bounds.height - childBounds.height) <= bounds.height * sizeThreshold;
				var hasSimilarXPosition : Boolean = Math.abs(bounds.x - childBounds.x) <= positionThreshold
				var hasSimilarYPosition : Boolean = Math.abs(bounds.y - childBounds.y) <= positionThreshold;
				
				if (hasSimiliarWidth == true && hasSimiliarHeight == true && hasSimilarXPosition == true && hasSimilarYPosition == true) {
					object = child;
					bounds = childBounds;
					break;
				}
			}
		}
	}
}