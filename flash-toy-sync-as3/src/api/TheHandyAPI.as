package api {
	
	import core.Debug;
	import core.FunctionUtil;
	import core.HTTPRequest;
	import core.Timeout;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TheHandyAPI {
		
		public var connectionKey : String = "";
		
		private var baseUrl : String = "https://www.handyfeeling.com/api/v1/"
		private var serverTimeDelta : Number = 0;
		private var isPlaying : Boolean = false;
		
		private var totalApiCalls : Number = 0;
		
		public function TheHandyAPI() {
			
		}
		
		public function syncPrepare(_csvUrl : String, _scope : *, _responseHandler : Function) : void {
			if (connectionKey == "") {
				throw new Error("Unable to send syncPrepare request, no connection key have been set");
			}
			
			// We add the number of total api calls to the timeout, in order to make it seem like a unique request each time,
			// otherwise it will use an existing cached response if it has one, which will result in no request being made to the server
			var url : String = baseUrl + connectionKey + "/syncPrepare?url=" + _csvUrl + "&timeout=" + (20000 + totalApiCalls);
			HTTPRequest.send(url, _scope, _responseHandler);
			totalApiCalls++;
		}
		
		public function syncPrepareFromCSV(_csv : String, _scope : *, _responseHandler : Function) : void {
			if (connectionKey == "") {
				throw new Error("Unable to send uploadCSVAndSync request, no connection key have been set");
			}
			
			// TODO: Verify that the response for this doesn't get cached
			var prepareUrl : String = "https://hump-feed.herokuapp.com/prepareScriptForTheHandy/" + connectionKey;
			var contentType : String = HTTPRequest.CONTENT_TYPE_TEXT;
			
			HTTPRequest.post(prepareUrl, _csv, contentType, _scope, _responseHandler);
		}
		
		public function syncPlay(_time : Number, _adjustOffset : Boolean, _scope : *, _responseHandler : Function) : void {
			if (connectionKey == "") {
				throw new Error("Unable to send syncPlay request, no connection key have been set");
			}
			
			var offset : Number = isPlaying && _adjustOffset ? serverTimeDelta : 0;
			
			isPlaying = true;
			
			var date : Date = new Date();
			var serverTime : Number = date.getTime() + offset;
			
			var url : String = baseUrl + connectionKey + "/syncPlay?play=true&time=" + _time + "&serverTime=" + serverTime;
			
			HTTPRequest.send(url, _scope, onSyncPlayResponse, _adjustOffset, _scope, _responseHandler);
			totalApiCalls++;
		}
		
		private function onSyncPlayResponse(_response : Object, _adjustOffset : Boolean, _scope : * , _responseHandler : Function) : void {
			if (_response.error != undefined) {
				isPlaying = false;
			}
			serverTimeDelta = _response.serverTimeDelta;
			if (_responseHandler != null) {
				_responseHandler.apply(_scope, [_response]);
			}
			if (_adjustOffset == true) {
				syncOffset(-serverTimeDelta, this, null);
			}
		}
		
		public function syncOffset(_offset : Number, _scope : *, _responseHandler : Function) : void {
			if (connectionKey == "") {
				throw new Error("Unable to send syncOffset request, no connection key have been set");
			}
			
			var date : Date = new Date();
			
			var url : String = baseUrl + connectionKey + "/syncOffset?offset=" + _offset + "&timeout=" + (5000 + totalApiCalls);
			
			HTTPRequest.send(url, _scope, _responseHandler);
			totalApiCalls++;
		}
		
		public function syncStop(_scope : *, _responseHandler : Function) : void {
			if (connectionKey == "") {
				throw new Error("Unable to send syncStop request, no connection key have been set");
			}
			
			isPlaying = false;
			
			var date : Date = new Date();
			
			var url : String = baseUrl + connectionKey + "/syncPlay?play=false&timeout=" + (5000 + totalApiCalls);
			
			HTTPRequest.send(url, _scope, _responseHandler);
			totalApiCalls++;
		}
	}
}