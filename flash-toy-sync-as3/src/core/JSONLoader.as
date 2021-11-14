package core {
	
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class JSONLoader {
		
		public static function browse(_filePathFolder : String, _scope : *, _onLoaded : Function) : void {
			var fileReference : FileReference = new FileReference();
			var fileFilter : FileFilter = new FileFilter("json", "*.json");
			fileReference.browse([fileFilter]);
			
			fileReference.addEventListener(Event.SELECT, onSelect);
			
			function onSelect(e : Event) : void {
				fileReference.addEventListener(Event.COMPLETE, onComplete); 
				fileReference.load();
			}
			
			function onComplete(e : Event) : void {
				try {
					var parsed : Object = parse(fileReference.data.toString());
				} 
				catch (error : Error) {
					_onLoaded.apply(_scope, [{error: error.message}]);   
					return;
				}
				_onLoaded.apply(_scope, [parsed]);
			}
		}
		
		public static function load(_url : String, _scope : *, _onLoaded : Function) : void {
			var urlRequest : URLRequest = new URLRequest(_url);
			var urlLoader : URLLoader = new URLLoader();
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e : IOErrorEvent) : void {
				_onLoaded.apply(_scope, [{error: e.text}]);   
			});
			
			urlLoader.addEventListener(Event.COMPLETE, function(e : Event) : void {
				var parsed : Object;
				try {
					parsed = parse(urlLoader.data);
					_onLoaded.apply(_scope, [parse(urlLoader.data)]);
				} catch (error : Error) {
					_onLoaded.apply(_scope, [{error: error.message}]);
					return;
				}
			});
			
			urlLoader.load(urlRequest);
		}
		
		private static function parse(_string : String) : Object {
			var lines : Array = _string.split("\n");
			for (var i : int = 0; i < lines.length; i++) {
				var urlIndex : int = lines[i].indexOf("://");
				var commentIndex : int = lines[i].indexOf("//");
				if (commentIndex >= 0 && urlIndex != commentIndex - 1) {
					lines[i] = lines[i].substr(0, commentIndex);
				}
			}
			
			return JSON.parse(lines.join(""));
		}
	}
}