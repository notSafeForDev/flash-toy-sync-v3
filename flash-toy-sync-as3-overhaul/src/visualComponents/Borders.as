package visualComponents {
	
	import core.TranspiledMovieClip;
	import core.TranspiledMovieClipFunctions;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import states.AnimationSizeStates;
	import core.TranspiledStage;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Borders {
		
		private var element : TranspiledMovieClip;
		
		private var color : Number;
		private var currentColor : Number;
		
		private var containerWidth : Number;
		private var containerHeight : Number;
		private var containerAspectRatio : Number;
		private var containerMaxDimension : Number;
		
		public function Borders(_parent : MovieClip, _color : Number) {
			element = TranspiledMovieClip.create(_parent, "borders");
			
			color = _color;
			currentColor = _color;
			
			containerWidth = TranspiledStage.stageWidth;
			containerHeight = TranspiledStage.stageHeight;
			containerAspectRatio = containerWidth / containerHeight;
			containerMaxDimension = Math.max(containerWidth, containerHeight);
			
			AnimationSizeStates.listen(this, onAnimationSizeStatesChange, [AnimationSizeStates.width, AnimationSizeStates.height]);
		}
		
		private function onAnimationSizeStatesChange() : void {
			update(AnimationSizeStates.width.value / AnimationSizeStates.height.value);
		}
		
		private function update(_visibleAreaAspectRatio : Number) : void {
			var shouldShowTopAndBottomBorders : Boolean = _visibleAreaAspectRatio > containerAspectRatio;
			
			var topBorderHeight : Number = 0;
			var sideBorderWidth : Number = 0;
			
			if (shouldShowTopAndBottomBorders == true) {
				topBorderHeight = (containerHeight - (containerWidth / _visibleAreaAspectRatio)) * 0.5;
			} else {
				sideBorderWidth = (containerWidth - (containerHeight * _visibleAreaAspectRatio)) * 0.5;
			}
			
			var outsideRect : Rectangle = new Rectangle(
				-containerMaxDimension, 
				-containerMaxDimension, 
				containerWidth + containerMaxDimension * 2, 
				containerHeight + containerMaxDimension * 2
			);
			
			var insideRect : Rectangle = new Rectangle(
				sideBorderWidth, 
				topBorderHeight, 
				containerWidth - sideBorderWidth * 2, 
				containerHeight - topBorderHeight * 2
			);
			
			element.graphics.clear();
			element.graphics.beginFill(currentColor);
			element.graphics.drawRect(outsideRect.x, outsideRect.y, outsideRect.width, insideRect.y - outsideRect.y); // Top
			element.graphics.drawRect(outsideRect.x, insideRect.y, insideRect.x - outsideRect.x, insideRect.height); // Left
			element.graphics.drawRect(insideRect.right, insideRect.y, outsideRect.right - insideRect.right, insideRect.height); // Right
			element.graphics.drawRect(outsideRect.x, insideRect.bottom, outsideRect.width, insideRect.y - outsideRect.y); // Top
		}
	}
}