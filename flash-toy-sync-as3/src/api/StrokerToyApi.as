package api {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StrokerToyApi {
		
		private var _isResponsePending : Boolean = false;
		private var _isScriptPrepared : Boolean = false;
		private var _isPlayingScript : Boolean = false;
		
		public function StrokerToyApi() {
			
		}
		
		/**
		 * Check if it's possible to make a connection with the toy
		 * @return Wether it's possible
		 */
		public function canConnect() : Boolean {
			return true;
		}
		
		/**
		 * If the toy is changing state and a response is not yet recieved
		 * @return
		 */
		public function isResponsePending() : Boolean {
			return _isResponsePending;
		}
		
		/**
		 * Check if a script is prepared
		 * @return Wether it is prepared
		 */
		public function isScriptPrepared() : Boolean {
			return _isScriptPrepared;
		}
		
		/**
		 * Check if a script is playing
		 * @return Wether it is playing
		 */
		public function isPlayingScript() : Boolean {
			return _isPlayingScript;
		}
		
		/**
		 * Prepares a script for the toy, which describes the slide positions at different timestamps
		 * @param	_connectionInfo		Custom info specific to the toy
		 * @param	_positions			An array of positions and timestamps
		 * @param 	_responseHandler	Callback for when a response have been recieved
		 */
		public function prepareScript(_positions : Vector.<StrokerToyScriptPosition>, _scope : *, _responseHandler : Function) : void {
			_isResponsePending = true;
			_isScriptPrepared = false;
		}
		
		public function clearPreparedScript() : void {
			_isScriptPrepared = false;
			
			if (_isPlayingScript == true) {
				stopScript(this, onStopScriptResponse);
			}
		}
		
		public function playScript(_time : Number, _scope : *, _responseHandler : Function) : void {
			_isResponsePending = true;
		}
		
		public function stopScript(_scope : *, _responseHandler : Function) : void {
			_isResponsePending = true;
		}
		
		protected function onPrepareScriptResponse(_response : StrokerToyResponse) : void {
			_isResponsePending = false;
			_isScriptPrepared = _response.success;
		}
		
		protected function onPlayScriptResponse(_response : StrokerToyResponse) : void {
			_isResponsePending = false;
			_isPlayingScript = _response.success;
		}
		
		protected function onStopScriptResponse(_response : StrokerToyResponse) : void {
			_isResponsePending = false;
			if (_response.success == true) {
				_isPlayingScript = false;
			}
		}
	}
}