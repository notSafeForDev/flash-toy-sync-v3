package {
	
	import core.StageUtil;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import components.ExternalSWF;
	
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
			StageUtil.initialize(stage);
			
			var container : MovieClip = new MovieClip();
			container.name = "root";
			stage.addChild(container);
			
			new Index(container, "animations/karas-nightlife.swf");
		}
	}
}