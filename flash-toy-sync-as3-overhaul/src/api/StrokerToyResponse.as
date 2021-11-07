package api {
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class StrokerToyResponse {
		
		public var success : Boolean;
		public var error : String;
		
		public function StrokerToyResponse(_success : Boolean, _error : String) {
			success = _success;
			error = _error;
		}
	}
}