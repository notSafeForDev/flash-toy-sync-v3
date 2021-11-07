package api {
	
	import components.HTTPRequest;
	import states.ToyStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TheHandyApi extends StrokerToyApi {
		
		private var totalAPICalls : Number = 0;
		
		private var theHandyAPIUrl : String = "https://www.handyfeeling.com/api/v1/";
		
		private var serverTimeDelta : Number;
		
		public function TheHandyApi() {
			super();
			
			ToyStates.listen(this, onTheHandyConnectionKeyStateChange, [ToyStates.theHandyConnectionKey]);
		}
		
		public override function canConnect() : Boolean {
			return super.canConnect() && ToyStates.theHandyConnectionKey.value != "";
		}
		
		public override function prepareScript(_positions : Vector.<StrokerToyScriptPosition>, _scope : *, _responseHandler : Function) : void {
			super.prepareScript(_positions, _scope, _responseHandler);
			
			var csv : String = "\n";
			for (var i : Number = 0; i < _positions.length; i++) {
				var position : Number = 100 - Math.round(_positions[i].position * 100);
				csv += _positions[i].time + "," + position + "\n";
			}
			
			var prepareUrl : String = "https://hump-feed.herokuapp.com/prepareScriptForTheHandy/" + ToyStates.theHandyConnectionKey.value;
			var contentType : String = HTTPRequest.CONTENT_TYPE_TEXT;
			
			HTTPRequest.post(prepareUrl, contentType, csv, this, onPrepareScriptHTTPResponse, onPrepareScriptHTTPError, [_scope, _responseHandler]);
		}
		
		public override function playScript(_time : Number, _scope : *, _responseHandler : Function) : void {
			super.playScript(_time, _scope, _responseHandler);
			
			var date : Date = new Date();
			var serverTime : Number = date.getTime() + serverTimeDelta;
			var connectionKey : String = ToyStates.theHandyConnectionKey.value;
			
			var url : String = theHandyAPIUrl + connectionKey + "/syncPlay?play=true&time=" + _time + "&serverTime=" + serverTime;
			
			HTTPRequest.send(url, this, onPlayScriptHTTPResponse, onPlayScriptHTTPError, [_scope, _responseHandler]);
			totalAPICalls++;
		}
		
		public override function stopScript(_scope : * , _responseHandler : Function) : void {
			super.stopScript(_scope, _responseHandler);
			
			var connectionKey : String = ToyStates.theHandyConnectionKey.value;
			
			// We add the number of total api calls to the timeout, in order to make it seem like a unique request each time,
			// otherwise it will use an existing cached response if it has one, which will result in no request being made to the server
			var url : String = theHandyAPIUrl + connectionKey + "/syncPlay?play=false&timeout=" + (5000 + totalAPICalls);
			
			HTTPRequest.send(url, this, onStopScriptHTTPResponse, onStopScriptHTTPError, [_scope, _responseHandler]);
			totalAPICalls++;
		}
		
		private function onTheHandyConnectionKeyStateChange() : void {
			var connectionKey : String = ToyStates.theHandyConnectionKey.value;
			
			if (connectionKey != "") {
				HTTPRequest.send(theHandyAPIUrl + connectionKey + "/getServerTime", this, onGetServerTimeResponse, null, []);
			}
		}
		
		private function onGetServerTimeResponse(_response : Object) : void {
			var date : Date = new Date();
			serverTimeDelta = _response.serverTime - date.getTime();
		}
		
		private function onPrepareScriptHTTPResponse(_response : Object, _scope : * , _responseHandler : Function) : void {
			var error : String = "";
			if (_response.success != true) {
				error = _response.error || "Unable to prepare script";
			}
			var response : StrokerToyResponse = new StrokerToyResponse(_response.success || false, error);
			_responseHandler.apply(_scope, [response]);
			onPrepareScriptResponse(response);
		}
		
		private function onPrepareScriptHTTPError(_error : String, _scope : *, _responseHandler : Function) : void {
			var response : StrokerToyResponse = new StrokerToyResponse(false, _error);
			_responseHandler.apply(_scope, [response]);
			onPrepareScriptResponse(response);
		}
		
		private function onPlayScriptHTTPResponse(_response : Object, _scope : * , _responseHandler : Function) : void {
			var error : String = "";
			if (_response.success != true) {
				error = _response.error || "Unable to play script";
			}
			var response : StrokerToyResponse = new StrokerToyResponse(_response.success || false, error);
			_responseHandler.apply(_scope, [response]);
			onPlayScriptResponse(response);
		}
		
		private function onPlayScriptHTTPError(_error : String, _scope : * , _responseHandler : Function) : void {
			var response : StrokerToyResponse = new StrokerToyResponse(false, _error);
			_responseHandler.apply(_scope, [response]);
			onPlayScriptResponse(response);
		}
		
		private function onStopScriptHTTPResponse(_response : Object, _scope : * , _responseHandler : Function) : void {
			var error : String = "";
			if (_response.success != true) {
				error = _response.error || "Unable to stop script";
			}
			var response : StrokerToyResponse = new StrokerToyResponse(_response.success || false, error);
			_responseHandler.apply(_scope, [response]);
			onStopScriptResponse(response);
		}
		
		private function onStopScriptHTTPError(_error : String, _scope : * , _responseHandler : Function) : void {
			var response : StrokerToyResponse = new StrokerToyResponse(false, _error);
			_responseHandler.apply(_scope, [response]);
			onStopScriptResponse(response);
		}
	}
}