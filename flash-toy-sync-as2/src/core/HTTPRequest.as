import core.FunctionUtil;
import core.JSON;

/**
 * ...
 * @author notSafeForDev
 */
class core.HTTPRequest {
	
	public static var CONTENT_TYPE_JSON : String = "application/json";
	public static var CONTENT_TYPE_TEXT : String = "text/plain";
	
	public static function send(_url : String, _scope, _responseHandler : Function) : Void {		
		var rest : Array = arguments.slice(3);
		
		var loader : LoadVars = setupLoader(_scope, _responseHandler, rest);
		
		loader.load(_url);
	}
	
	public static function post(_url : String, _body, _contentType : String, _scope, _responseHandler : Function) : Void {		
		var rest : Array = arguments.slice(3);
		
		var loader : LoadVars = setupLoader(_scope, _responseHandler, rest);
		loader.contentType = _contentType;
		loader.addRequestHeader("body", _body.split("\n").join("\\n"));
		
		loader.sendAndLoad(_url, loader, "POST");
	}
	
	private static function setupLoader(_scope, _responseHandler : Function, restArguments : Array) : LoadVars {
		var loader : LoadVars = new LoadVars();
		
		loader.onData = function(_response : String) : Void {
			if (_response.toLowerCase().indexOf("<!doctype html>") == 0) {
				var faultyArgs : Array = [{error: "Server Error"}];
				faultyArgs = faultyArgs.concat(restArguments);
				if (_responseHandler != null) {
					_responseHandler.apply(_scope, faultyArgs);
				}
				return;
			}
			
			var args : Array;
			try {
				args = [JSON.parse(_response)];
			} catch (err : Error) {
				args = [_response];
			}
			
			args = args.concat(restArguments);
			
			if (_responseHandler != null) {
				_responseHandler.apply(_scope, args);
			}
		}
		
		return loader;
	}
}