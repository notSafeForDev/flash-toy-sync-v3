package utils {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import core.TPStage;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import states.AnimationInfoStates;
	import states.AnimationSceneStates;
	import states.HierarchyStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StageChildSelectionUtil {
		
		// TODO: Implement the parts that have been commented out
		
		public static function getClickableChildAtCursor() : TPDisplayObject {
			var root : TPMovieClip = AnimationInfoStates.animationRoot.value;
			var rootParent : TPDisplayObject = new TPDisplayObject(TPStage.stage);
			
			var child : TPDisplayObject = AnimationSceneStates.activeChild.value || root;
			var children : Vector.<DisplayObject> = child.children;
			var bounds : Rectangle = null;
			var isCheckingDirectChildren : Boolean = true;
			var isDone : Boolean = false;
			var stageMousePoint : Point = new Point(TPStage.mouseX, TPStage.mouseY);
			var lockedChildren : Array = HierarchyStates.lockedChildren.value;
			
			while (isDone == false) {
				var closestChild : TPDisplayObject = null;
				var closestChildDistance : Number = -1;
				var closestChildBounds : Rectangle = null;
				
				// We iterate from the last child to the first, as they are ordered from highest to lowest depth
				for (var i : Number = children.length - 1; i >= 0; i--) {
					var tpDisplayObject : TPDisplayObject = new TPDisplayObject(children[i]);
					
					// If the child has disabled mouse selection, skip it
					if (ArrayUtil.includes(lockedChildren, children[i]) == true) {
						continue;
					}
					// If the mouse selection filter matches the child's name, skip it
					/* if (isChildFilteredOut(children[i]) == true) {
						continue;
					} */
					// If the mouse position isn't within the child's bounds, skip it
					var childBounds : Rectangle = tpDisplayObject.getBounds(rootParent);
					if (childBounds.containsPoint(stageMousePoint) == false) {
						continue;
					}
					// If the child's bounds are too large, such a screen overlay, skip it
					if (childBounds.width >= TPStage.stageWidth && childBounds.height >= TPStage.stageHeight) {
						continue;
					}
					// If it's checking direct children to the parent and we are clicking directly on it's shape, continue with it, otherwise, skip it
					if (isCheckingDirectChildren == true && tpDisplayObject.hitTest(TPStage.mouseX, TPStage.mouseY, true) == true) {
						closestChild = tpDisplayObject;
						break;
					} else if (isCheckingDirectChildren == true) {
						continue;
					}
					// If it's a shape, and the bounds are very similar to the current parents bounds, skip it, that way we prioritize movieClips
					/* if (DisplayObjectUtil.isShape(children[i]) == true && shouldIgnoreShape(children[i]) == true) {
						continue;
					} */
					// If it's a match, check how far away the center of it's bounds are and compare it to the closest found so far
					var boundsCenterPoint : Point = new Point(childBounds.x + childBounds.width / 2, childBounds.y + childBounds.height / 2);
					var distance : Number = Point.distance(stageMousePoint, boundsCenterPoint);
					if (closestChild == null || distance < closestChildDistance) {
						closestChild = tpDisplayObject;
						closestChildDistance = distance;
						closestChildBounds = childBounds;
					}
				}
				
				if (closestChild != null && child.children != null) {
					child = closestChild;
					children = child.children;
					bounds = child.getBounds(rootParent);
				}
				
				if (closestChild == null || child.children == null) {
					isDone = true;
				}
				
				isCheckingDirectChildren = false;
			}
			
			return child;
		}
		
		/* private static function isChildFilteredOut(_child : DisplayObject) : Boolean {
			var filter : String = EditorState.mouseSelectFilter.value;
			if (filter == "") {
				return false;
			}
			var parts : Array = filter.split(",");
			var name : String = DisplayObjectUtil.getName(_child);
			for (var i : Number = 0; i < parts.length; i++) {
				if (name.indexOf(parts[i]) >= 0) {
					return true;
				}
			}
			return false;
		}
		
		private static function shouldIgnoreShape(_shape : DisplayObject) : Boolean {
			var parent : DisplayObjectContainer = DisplayObjectUtil.getParent(_shape);
			if (parent == null) {
				return true;
			}
			
			var shapeBounds : Rectangle = DisplayObjectUtil.getBounds(_shape);
			var parentBounds : Rectangle = DisplayObjectUtil.getBounds(parent);
			
			var shapeBoundsArea : Number = shapeBounds.width * shapeBounds.height;
			var parentBoundsArea : Number  = parentBounds.width * parentBounds.height;
			
			return shapeBoundsArea > parentBoundsArea * 0.8;
		} */
	}
}