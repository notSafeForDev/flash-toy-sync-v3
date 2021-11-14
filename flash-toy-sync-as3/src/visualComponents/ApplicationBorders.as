package visualComponents {
	
	import core.TPMovieClip;
	import core.TPStage;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ApplicationBorders {
		
		public function ApplicationBorders(_container : TPMovieClip) {
			var borders : TPMovieClip = TPMovieClip.create(_container, "applicationBorders");
			
			var maxDimensions : Number = Math.max(TPStage.stageWidth, TPStage.stageHeight);
			
			borders.graphics.beginFill(0x000000);
			borders.graphics.drawRect(-maxDimensions, -maxDimensions, maxDimensions * 2 + TPStage.stageWidth, maxDimensions * 2 + TPStage.stageHeight);
			borders.graphics.drawRect(0, 0, TPStage.stageWidth, TPStage.stageHeight);
		}
	}
}