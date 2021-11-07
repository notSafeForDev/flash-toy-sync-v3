package components {
	import core.HTTPRequestUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HTTPRequest {
		
		public static var CONTENT_TYPE_TEXT : String = "text/plain";
		public static var CONTENT_TYPE_JSON : String = "application/json";
		
		/**
		 * Make a get request
		 * @param	_url				The url to make the request to
		 * @param	_scope				The owner of the response and error handler
		 * @param	_responseHandler	function(_response : *) - The callback when a response have been recieved
		 * @param	_errorHandler		function(_text : String) - The callback when an error have been recieved
		 * @param	...rest				Any values to pass as arguments to the callback
		 */
		public static function send(_url : String, _scope : *, _responseHandler : Function, _errorHandler : Function, _restArguments : Array) : void {
			HTTPRequestUtil.send(_url, _scope, _responseHandler, _errorHandler, _restArguments);
		}
		
		/**
		 * Make a post request, note that in the AS2 version, the body of the post request gets sent as FlashVars
		 * @param	_url				The url to make the request to
		 * @param	_body				The content to send in the request
		 * @param	_contentType		The type for the contrent to send
		 * @param	_scope				The owner of the response and error handler
		 * @param	_responseHandler	function(_response : *) - The callback when a response have been recieved
		 * @param	_errorHandler		function(_text : String) - The callback when an error have been recieved
		 * @param	...rest				Any values to pass as arguments to the callback
		 */
		public static function post(_url : String, _contentType : String, _body : String, _scope : *, _responseHandler : Function, _errorHandler : Function, _restArguments : Array) : void {
			HTTPRequestUtil.post(_url, _body, _contentType, _scope, _responseHandler, _errorHandler, _restArguments);
		}
	}
}