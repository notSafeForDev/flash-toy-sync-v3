import core.FunctionUtil;
import core.JSON;

/**
 * ...
 * @author notSafeForDev
 */
class core.HTTPRequest {
	
	public static function send(_url : String, _scope, _responseHandler : Function) : Void {
		var loader : LoadVars = new LoadVars();
		
		var responseHandler : Function = null;
		if (_responseHandler != null) {
			responseHandler = FunctionUtil.bind(_scope, _responseHandler);
		}
		
		var rest : Array = arguments.slice(3);
		
		loader.onData = function(_response : String) {
			if (_response.indexOf("<!DOCTYPE html>") == 0) {
				var faultyArgs : Array = [{error: "Bad Request"}];
				faultyArgs = faultyArgs.concat(rest);
				if (_responseHandler != null) {
					_responseHandler.apply(_scope, faultyArgs);
				}
				return;
			}
			
			var response : Object = JSON.parse(_response);
			var args : Array = [response];
			args = args.concat(rest);
			if (_responseHandler != null) {
				_responseHandler.apply(_scope, args);
			}
		}
		
		loader.load(_url);
	}
}