package components {
	
	import core.MovieClipUtil;
	import core.StageUtil;
	import flash.display.MovieClip;
	
	import core.CustomEvent;
	import core.FunctionUtil;
	import core.SWFLoader;
	
	public class ExternalSWF {
	
		public var onLoaded : CustomEvent;
		public var onError : CustomEvent;
		
		private var loadedSWF : MovieClip;
		
		private var shouldScaleUpUniformaly : Boolean = true;
		
		private var loadedSWFWidth : Number = -1;
		private var loadedSWFHeight : Number = -1;
		
		private var currentTargetScale : Number = 1;
		private var currentTargetX : Number = 0;
		private var currentTargetY : Number = 0;
		private var zoomAmount : Number = 1;
		
		private var defaultWidth : Number = 1280;
		private var defaultHeight : Number = 720;
		
		public function ExternalSWF(_path : String, _container : MovieClip) {
			onLoaded = new CustomEvent();
			onError = new CustomEvent();
			
			var loader : SWFLoader = new SWFLoader();
			loader.load(_path, _container, FunctionUtil.bind(this, _onLoaded));
		}
		
		private function _onLoaded(_swf : MovieClip, _width : Number, _height : Number, _fps : Number) : void {
			loadedSWF = _swf;
			
			loadedSWFWidth = _width;
			loadedSWFHeight = _height;
			
			updateTargetValues();
			updatePositionAndSize();
			
			onLoaded.emit(_swf, _width, _height, _fps);
		}
		
		private function _onError(_error : Error) : void {
			onError.emit(_error);
		}
	
		private function updateTargetValues() : void {
			currentTargetScale = getTargetScale();
			currentTargetX = getTargetX(currentTargetScale);
			currentTargetY = getTargetY(currentTargetScale);
		}
		
		public function isWidthSet() : Boolean {
			return loadedSWFWidth > 0;
		}
		
		public function isHeightSet() : Boolean {
			return loadedSWFHeight > 0;
		}
		
		public function increaseWidth(_amount : Number) : Number {
			loadedSWFWidth = isWidthSet() ? loadedSWFWidth + _amount : _amount;
			updateTargetValues();
			updatePositionAndSize();
			return loadedSWFWidth;
		}
		
		public function decreaseWidth(_amount : Number) : Number {
			var target : Number = loadedSWFWidth - _amount;
			loadedSWFWidth = Math.max(target, _amount);
			updateTargetValues();
			updatePositionAndSize();
			return loadedSWFWidth;
		}
		
		public function increaseHeight(_amount : Number) : Number {
			loadedSWFHeight = isHeightSet() ? loadedSWFHeight + _amount : _amount;
			updateTargetValues();
			updatePositionAndSize();
			return loadedSWFHeight;
		}
		
		public function decreaseHeight(_amount : Number) : Number {
			var target : Number = loadedSWFHeight - _amount;
			loadedSWFHeight = Math.max(target, _amount);
			updateTargetValues();
			updatePositionAndSize();
			return loadedSWFHeight;
		}
		
		public function update() : void {
			var scaleX : Number = MovieClipUtil.getScaleX(loadedSWF);
			var scaleY : Number = MovieClipUtil.getScaleY(loadedSWF);
			
			var maxScale : Number = Math.max(scaleX, scaleY);
			var minScale : Number = Math.min(scaleX, scaleY);
			
			// Handle when the loadedSWF have been scaled up on it's own, such as when there's a camera zoom effect as part of the animation
			if (minScale > currentTargetScale && shouldScaleUpUniformaly == true) {
				var scaledUpWidth : Number = loadedSWFWidth * scaleX;
				var scaledUpHeight : Number = loadedSWFHeight * scaleY;
				
				var correctedScaledUpWidth : Number = loadedSWFWidth * minScale;
				var correctedScaledUpHeight : Number = loadedSWFHeight * minScale;
				
				var x : Number = MovieClipUtil.getX(loadedSWF);
				var y : Number = MovieClipUtil.getY(loadedSWF);
				
				MovieClipUtil.setScaleX(loadedSWF, minScale);
				MovieClipUtil.setScaleY(loadedSWF, minScale);
				
				// Offset the x and y position so that the center of the screen ends up in the same place as it were before correcting it's scale
				MovieClipUtil.setX(loadedSWF, x + (correctedScaledUpWidth - scaledUpWidth) * 0.5);
				MovieClipUtil.setY(loadedSWF, y + (correctedScaledUpHeight - scaledUpHeight) * 0.5);
			}
			
			// Handle when the loadedSWF have been scaled down on it's own
			if (maxScale < currentTargetScale) {
				updatePositionAndSize();
			}
		}
		
		private function updatePositionAndSize() : void {
			if (loadedSWF == null) {
				throw new Error("Unable to update position and size of swf, it have not been loaded yet");
			}
			
			if (isWidthSet() == false && isHeightSet() == false) {
				MovieClipUtil.setX(loadedSWF, 0);
				MovieClipUtil.setY(loadedSWF, 0);
				MovieClipUtil.setScaleX(loadedSWF, 1);
				MovieClipUtil.setScaleY(loadedSWF, 1);
				return;
			}
			
			MovieClipUtil.setX(loadedSWF, currentTargetX);
			MovieClipUtil.setY(loadedSWF, currentTargetY);
			MovieClipUtil.setScaleX(loadedSWF, currentTargetScale);
			MovieClipUtil.setScaleY(loadedSWF, currentTargetScale);
		}
		
		private function getTargetX(_scale : Number) : Number {
			var width : Number = isWidthSet() ? loadedSWFWidth : defaultWidth;
			return (StageUtil.getWidth() - (width * _scale)) / 2;
		}
		
		private function getTargetY(_scale : Number) : Number {
			var height : Number = isHeightSet() ? loadedSWFHeight : defaultHeight;
			return (StageUtil.getHeight() - (height * _scale)) / 2;
		}
		
		private function getTargetScale() : Number {
			var width : Number = isWidthSet() ? loadedSWFWidth : defaultWidth;
			var height : Number = isHeightSet() ? loadedSWFHeight : defaultHeight;
			
			var maxScaleX : Number = (StageUtil.getWidth() / width);
			var maxScaleY : Number = (StageUtil.getHeight() / height);
			
			return Math.min(maxScaleX, maxScaleY);
		}
	}
}