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
		
		public function TheHandyAPI() {
			
		}
		
		public function syncPrepare(_csvUrl : String, _scope : *, _responseHandler : Function) : void {
			if (connectionKey == "") {
				throw new Error("Unable to send syncPrepare request, no connection key have been set");
			}
			
			var date : Date = new Date();
			
			// disableCache is not actually a parameter of the api, it's a made up parameter in order to make sure that the url is always different each time,
			// Otherwise the urlLoader uses cached responses, which would result in no new requests being made to the server
			var url : String = baseUrl + connectionKey + "/syncPrepare?disableCache=" + date.getTime() + "&url=" + _csvUrl;
			HTTPRequest.send(url, this, function(_response : Object) : void {
				_responseHandler.apply(_scope, [_response]);
			});
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
			
			HTTPRequest.send(url, this, onSyncPlayResponse, _adjustOffset, _scope, _responseHandler);
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
				syncOffset(-serverTimeDelta);
			}
		}
		
		private function syncOffset(_offset : Number) : void {
			if (connectionKey == "") {
				throw new Error("Unable to send syncOffset request, no connection key have been set");
			}
			
			var date : Date = new Date();
			
			var url : String = baseUrl + connectionKey + "/syncOffset?disableCache=" + date.getTime() + "&offset=" + _offset;
			
			HTTPRequest.send(url, this, null);
		}
		
		public function syncStop(_scope : *, _responseHandler : Function) : void {
			if (connectionKey == "") {
				throw new Error("Unable to send syncStop request, no connection key have been set");
			}
			
			isPlaying = false;
			
			var date : Date = new Date();
			
			var url : String = baseUrl + connectionKey + "/syncPlay?disableCache=" + date.getTime() + "&play=false";
			
			HTTPRequest.send(url, this, function(_response : Object) : void {
				if (_responseHandler != null) {
					_responseHandler.apply(_scope, [_response]);
				}
			});
		}
	}
}