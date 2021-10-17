package core {
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HTTPRequest {
		
		public static function send(_url : String, _scope : *, _responseHandler : Function, ...rest) : void {
			var loader : URLLoader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, function(e : Event) : void {
				var args : Array = [JSON.parse(loader.data)];
				args = args.concat(rest);
				if (_responseHandler != null) {
					_responseHandler.apply(_scope, args);
				}
			});
			
			loader.load(new URLRequest(_url));
		}
	}
}