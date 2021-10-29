package {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Main extends Sprite {
		
		public function Main() {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var container : MovieClip = new MovieClip();
			stage.addChild(container);
			
			new Index(container);
		}
	}
}