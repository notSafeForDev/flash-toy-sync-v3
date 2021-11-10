package ui {
	
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Shortcuts {
		
		public static var ANY_MODE : String = "ANY_MODE";
		public static var PLAYER_ONLY : String = "PLAYER_ONLY";
		public static var EDITOR_ONLY : String = "EDITOR_ONLY";
		
		public static var singleSelect : Array = [Keyboard.E];
		public static var multiSelect : Array = [Keyboard.SHIFT];
		
		public static var grabBaseMarker : Array = [Keyboard.B];
		public static var grabStimMarker : Array = [Keyboard.S];
		public static var grabTipMarker : Array = [Keyboard.T];
		
		public static var increaseAnimationWidth : Array = [Keyboard.M, Keyboard.LEFT];
		public static var decreaseAnimationWidth : Array = [Keyboard.M, Keyboard.RIGHT];
		public static var increaseAnimationHeight : Array = [Keyboard.M, Keyboard.UP];
		public static var decreaseAnimationHeight : Array = [Keyboard.M, Keyboard.DOWN];
		
		public static var togglePlaying1 : Array = [Keyboard.ENTER];
		public static var togglePlaying2 : Array = [Keyboard.SPACE];
		
		public static var stepFrameBackwards1 : Array = [Keyboard.LEFT];
		public static var stepFrameBackwards2 : Array = [Keyboard.A];
		public static var stepFrameForwards1 : Array = [Keyboard.RIGHT];
		public static var stepFrameForwards2 : Array = [Keyboard.D];
		
		public static var rewind1 : Array = [Keyboard.SHIFT, Keyboard.LEFT];
		public static var rewind2 : Array = [Keyboard.SHIFT, Keyboard.A];
		
		public static var recordFrame : Array = [Keyboard.R];
		public static var recordScene : Array = [Keyboard.SHIFT, Keyboard.R];
		
		public static var remove : Array = [Keyboard.BACKSPACE];
		
		public static var save : Array = [Keyboard.CONTROL, Keyboard.S];
		
		public static var prepareScript : Array = [Keyboard.P];
		
		public static var copyJSONSaveData : Array = [Keyboard.J];
	}
}