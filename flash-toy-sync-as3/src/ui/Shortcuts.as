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
		
		public static var moveStimTo0 : Array = [Keyboard.NUMPAD_0];
		public static var moveStimTo1 : Array = [Keyboard.NUMPAD_1];
		public static var moveStimTo2 : Array = [Keyboard.NUMPAD_2];
		public static var moveStimTo3 : Array = [Keyboard.NUMPAD_3];
		public static var moveStimTo4 : Array = [Keyboard.NUMPAD_4];
		public static var moveStimTo5 : Array = [Keyboard.NUMPAD_5];
		public static var moveStimTo6 : Array = [Keyboard.NUMPAD_6];
		public static var moveStimTo7 : Array = [Keyboard.NUMPAD_7];
		public static var moveStimTo8 : Array = [Keyboard.NUMPAD_8];
		public static var moveStimTo9 : Array = [Keyboard.NUMPAD_9];
		
		public static var remove : Array = [Keyboard.BACKSPACE];
		
		public static var save1 : Array = [Keyboard.CONTROL, Keyboard.S];
		public static var save2 : Array = [Keyboard.COMMAND, Keyboard.S];
		
		public static var prepareScript : Array = [Keyboard.P];
		
		public static var copyJSONSaveData : Array = [Keyboard.J];
		
		// TODO: Remove this after the next release
		public static var clearStopFrame : Array = [Keyboard.CONTROL, Keyboard.I];
	}
}