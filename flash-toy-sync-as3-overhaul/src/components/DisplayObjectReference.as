package components {
	
	import core.CustomEvent;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import states.AnimationInfoStates;
	import utils.HierarchyUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DisplayObjectReference {
		
		/** Emitted when the previous display object was lost and a replacement was found */
		public var objectUpdateEvent : CustomEvent;
		
		/** Emitted when the previous display object was lost and no replacement could be found */
		public var objectLossEvent : CustomEvent;
		
		/** Emitted when the parent was lost, in which case no replacement will be possible to be found */
		public var parentLossEvent : CustomEvent;
		
		private var root : TPMovieClip;
		private var object : TPDisplayObject;
		private var path : Vector.<String>;
		private var originalParent : TPDisplayObject;
		private var parentsChainLength : Number;
		private var bounds : Rectangle;
		private var inactiveForFrames : Number;
		
		/**
		 * Class used to keep track of an object, which attempts to replace the object if it's removed from the the display list
		 * @param	_object		The original object
		 */
		public function DisplayObjectReference(_object : TPDisplayObject) {
			root = AnimationInfoStates.animationRoot.value;
			object = _object;
			
			objectUpdateEvent = new CustomEvent();
			objectLossEvent = new CustomEvent();
			parentLossEvent = new CustomEvent();
			
			var parents : Vector.<DisplayObjectContainer> = TPDisplayObject.getParents(_object.sourceDisplayObject);
			
			path = HierarchyUtil.getChildPath(root, object);
			
			originalParent = new TPDisplayObject(_object.parent);
			parentsChainLength = parents.length;
			bounds = object.getBounds(originalParent);
		}
		
		public function update() : void {
			if (originalParent.isRemoved() == true) {
				parentLossEvent.emit();
				return;
			}
			
			if (hasValidParent() == true) {
				bounds = object.getBounds(originalParent);
			} else {
				handleParentLoss();
			}
			
			if (hasValidParent() == true) {
				inactiveForFrames = 0;
			} else {
				inactiveForFrames++;
			}
		}
		
		public function getObject() : TPDisplayObject {
			return object;
		}
		
		public function getBounds(_targetCoordinateSpace : TPDisplayObject) : Rectangle {
			if (hasValidParent() == true) {
				return object.getBounds(_targetCoordinateSpace);
			}
			
			// Since the targetCoordinateSpace could be anything, we have to calculate the bounds based on previously available bounds
			var topLeft : Point = originalParent.localToGlobal(new Point(bounds.x, bounds.y));
			var bottomRight : Point = originalParent.localToGlobal(new Point(bounds.bottom, bounds.right));
			
			var targetTopLeft : Point = _targetCoordinateSpace.globalToLocal(topLeft);
			var targetBottomRight : Point = _targetCoordinateSpace.globalToLocal(bottomRight);
			var targetWidth : Number = targetBottomRight.x - targetTopLeft.x;
			var targetHeight : Number = targetBottomRight.y - targetTopLeft.y;
			
			return new Rectangle(targetTopLeft.x, targetTopLeft.y, targetWidth, targetHeight);
		}
		
		public function destory() : void {
			objectUpdateEvent = null;
			objectLossEvent = null;
		}
		
		private function hasValidParent() : Boolean {
			if (object == null) {
				return false;
			}
			
			return object.isRemoved() == false;
		}
		
		private function calculateBoundDifferences(_a : Rectangle, _b : Rectangle) : Number {
			var minWidth : Number = Math.min(_a.width, _b.width);
			var maxWidth : Number = Math.max(_a.width, _b.width);
			var minHeight : Number = Math.min(_a.height, _b.height);
			var maxHeight : Number = Math.max(_a.height, _b.height);
			
			// We use max width/height to ensure the value is calculated based on relativity
			var differences : Number = 0;
			differences += Math.abs((minWidth / maxWidth) - 1);
			differences += Math.abs((minHeight / maxHeight) - 1);
			differences += Math.abs(_a.x - _b.x) / maxWidth;
			differences += Math.abs(_a.y - _b.y) / maxHeight;
			
			return differences;
		}
		
		private function handleParentLoss() : void {
			if (originalParent.isRemoved() == true) {
				objectLossEvent.emit();
				return;
			}
			
			var replacement : TPDisplayObject = null;
			var replacementBoundDifferences : Number = -1;
			var minDifferenceForStopping : Number = 0.05;
			var minDifferenceForValid : Number = 0.5;
			
			var childFromPath : TPDisplayObject = HierarchyUtil.getChildFromPath(root, path);
			if (childFromPath != null) {
				var childFromPathBounds : Rectangle = childFromPath.getBounds(originalParent);
				var childFromPathBoundDifferences : Number = calculateBoundDifferences(bounds, childFromPathBounds);
				
				if (childFromPathBoundDifferences <= minDifferenceForValid) {
					object = childFromPath;
					bounds = childFromPath.getBounds(originalParent);
					objectUpdateEvent.emit();
					return;
				}
			}
			
			var children : Vector.<DisplayObject> = originalParent.children;
			
			for (var i : Number = 0; i < children.length; i++) {
				var child : TPDisplayObject = new TPDisplayObject(children[i]);
				var childBounds : Rectangle = child.getBounds(originalParent);
				
				if (childBounds.width == 0 || childBounds.height == 0) {
					continue;
				}
				
				var boundDifferences : Number = calculateBoundDifferences(bounds, childBounds);
				
				if (boundDifferences < replacementBoundDifferences || (replacementBoundDifferences < 0 && boundDifferences < boundDifferences)) {
					replacement = child;
					replacementBoundDifferences = boundDifferences;
				}
				
				if (boundDifferences <= minDifferenceForStopping) {
					break;
				}
			}
			
			if (replacement != null && replacementBoundDifferences <= minDifferenceForValid) {
				object = replacement;
				path = HierarchyUtil.getChildPath(root, object);
				objectUpdateEvent.emit();
			} else {
				objectLossEvent.emit();
			}
		}
	}
}