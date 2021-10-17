package components {
	
	import flash.display.MovieClip;
	
	import core.DisplayObjectUtil;
	import core.StageUtil;
	import core.CustomEvent;
	import core.FunctionUtil;
	import core.SWFLoader;
	
	import global.GlobalEvents;
	import global.GlobalState;
	
	public class ExternalSWF {
	
		public var onLoaded : CustomEvent;
		public var onError : CustomEvent;
		
		private var loader : SWFLoader;
		
		private var container : MovieClip;
		
		private var loadedSWF : MovieClip;
		
		private var contentWidth : Number;
		private var contentHeight : Number;
		
		private var currentTargetScale : Number = 1;
		private var currentTargetX : Number = 0;
		private var currentTargetY : Number = 0;
		
		public function ExternalSWF(_container : MovieClip) {
			container = _container;
			
			onLoaded = new CustomEvent();
			onError = new CustomEvent();
			
			loader = new SWFLoader();
			loader.onError =  FunctionUtil.bind(this, _onError);
			
			GlobalState.listen(this, onAnimationSizeStateUpdate, [GlobalState.animationWidth, GlobalState.animationHeight]);
		}
		
		public function browse(_scope : *, _onSelectedhandler : Function) : void {
			loader.browse(FunctionUtil.bind(_scope, _onSelectedhandler));
		}
		
		public function load(_name : String) : void {
			loader.load("animations/" + _name, container, FunctionUtil.bind(this, _onLoaded));
		}
		
		private function onAnimationSizeStateUpdate() : void {
			contentWidth = GlobalState.animationWidth.state;
			contentHeight = GlobalState.animationHeight.state;
			
			if (loadedSWF == null) {
				return;
			}
			
			updateTargetValues();
			updatePositionAndSize();
		}
		
		private function _onLoaded(_swf : MovieClip, _width : Number, _height : Number, _fps : Number) : void {
			loadedSWF = _swf;
			
			contentWidth = _width > 0 ? _width : StageUtil.getWidth();
			contentHeight = _height > 0 ? _height : StageUtil.getHeight();
			
			updateTargetValues();
			updatePositionAndSize();
			
			onLoaded.emit(_swf, _width, _height, _fps);
			
			GlobalEvents.enterFrame.listen(this, onEnterFrame);
		}
		
		private function _onError(_error : String) : void {
			onError.emit(_error);
		}
		
		private function onEnterFrame() : void {
			var scaleX : Number = DisplayObjectUtil.getScaleX(loadedSWF);
			var scaleY : Number = DisplayObjectUtil.getScaleY(loadedSWF);
			
			var maxScale : Number = Math.max(scaleX, scaleY);
			var minScale : Number = Math.min(scaleX, scaleY);
			
			// Handle when the loadedSWF have been scaled up on it's own, such as when there's a camera zoom effect as part of the animation
			if (maxScale > currentTargetScale) {
				var scaledUpWidth : Number = contentWidth * scaleX;
				var scaledUpHeight : Number = contentHeight * scaleY;
				
				// we use minScale in order to make sure that it scales up uniformally on x and y
				var correctedScaledUpWidth : Number = contentWidth * minScale;
				var correctedScaledUpHeight : Number = contentHeight * minScale;
				
				var x : Number = DisplayObjectUtil.getX(loadedSWF);
				var y : Number = DisplayObjectUtil.getY(loadedSWF);
				
				DisplayObjectUtil.setScaleX(loadedSWF, minScale);
				DisplayObjectUtil.setScaleY(loadedSWF, minScale);
				
				// Offset the x and y position so that the center of the screen ends up in the same place as it were before correcting it's scale
				DisplayObjectUtil.setX(loadedSWF, x - (correctedScaledUpWidth - scaledUpWidth) * 0.5);
				DisplayObjectUtil.setY(loadedSWF, y - (correctedScaledUpHeight - scaledUpHeight) * 0.5);
			}
			
			// Handle when the loadedSWF have been scaled down on it's own
			if (maxScale <= currentTargetScale) {
				updatePositionAndSize();
			}
		}
		
		private function updateTargetValues() : void {
			currentTargetScale = getTargetScale();
			currentTargetX = getTargetX(currentTargetScale);
			currentTargetY = getTargetY(currentTargetScale);
		}
		
		private function updatePositionAndSize() : void {			
			DisplayObjectUtil.setX(loadedSWF, currentTargetX);
			DisplayObjectUtil.setY(loadedSWF, currentTargetY);
			DisplayObjectUtil.setScaleX(loadedSWF, currentTargetScale);
			DisplayObjectUtil.setScaleY(loadedSWF, currentTargetScale);
		}
		
		private function getTargetX(_scale : Number) : Number {
			return (StageUtil.getWidth() - (contentWidth * _scale)) / 2;
		}
		
		private function getTargetY(_scale : Number) : Number {
			return (StageUtil.getHeight() - (contentHeight * _scale)) / 2;
		}
		
		private function getTargetScale() : Number {
			var scaleX : Number = StageUtil.getWidth() / contentWidth;
			var scaleY : Number = StageUtil.getHeight() / contentHeight;
			
			return Math.min(scaleX, scaleY);
		}
	}
}