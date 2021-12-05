package ui {
	
	import core.FrameEvents;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class UIScrollArea {
		
		public var content : TPMovieClip;
		public var mask : TPDisplayObject;
		
		private var scrollbar : UIScrollbar;
		
		public function UIScrollArea(_content : TPMovieClip, _mask : TPDisplayObject, _scrollbarHandle : TPMovieClip) {
			content = _content;
			mask = _mask;
			
			content.setMask(mask);
			
			scrollbar = new UIScrollbar(_scrollbarHandle, mask.height, true);
			scrollbar.progressUpdateEvent.listen(this, onScrollbarProgressUpdate);
			scrollbar.setContentSize(mask.height);
			
			FrameEvents.processFrameEvent.listen(this, onProcessFrame);
		}
		
		private function onScrollbarProgressUpdate(_progress : Number) : void {
			var availableScrollHeight : Number = Math.max(0, content.height - mask.height);
			
			content.y = -availableScrollHeight * _progress;
		}
		
		private function onProcessFrame() : void {
			scrollbar.setContentSize(content.height);
		}
		
		/**
		 * Checks if an element is inside the mask vertically, assuming it's origin is at the top
		 * @param	_child		A child of the content container
		 * @return	Whether it's visible or not
		 */
		public function isElementVisible(_child : TPDisplayObject) : Boolean {
			var yInsideMask : Number = _child.y + content.y;
			return yInsideMask + _child.height >= 0 && yInsideMask <= mask.height;
		}
		
		public function scrollToElement(_child : TPDisplayObject) : void {
			scrollbar.setContentSize(content.height);
			
			var scrollableHeight : Number = Math.max(0, content.height - mask.height);
			
			var yInsideMask : Number = _child.y + content.y;
			var yOffset : Number;
			
			var minY : Number = 0;
			var maxY : Number = mask.height - _child.height;
			
			if (scrollableHeight == 0 || (yInsideMask >= minY && yInsideMask <= maxY)) {
				return;
			}
			
			if (yInsideMask < minY) {
				yOffset = -yInsideMask;
			}
			
			if (yInsideMask > maxY) {
				yOffset = -(yInsideMask - maxY);
			}
			
			var yBefore : Number = content.y;
			var scrollbarProgressOffset : Number = -(yOffset / scrollableHeight);
			scrollbar.setProgress(scrollbar.getProgress() + scrollbarProgressOffset);
			var yAfter : Number = content.y;
		}
	}
}