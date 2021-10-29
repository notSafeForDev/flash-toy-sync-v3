/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import api.*
import core.JSON

/**
 * ...
 * @author notSafeForDev
 */
class api.StrokerToyApi {
	
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