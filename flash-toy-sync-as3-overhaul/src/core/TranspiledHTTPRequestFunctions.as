package core {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TranspiledHTTPRequestFunctions {
		
		/**
		 * Make a get request
		 * @param	_url				The url to make the request to
		 * @param	_scope				The owner of the response and error handler
		 * @param	_responseHandler	function(_response : *) - The callback when a response have been recieved
		 * @param	_errorHandler		function(_text : String) - The callback when an error have been recieved
		 * @param	_restArguments		Any values to pass as arguments to the callback
		 */
		public static function send(_url : String, _scope : *, _responseHandler : Function, _errorHandler : Function, _restArguments : Array) : void {
			var loader : URLLoader = setupLoader(_scope, _responseHandler, _errorHandler, _restArguments);
			
			loader.load(new URLRequest(_url));
		}
		
		/**
		 * Make a post request, note that in the AS2 version, the body of the post request gets sent as FlashVars
		 * @param	_url				The url to make the request to
		 * @param	_body				The content to send in the request
		 * @param	_contentType		The type for the contrent to send
		 * @param	_scope				The owner of the response and error handler
		 * @param	_responseHandler	function(_response : *) - The callback when a response have been recieved
		 * @param	_errorHandler		function(_text : String) - The callback when an error have been recieved
		 * @param	_restArguments		Any values to pass as arguments to the callback
		 */
		public static function post(_url : String, _body : *, _contentType : String, _scope : *, _responseHandler : Function, _errorHandler : Function, _restArguments : Array) : void {
			var loader : URLLoader = setupLoader(_scope, _responseHandler, _errorHandler, _restArguments);
			
			var urlRequest : URLRequest = new URLRequest(_url);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = _body;
			urlRequest.contentType = _contentType;
			
			loader.load(urlRequest);
		}
		
		private static function setupLoader(_scope : *, _responseHandler : Function, _errorHandler : Function, restArguments : Array) : URLLoader {
			var loader : URLLoader = new URLLoader();
			
			var args : Array;
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e : IOErrorEvent) : void {
				args = [e.text].concat(restArguments);
				if (_errorHandler != null) {
					_errorHandler.apply(_scope args);
				}
			});
			
			loader.addEventListener(Event.COMPLETE, function(e : Event) : void {
				var data : String = loader.data;
				
				try {
					args = [JSON.parse(data)];
				} catch (err : Error) {
					args = [data];
				}
				
				args = args.concat(restArguments);
				
				if (_responseHandler != null) {
					_responseHandler.apply(_scope, args);
				}
			});
			
			return loader;
		}
	}
}