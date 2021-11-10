package visualComponents {
	
	import core.CustomEvent;
	import core.TPStage;
	import flash.display.MovieClip;
	import core.TPMovieClip;
	import core.SWFLoader;
	import states.AnimationInfoStates;
	import states.AnimationSizeStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Animation {
		
		public var loadedEvent : CustomEvent;
		public var loadErrorEvent : CustomEvent;
		
		private var container : TPMovieClip;
		private var loader : SWFLoader;
		private var loadedSWF : TPMovieClip;
		
		public function Animation(_container : TPMovieClip) {
			container = TPMovieClip.create(_container, "animationContainer");
			loader = new SWFLoader();
			
			loadedEvent = new CustomEvent();
			loadErrorEvent = new CustomEvent();
			
			AnimationSizeStates.listen(this, onAnimationSizeStatesChange, [AnimationSizeStates.width, AnimationSizeStates.height]);
			
			Index.enterFrameEvent.listen(this, onEnterFrame);
		}
		
		public function browse(_scope : *, _onSelectHandler : Function) : void {
			loader.browse(_scope, _onSelectHandler, "swf (in animations folder)");
		}
		
		/**
		 * Load an animation found in the animations folder
		 * @param	_name	The name of the swf file, including the .swf extension
		 */
		public function load(_name : String) : void {
			var path : String;
			if (AnimationInfoStates.isStandalone.value == true) {
				path = _name;
			} else {
				path = "animations/" + _name;
			}
			
			loader.load(path, container.sourceMovieClip, this, onLoaded, onLoadError);
		}
		
		/**
		 * Load a standalone animation found in the same folder as the application
		 * @param	_name	The name of the swf file, including the .swf extension
		 */
		public function loadStandalone(_name : String) : void {
			var path : String = _name;
			
			loader.load(path, container.sourceMovieClip, this, onLoaded, onLoadError);
		}
		
		public function unload() : void {
			loader.unload();
		}
		
		private function onLoaded(_swf : MovieClip, _stageWidth : Number, _stageHeight : Number, _frameRate : Number) : void {
			loadedSWF = new TPMovieClip(_swf);
			loadedEvent.emit(_swf, _stageWidth, _stageHeight, _frameRate);
		}
		
		private function onLoadError(_error : String) : void {
			loadErrorEvent.emit(_error);
		}
		
		private function onAnimationSizeStatesChange() : void {
			updatePositionAndSizeBasedOnState();
		}
		
		private function onEnterFrame() : void {
			if (loadedSWF == null) {
				return;
			}
			
			var maxScale : Number = Math.max(loadedSWF.scaleX, loadedSWF.scaleY);
			var minScale : Number = Math.min(loadedSWF.scaleX, loadedSWF.scaleY);
			
			var targetScale : Number = getTargetScale();
			var animationWidth : Number = AnimationSizeStates.width.value;
			var animationHeight : Number = AnimationSizeStates.height.value;
			
			// Handle when the loadedSWF have been scaled up on it's own, such as when there's a camera zoom effect as part of the animation
			if (maxScale > targetScale) {
				var scaledUpWidth : Number = animationWidth * loadedSWF.scaleX;
				var scaledUpHeight : Number = animationHeight * loadedSWF.scaleY;
				
				// we use minScale in order to make sure that it scales up uniformally on x and y
				var correctedScaledUpWidth : Number = animationWidth * minScale;
				var correctedScaledUpHeight : Number = animationHeight * minScale;
				
				loadedSWF.scaleX = minScale;
				loadedSWF.scaleY = minScale;
				
				// Offset the x and y position so that the center of the screen ends up in the same place as it were before correcting it's scale
				loadedSWF.x -= (correctedScaledUpWidth - scaledUpWidth) * 0.5;
				loadedSWF.y -= (correctedScaledUpHeight - scaledUpHeight) * 0.5;
			}
			
			// Handle when the loadedSWF have been scaled down on it's own, such as when it resets a camera zoom effect
			if (maxScale <= targetScale) {
				updatePositionAndSizeBasedOnState();
			}
		}
		
		private function updatePositionAndSizeBasedOnState() : void {
			var width : Number = AnimationSizeStates.width.value;
			var height : Number = AnimationSizeStates.height.value;
			var scale : Number = getTargetScale();
			
			container.x = (TPStage.stageWidth - (width * scale)) / 2;
			container.y = (TPStage.stageHeight - (height * scale)) / 2;
			container.scaleX = scale;
			container.scaleY = scale;
		}
		
		private function getTargetScale() : Number {
			var scaleX : Number = TPStage.stageWidth / AnimationSizeStates.width.value;
			var scaleY : Number = TPStage.stageHeight / AnimationSizeStates.height.value;
			
			return Math.min(scaleX, scaleY);
		}
	}
}