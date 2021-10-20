package components {
	
	import flash.display.MovieClip;
	
	import core.Timeout;
	import core.DisplayObjectUtil;
	import core.MovieClipUtil;
	import core.GraphicsUtil;
	import core.StageUtil;

	import global.AnimationInfoState;
	import global.GlobalEvents;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Borders {
		
		private var element : MovieClip;
		private var color : Number = 0x000000;
		private var currentColor : Number = 0x000000;
		private var isTransparent : Boolean = false;
		private var makeTransparentTimeout : Number = -1;
		
		public function Borders(_parent : MovieClip, _color : Number) {
			element = MovieClipUtil.create(_parent, "borders");
			color = _color;
			currentColor = _color;
			
			AnimationInfoState.listen(this, onStateChange, [AnimationInfoState.width, AnimationInfoState.height]);
			GlobalEvents.animationManualResize.listen(this, onAnimationManualResize);
		}
		
		private function onAnimationManualResize() : void {
			makeTransparentForADuration(1);
		}
		
		private function onStateChange() : void {
			update(AnimationInfoState.width.value / AnimationInfoState.height.value);
		}
		
		private function update(_aspectRatio : Number) : void {
			var stageWidth : Number = StageUtil.getWidth();
			var stageHeight : Number = StageUtil.getHeight();
			var maxStageDimension : Number = Math.max(stageWidth, stageHeight);
			
			var stageAspectRatio : Number = stageWidth / stageHeight;
			var shouldShowTopAndBottomBorders : Boolean = _aspectRatio > stageAspectRatio;
			
			var topBorderHeight : Number = 0;
			var sideBorderWidth : Number = 0;
			
			if (shouldShowTopAndBottomBorders == true) {
				topBorderHeight = (stageHeight - (stageWidth / _aspectRatio)) * 0.5;
			} else {
				sideBorderWidth = (stageWidth - (stageHeight * _aspectRatio)) * 0.5;
			}
			
			GraphicsUtil.clear(element);
			GraphicsUtil.beginFill(element, currentColor);
			GraphicsUtil.drawRect(element, -maxStageDimension, -maxStageDimension, stageWidth + maxStageDimension * 2, maxStageDimension + topBorderHeight); // Top
			GraphicsUtil.drawRect(element, -maxStageDimension, topBorderHeight, maxStageDimension + sideBorderWidth, stageHeight - topBorderHeight * 2); // Left
			GraphicsUtil.drawRect(element, stageWidth - sideBorderWidth, topBorderHeight, sideBorderWidth + maxStageDimension, stageHeight - topBorderHeight * 2); // Right
			GraphicsUtil.drawRect(element, -maxStageDimension, stageHeight - topBorderHeight, stageWidth + maxStageDimension * 2, topBorderHeight + maxStageDimension); // Bottom
		}
		
		private function makeTransparentForADuration(_seconds : Number) : void {
			DisplayObjectUtil.setAlpha(element, 0.25);
			currentColor = 0xFF0000;
			update(AnimationInfoState.width.value / AnimationInfoState.height.value);
			
			Timeout.clear(makeTransparentTimeout);
			makeTransparentTimeout = Timeout.set(this, doneMakingItTransparent, _seconds * 1000);
		}
		
		private function doneMakingItTransparent() : void {
			DisplayObjectUtil.setAlpha(element, 1);
			currentColor = color;
			update(AnimationInfoState.width.value / AnimationInfoState.height.value);
		}
	}
}