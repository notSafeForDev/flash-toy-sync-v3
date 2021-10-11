package {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import core.StageUtil;
	
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
			StageUtil.initialize(stage, stage.frameRate);
			
			var container : MovieClip = new MovieClip();
			container.name = "root";
			stage.addChild(container);
			
			var index : Index = new Index(container, "animations/karas-nightlife.swf");
			
			// Fixes an issue where keyboard input stops registering after having clicked on the external swf
			stage.addEventListener(FocusEvent.FOCUS_OUT, function(e : FocusEvent) : void {
				stage.focus = stage;
			});
			
			// List of flash animations and how well the current automation tools will work on them
			/*
			AS3
			bioshock-intimate.swf				- Decent, Though the camera movements might make it a bit annoying to work with
			blazblue-makoto-sex-session.swf		- Decent
			brandy-2.swf						- Mixed, it keeps switching between different variations of animations
			gaper-mario.swf						- Bad, Doesn't load due to stage being null
			hentaikey-girl-5.swf 				- Decent, (Breaks when using debug flash player version 32, works in flash player version 11)
			karas-nightlife.swf					- Good
			peachypop-kat-sitting.swf			- Good
			purple-demin-girl.swf				- Good
			shantae-risky-bouncy-titfun.swf		- Good
			spikeshi.swf						- Poorly, It's done mostly frame by frame, with only her eyes selecable, which at least helps for the few blowjob only scenes
			*/
		}
	}
}