package ui {
	
	import core.CustomEvent;
	import core.DraggableObject;
	import core.TPMovieClip;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import utils.MathUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class UIScrollbar {
		
		public var progressUpdateEvent : CustomEvent;
		
		private var scrollbarHandle : TPMovieClip;
		private var scrollbarSize : Number;
		private var isVertical : Boolean;
		
		private var contentSize : Number = 0;
		
		private var progress : Number = 0;
		
		private var draggable : DraggableObject;
		
		private var handleStartPosition : Point;
		
		public function UIScrollbar(_scrollbarHandle : TPMovieClip, _scrollbarSize : Number, _isVertical : Boolean) {
			scrollbarHandle = _scrollbarHandle;
			scrollbarSize = _scrollbarSize;
			isVertical = _isVertical;
			
			scrollbarHandle.buttonMode = true;
			
			handleStartPosition = new Point(scrollbarHandle.x, scrollbarHandle.y);
			
			progressUpdateEvent = new CustomEvent();
			
			draggable = new DraggableObject(_scrollbarHandle);
			draggable.dragBounds = new Rectangle(handleStartPosition.x, handleStartPosition.y, 0, 0);
			draggable.dragEvent.listen(this, onDraggingScrollbarHandle);
		}
		
		public function getProgress() : Number {
			return progress;
		}
		
		public function setProgress(_value : Number) : void {
			progress = MathUtil.clamp(_value, 0, 1);
			updateHandlePosition();
			progressUpdateEvent.emit(progress);
		}
		
		public function setContentSize(_value : Number) : void {
			if (_value > 0) {
				progress = MathUtil.clamp(progress * (contentSize / _value), 0, 1);
			} else {
				progress = 0;
			}
			
			contentSize = _value;
			
			var handleSize : Number = getHandleSize();
			var availableScrollLength : Number = scrollbarSize - handleSize;
			
			if (isVertical == true) {
				scrollbarHandle.height = handleSize;
				draggable.dragBounds = new Rectangle(handleStartPosition.x, handleStartPosition.y, 0, availableScrollLength);
			} else {
				scrollbarHandle.width = handleSize;
				draggable.dragBounds = new Rectangle(handleStartPosition.x, handleStartPosition.y, availableScrollLength, 0);
			}
			
			updateHandlePosition();
			
			progressUpdateEvent.emit(progress);
		}
		
		private function onDraggingScrollbarHandle() : void {
			progress = calculateProgressBasedOnHandlePosition();
			progressUpdateEvent.emit(progress);
		}
		
		private function calculateProgressBasedOnHandlePosition() : Number {
			var handleSize : Number = getHandleSize();
			var availableScrollLength : Number = scrollbarSize - handleSize;
			var calculatedProgress : Number;
			
			if (availableScrollLength <= 0) {
				calculatedProgress = 0;
			} else if (isVertical == true) {
				calculatedProgress = scrollbarHandle.y / availableScrollLength;
			} else {
				calculatedProgress = scrollbarHandle.x / availableScrollLength;
			}
			
			return calculatedProgress;
		}
		
		private function updateHandlePosition() : void {
			var handleSize : Number = getHandleSize();
			var availableScrollLength : Number = scrollbarSize - handleSize;
			
			if (isVertical == true) {
				scrollbarHandle.y = handleStartPosition.y + availableScrollLength * progress;
			} else {
				scrollbarHandle.x = handleStartPosition.x + availableScrollLength * progress;
			}
		}
		
		private function getHandleSize() : Number {
			if (contentSize > 0) {
				return Math.min(scrollbarSize, scrollbarSize * (scrollbarSize / contentSize));
			}
			
			return scrollbarSize;
		}
	}
}