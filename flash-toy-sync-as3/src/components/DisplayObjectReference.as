package components {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.DisplayObjectUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectReference {
		
		private var topParent : DisplayObjectContainer;
		private var object : DisplayObject;
		private var path : Array;
		private var originalParent : DisplayObjectContainer;
		private var depth : Number;
		private var bounds : Rectangle;
		private var inactiveForFrames : Number;
		
		public function DisplayObjectReference(_topParent : DisplayObjectContainer, _object : DisplayObject) {
			topParent = _topParent;
			object = _object;
			
			var parents : Array = DisplayObjectUtil.getParents(object);
			
			if (DisplayObjectUtil.isShape(object) == false) {
				path = DisplayObjectUtil.getChildPath(topParent, object);
			}
			
			originalParent = parents[0];
			depth = parents.length;
			bounds = DisplayObjectUtil.getBounds(object, originalParent);
		}
		
		public function update() : void {
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
			if (object == null) {
				return false;
			}
			
			var parents : Array = DisplayObjectUtil.getParents(object);
			return DisplayObjectUtil.getParent(object) != null && parents.length == depth;
		}
		
		private function handleParentLoss() : void {
			var children : Array = DisplayObjectUtil.getChildren(originalParent);
			var sizeThreshold : Number = 0.05;
			var positionThreshold : Number = 20;
			
			if (DisplayObjectUtil.isShape(object) == false) {
				var childFromPath : DisplayObject = DisplayObjectUtil.getChildFromPath(topParent, path);
				if (childFromPath != null) {
					object = childFromPath;
					bounds = DisplayObjectUtil.getBounds(childFromPath, originalParent);
					return;
				}
			}
			
			var replacement : DisplayObject = null;
			var replacementBoundDifferences : Number = -1;
			
			for (var i : Number = 0; i < children.length; i++) {
				var child : DisplayObject = children[i];
				var childBounds : Rectangle = DisplayObjectUtil.getBounds(child, originalParent);
				
				var boundDifferences : Number = 0;
				boundDifferences += Math.abs(bounds.width - childBounds.width);
				boundDifferences += Math.abs(bounds.height - childBounds.height);
				boundDifferences += Math.abs(bounds.x - childBounds.x);
				boundDifferences += Math.abs(bounds.y - childBounds.y);
				
				if (replacementBoundDifferences < 0 || boundDifferences < replacementBoundDifferences) {
					replacement = child;
					replacementBoundDifferences = boundDifferences;
				}
				
				// OLD
				/* var hasSimiliarWidth : Boolean = Math.abs(bounds.width - childBounds.width) <= bounds.width * sizeThreshold;
				var hasSimiliarHeight : Boolean = Math.abs(bounds.height - childBounds.height) <= bounds.height * sizeThreshold;
				var hasSimilarXPosition : Boolean = Math.abs(bounds.x - childBounds.x) <= positionThreshold
				var hasSimilarYPosition : Boolean = Math.abs(bounds.y - childBounds.y) <= positionThreshold;
				
				if (hasSimiliarWidth == true && hasSimiliarHeight == true && hasSimilarXPosition == true && hasSimilarYPosition == true) {
					object = child;
					bounds = childBounds;
					if (DisplayObjectUtil.isShape(object) == false && path == null) {
						path = DisplayObjectUtil.getChildPath(topParent, object);
					}
					break;
				} */
				// ^ OLD
			}
			
			if (replacement != null) {
				object = replacement;
				if (DisplayObjectUtil.isShape(replacement) == false && path == null) {
					path = DisplayObjectUtil.getChildPath(topParent, object);
				}
			}
			
		}
	}
}