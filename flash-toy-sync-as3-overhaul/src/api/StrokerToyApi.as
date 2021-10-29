package api {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StrokerToyApi {
		
		private var _isStarted : Boolean = false;
		private var isResponsePending : Boolean = false;
		
		public function StrokerToyApi() {
			
		}
		
		/**
		 * If the toy is moving
		 * @return
		 */
		public function isStarted() : Boolean {
			return _isStarted;
		}
		
		/**
		 * If the toy is changing state and we are waiting for a response
		 * @return
		 */
		public function isResponsePending() : Boolean {
			return isResponsePending;
		}
		
		public function start() {
			_isStarted = true;
		}
		
		public function stop() {
			_isStarted = false;
		}
	}
}