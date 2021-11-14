package {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
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
			
			// Fixes an issue where keyboard input stops registering after having clicked on the external swf
			stage.addEventListener(FocusEvent.FOCUS_OUT, function(e : FocusEvent) : void {
				stage.focus = stage;
			});
		}
	}
}