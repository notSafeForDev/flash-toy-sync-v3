package components {
	
	import core.Debug;
	import core.DisplayObjectUtil;
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
	import core.MovieClipEvents;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StageElementSelector {
		
		private var container : MovieClip;
		private var overlay : MovieClip;
		
		private var selectedChildren : Array = [];
		private var selectedChildrenParents : Array = [];
		private var selectedChildrenBounds : Array = [];
		
		public function StageElementSelector(_container : MovieClip, _overlay : MovieClip) {
			container = _container;
			overlay = _overlay;
			
			MovieClipEvents.addOnEnterFrame(this, overlay, onEnterFrame);
			MouseEvents.addOnMouseDownPassThrough(this, container, onMouseDown);
		}
		
		private function onEnterFrame() : void {
			drawBounds();
		}
		
		private function onMouseDown() : void {
			selectedChildren.length = 0;
			selectedChildrenParents.length = 0;
			selectedChildrenBounds.length = 0;
			
			var nestedChildren : Array = DisplayObjectUtil.getNestedChildren(container);
			var stageX : Number = StageUtil.getMouseX();
			var stageY : Number = StageUtil.getMouseY();
			
			for (var i : Number = 0; i < nestedChildren.length; i++) {				
				var wasHit : Boolean = DisplayObjectUtil.hitTest(nestedChildren[i], stageX, stageY, true);
				if (wasHit == true) {
					var parent : DisplayObject = DisplayObjectUtil.getParent(nestedChildren[i]);
					selectedChildren.push(nestedChildren[i]);
					selectedChildrenParents.push(parent);
					selectedChildrenBounds.push(DisplayObjectUtil.getBounds(nestedChildren[i], parent));
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
				
				// This part only appears to be useful for AS3, as AS3 is able to access all nested shapes
				if (parent == null) {
					var targetBounds : Rectangle = selectedChildrenBounds[i];
					
					for (var i2 : Number = 0; i2 < selectedChildrenParents[i].numChildren; i2++) {
						var otherDisplayObject : DisplayObject = selectedChildrenParents[i].getChildAt(i2);
						if (otherDisplayObject == null) {
							continue;
						}
						
						var otherParent : DisplayObject = DisplayObjectUtil.getParent(otherDisplayObject);
						var otherBounds : Rectangle = DisplayObjectUtil.getBounds(otherDisplayObject, otherParent);
						
						var similarityThreshold : Number = 100;
						var hasSimiliarWidth : Boolean = Math.abs(targetBounds.width - otherBounds.width) <= targetBounds.width * 0.2;
						var hasSimiliarHeight : Boolean = Math.abs(targetBounds.height - otherBounds.height) <= targetBounds.height * 0.2;
						var hasSimilarXPosition : Boolean = Math.abs(targetBounds.x - otherBounds.x) <= similarityThreshold;
						var hasSimilarYPosition : Boolean = Math.abs(targetBounds.y - otherBounds.y) <= similarityThreshold;
						
						if (hasSimiliarWidth == true && hasSimiliarHeight == true && hasSimilarXPosition == true && hasSimilarYPosition == true) {
							selectedChildren[i] = otherDisplayObject;
							break;
						}
					}
				}
				
				displayObject = selectedChildren[i]; // Incase it have changed
				parent = DisplayObjectUtil.getParent(displayObject);
				
				if (parent != null) {
					selectedChildrenBounds[i] = DisplayObjectUtil.getBounds(displayObject, parent);
				}
				
				var selectedChildParent : DisplayObject = DisplayObjectUtil.getParent(selectedChildren[i]);
				if (selectedChildParent != null) {
					var bounds : Rectangle = DisplayObjectUtil.getBounds(selectedChildren[i], overlay);
					GraphicsUtil.drawRect(overlay, bounds.x, bounds.y, bounds.width, bounds.height);
				}
			}
			
			// trace(Debug.getTime() - startTime);
		}
	}
}