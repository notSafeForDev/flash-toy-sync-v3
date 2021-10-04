package components {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.StageUtil;
	import core.FunctionUtil;
	import core.MovieClipUtil;
	import core.GraphicsUtil;
	import core.MouseEvents;
	import core.Debug;
	import core.DisplayObjectUtil;

	import global.GlobalEvents;

	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StageElementSelector {
		
		private var container : MovieClip;
		private var overlay : MovieClip;
		
		private var selectedChildren : Array = [];
		private var selectedChildrenDepths : Array = [];
		private var selectedChildrenParents : Array = [];
		private var selectedChildrenBounds : Array = [];
		private var selectedChildrenMissingParentFrameCounts : Array = [];
		
		public function StageElementSelector(_container : MovieClip, _overlay : MovieClip) {
			container = _container;
			overlay = _overlay;
			
			MouseEvents.addOnMouseDownPassThrough(this, container, onMouseDown);
			GlobalEvents.enterFrame.listen(this, onEnterFrame);
		}
		
		private function onEnterFrame() : void {
			drawBounds();
		}
		
		private function onMouseDown() : void {
			selectedChildren.length = 0;
			selectedChildrenParents.length = 0;
			selectedChildrenBounds.length = 0;
			selectedChildrenDepths.length = 0;
			selectedChildrenMissingParentFrameCounts.length = 0;
			
			var nestedChildren : Array = DisplayObjectUtil.getNestedChildren(container);
			var stageX : Number = StageUtil.getMouseX();
			var stageY : Number = StageUtil.getMouseY();
			
			for (var i : Number = 0; i < nestedChildren.length; i++) {				
				var wasHit : Boolean = DisplayObjectUtil.hitTest(nestedChildren[i], stageX, stageY, true);
				if (wasHit == true) {
					var parents : Array = DisplayObjectUtil.getParents(nestedChildren[i]);
					selectedChildren.push(nestedChildren[i]);
					selectedChildrenParents.push(parents[0]);
					selectedChildrenDepths.push(parents.length);
					selectedChildrenBounds.push(DisplayObjectUtil.getBounds(nestedChildren[i], parents[0]));
					selectedChildrenMissingParentFrameCounts.push(0);
				}
			}
		}
		
		private function drawBounds() : void {
			GraphicsUtil.clear(overlay);
			GraphicsUtil.setLineStyle(overlay, 2, 0x00FF00);
			
			// var startTime : Number = Debug.getTime();
			
			for (var i : Number = 0; i < selectedChildren.length; i++) {
				var displayObject : DisplayObject = selectedChildren[i];
				var parent : DisplayObject = DisplayObjectUtil.getParent(displayObject);
				
				var hasInvalidParent : Boolean = parent == null || (selectedChildrenDepths[i] > DisplayObjectUtil.getParents(displayObject).length);
				
				if (hasInvalidParent == true) {
					selectedChildrenMissingParentFrameCounts[i]++;
				} else {
					selectedChildrenMissingParentFrameCounts[i] = 0;
				}
				
				var sizeThreshold : Number = 0.05;
				var positionThreshold : Number = 50;
				
				var targetBounds : Rectangle = selectedChildrenBounds[i];
					
				// This part only appears to be useful for AS3, as AS3 is able to access all nested shapes
				if (hasInvalidParent == true) {
					for (var i2 : Number = 0; i2 < selectedChildrenParents[i].numChildren; i2++) {
						var otherDisplayObject : DisplayObject = selectedChildrenParents[i].getChildAt(i2);
						if (otherDisplayObject == null) {
							continue;
						}
						
						var otherParent : DisplayObject = DisplayObjectUtil.getParent(otherDisplayObject);
						var otherBounds : Rectangle = DisplayObjectUtil.getBounds(otherDisplayObject, otherParent);
						
						var hasSimiliarWidth : Boolean = Math.abs(targetBounds.width - otherBounds.width) <= targetBounds.width * sizeThreshold;
						var hasSimiliarHeight : Boolean = Math.abs(targetBounds.height - otherBounds.height) <= targetBounds.height * sizeThreshold;
						var hasSimilarXPosition : Boolean = Math.abs(targetBounds.x - otherBounds.x) <= positionThreshold
						var hasSimilarYPosition : Boolean = Math.abs(targetBounds.y - otherBounds.y) <= positionThreshold;
						
						if (hasSimiliarWidth == true && hasSimiliarHeight == true && hasSimilarXPosition == true && hasSimilarYPosition == true) {
							selectedChildren[i] = otherDisplayObject;
							selectedChildrenParents[i] = otherParent;
							selectedChildrenBounds[i] = otherBounds;
							break;
						}
					}
				}
				
				displayObject = selectedChildren[i]; // Incase it have changed
				parent = DisplayObjectUtil.getParent(displayObject);
				
				if (hasInvalidParent && selectedChildrenMissingParentFrameCounts[i] >= 3) {
					selectedChildren.splice(i, 1);
					selectedChildrenParents.splice(i, 1);
					selectedChildrenBounds.splice(i, 1);
					selectedChildrenDepths.splice(i, 1);
					selectedChildrenMissingParentFrameCounts.splice(i, 1);
					i--;
					continue;
				}
				
				if (hasInvalidParent == true) {
					hasInvalidParent = parent == null || (selectedChildrenDepths[i] > DisplayObjectUtil.getParents(displayObject));
				} else {
					selectedChildrenBounds[i] = DisplayObjectUtil.getBounds(displayObject, parent);
				}
				
				if (hasInvalidParent == false) {
					if (DisplayObjectUtil.isShape(displayObject) == true) {
						GraphicsUtil.setLineStyle(overlay, 2, 0xFFFF00);
					} else {
						GraphicsUtil.setLineStyle(overlay, 4, 0x00FF00);
					}
					
					var bounds : Rectangle = DisplayObjectUtil.getBounds(displayObject, overlay);
					GraphicsUtil.drawRect(overlay, bounds.x, bounds.y, bounds.width, bounds.height);
				}
			}
		}
	}
}