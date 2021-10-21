package core {
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HTTPRequest {
		
		public static var CONTENT_TYPE_JSON : String = "application/json";
		public static var CONTENT_TYPE_TEXT : String = "text/plain";
		
		public static function send(_url : String, _scope : *, _responseHandler : Function, ...rest) : void {
			var loader : URLLoader = setupLoader(_scope, _responseHandler, rest);
			
			loader.load(new URLRequest(_url));
		}
		
		/**
		 * Make a post request
		 * @param	_url				The url to make the request to
		 * @param	_body				The content to send in the request, note that in the AS2 version, this does instead get added to the header
		 * @param	_contentType		The type for the contrent to send
		 * @param	_scope				The owner of the response handler
		 * @param	_responseHandler	function(_response : *) - The callback when a response have been recieved
		 * @param	...rest				Any values to pass as arguments to the callback
		 */
		public static function post(_url : String, _body : *, _contentType : String, _scope : *, _responseHandler : Function, ...rest) : void {
			var loader : URLLoader = setupLoader(_scope, _responseHandler, rest);
			
			var urlRequest : URLRequest = new URLRequest(_url);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = _body;
			urlRequest.contentType = _contentType;
			
			loader.load(urlRequest);
		}
		
		private static function setupLoader(_scope : *, _responseHandler : Function, restArguments : Array) : URLLoader {
			var loader : URLLoader = new URLLoader();
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e : IOErrorEvent) : void {
				trace(e.toString(), e.type, e.target, e.text);
			});
			
			loader.addEventListener(Event.COMPLETE, function(e : Event) : void {
				var data : String = loader.data;
				
				if (data.toLowerCase().indexOf("<!doctype html>") == 0) {
					var faultyArgs : Array = [{error: "Server error"}];
					faultyArgs = faultyArgs.concat(restArguments);
					if (_responseHandler != null) {
						_responseHandler.apply(_scope, faultyArgs);
					}
					return;
				}
				
				var args : Array;
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