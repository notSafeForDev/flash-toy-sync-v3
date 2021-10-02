package core {
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Debug {
		
		/**
		 * Get the elapsed time since the application started, in miliseconds
		 * @return The elapsed time
		 */
		public static function getTime() : Number {
			return flash.utils.getTimer();
		}
	}
}