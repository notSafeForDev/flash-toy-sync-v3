package components {
	
	import core.MovieClipUtil;
	import core.StageUtil;
	import flash.display.MovieClip;
	import global.GlobalEvents;
	import global.GlobalState;
	import global.GlobalStateSnapshot;
	
	import core.CustomEvent;
	import core.FunctionUtil;
	import core.SWFLoader;
	
	public class ExternalSWF {
	
		public var onLoaded : CustomEvent;
		public var onError : CustomEvent;
		
		private var loadedSWF : MovieClip;
		
		private var contentWidth : Number;
		private var contentHeight : Number;
		
		private var currentTargetScale : Number = 1;
		private var currentTargetX : Number = 0;
		private var currentTargetY : Number = 0;
		
		public function ExternalSWF(_path : String, _container : MovieClip) {
			onLoaded = new CustomEvent();
			onError = new CustomEvent();
			
			var loader : SWFLoader = new SWFLoader();
			loader.load(_path, _container, FunctionUtil.bind(this, _onLoaded));
			loader.onError =  FunctionUtil.bind(this, _onError);
			
			GlobalState.listen([GlobalState.animationWidth, GlobalState.animationHeight], this, onStateUpdate);
		}
		
		private function onStateUpdate(_state : GlobalStateSnapshot) : void {
			contentWidth = _state.animationWidth;
			contentHeight = _state.animationHeight;
			
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
		
		private function _onError(_error : Error) : void {
			onError.emit(_error);
		}
		
		private function onEnterFrame() : void {
			if (loadedSWF == null) {
				throw new Error("Unable to update external swf, the swf have not been loaded yet");
			}
			
			var scaleX : Number = MovieClipUtil.getScaleX(loadedSWF);
			var scaleY : Number = MovieClipUtil.getScaleY(loadedSWF);
			
			var maxScale : Number = Math.max(scaleX, scaleY);
			var minScale : Number = Math.min(scaleX, scaleY);
			
			// Handle when the loadedSWF have been scaled up on it's own, such as when there's a camera zoom effect as part of the animation
			if (maxScale > currentTargetScale) {
				var scaledUpWidth : Number = contentWidth * scaleX;
				var scaledUpHeight : Number = contentHeight * scaleY;
				
				// we use minScale in order to make sure that it scales up uniformally on x and y
				var correctedScaledUpWidth : Number = contentWidth * minScale;
				var correctedScaledUpHeight : Number = contentHeight * minScale;
				
				var x : Number = MovieClipUtil.getX(loadedSWF);
				var y : Number = MovieClipUtil.getY(loadedSWF);
				
				MovieClipUtil.setScaleX(loadedSWF, minScale);
				MovieClipUtil.setScaleY(loadedSWF, minScale);
				
				// Offset the x and y position so that the center of the screen ends up in the same place as it were before correcting it's scale
				MovieClipUtil.setX(loadedSWF, x - (correctedScaledUpWidth - scaledUpWidth) * 0.5);
				MovieClipUtil.setY(loadedSWF, y - (correctedScaledUpHeight - scaledUpHeight) * 0.5);
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
			MovieClipUtil.setX(loadedSWF, currentTargetX);
			MovieClipUtil.setY(loadedSWF, currentTargetY);
			MovieClipUtil.setScaleX(loadedSWF, currentTargetScale);
			MovieClipUtil.setScaleY(loadedSWF, currentTargetScale);
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