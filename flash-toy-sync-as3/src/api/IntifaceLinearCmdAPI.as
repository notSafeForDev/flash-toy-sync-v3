package api {
	
	import components.HTTPRequest;
	import components.Timeout;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class IntifaceLinearCmdAPI extends StrokerToyApi {
		
		public function IntifaceLinearCmdAPI() {
			super();
		}
		
		public override function canConnect() : Boolean {
			return super.canConnect();
		}
		
		public override function prepareScript(_positions : Vector.<StrokerToyScriptPosition>, _scope : *, _responseHandler : Function) : void {
			super.prepareScript(_positions, _scope, _responseHandler);
			
			var positionsJSON : Array = [];
			for (var i : Number = 0; i < _positions.length; i++) {
				positionsJSON.push({
					position: 1 - _positions[i].position,
					time: _positions[i].time
				});
			}
			
			var url : String = "http://localhost:3000/prepareScript";
			var contentType : String = HTTPRequest.CONTENT_TYPE_TEXT; // We use text instead of JSON, as the AS2 version can't post JSON
			var positionsJSONString : String = JSON.stringify(positionsJSON);
			
			HTTPRequest.post(url, contentType, positionsJSONString, this, onPrepareScriptHTTPResponse, onPrepareScriptHTTPError, [_scope, _responseHandler]);
		}
		
		public override function playScript(_time : Number, _scope : *, _responseHandler : Function) : void {
			super.playScript(_time, _scope, _responseHandler);
			
			// ignoreCache is added to the end of the url to prevent it from loading previous responses from cache, which would result in no request being made to the server
			var url : String = "http://localhost:3000/playScript?time=" + _time + "?ignoreCache=" + getTimer();
			
			HTTPRequest.send(url, this, onPlayScriptHTTPResponse, onPlayScriptHTTPError, [_scope, _responseHandler]);
		}
		
		public override function stopScript(_scope : *, _responseHandler : Function) : void {
			super.stopScript(_scope, _responseHandler);
			
			var url : String = "http://localhost:3000/stop?ignoreCache=" + getTimer();
			
			HTTPRequest.send(url, this, onStopScriptHTTPResponse, onStopScriptResponse, [_scope, _responseHandler]);
			
			_responseHandler.apply(_scope, [new StrokerToyResponse(true, "")]);
		}
		
		private function onPrepareScriptHTTPResponse(_response : Object, _scope : * , _responseHandler : Function) : void {
			if (_response.error != undefined) {
				var errorResponse : StrokerToyResponse = new StrokerToyResponse(false, _response.error);
				_responseHandler.apply(_scope, [errorResponse]);
				return;
			}
			
			var response : StrokerToyResponse = new StrokerToyResponse(true, "");
			_responseHandler.apply(_scope, [response]);
			onPrepareScriptResponse(response);
		}
		
		private function onPrepareScriptHTTPError(_error : String, _scope : * , _responseHandler : Function) : void {
			var error : String = "Unable to prepare script, make sure that intiface-bridge is running";
			
			var response : StrokerToyResponse = new StrokerToyResponse(false, error);
			_responseHandler.apply(_scope, [response]);
			onPrepareScriptResponse(response);
		}
		
		private function onPlayScriptHTTPResponse(_response : Object, _scope : *, _responseHandler : Function) : void {
			var response : StrokerToyResponse = new StrokerToyResponse(true, "");
			_responseHandler.apply(_scope, [response]);
			onPlayScriptResponse(response);
		}
		
		private function onPlayScriptHTTPError(_error : String, _scope : *, _responseHandler : Function) : void {
			var response : StrokerToyResponse = new StrokerToyResponse(false, _error);
			_responseHandler.apply(_scope, [response]);
			onPlayScriptResponse(response);
		}
		
		private function onStopScriptHTTPResponse(_response : Object, _scope : *, _responseHandler : Function) : void {
			var response : StrokerToyResponse = new StrokerToyResponse(true, "");
			_responseHandler.apply(_scope, [response]);
			onStopScriptResponse(response);
		}
		
		private function onStopScriptHTTPError(_error : String, _scope : *, _responseHandler : Function) : void {
			var response : StrokerToyResponse = new StrokerToyResponse(false, _error);
			_responseHandler.apply(_scope, [response]);
			onStopScriptResponse(response);
		}
	}
}