package core {
	
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class JSONLoader {
		
		public static function browse(_filePathFolder : String, _onLoaded : Function) {
			var fileReference : FileReference = new FileReference();
			var fileFilter : FileFilter = new FileFilter("json", "*.json");
			fileReference.browse([fileFilter]);
			
			fileReference.addEventListener(Event.SELECT, onSelect);
			
			function onSelect(e : Event) {
				fileReference.addEventListener(Event.COMPLETE, onComplete); 
				fileReference.load();
			}
			
			function onComplete(e : Event) {
				try {
					var parsed : Object = parse(fileReference.data.toString());
				} 
				catch (error) {
					_onLoaded({error: error});
					return;
				}
				_onLoaded(parsed);
			}
		}
		
		public static function load(_url : String, _onLoaded : Function) {
			var urlRequest : URLRequest = new URLRequest(_url);
			var urlLoader : URLLoader = new URLLoader();
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e : IOErrorEvent) {
				_onLoaded({error: e.text});   
			});
			
			urlLoader.addEventListener(Event.COMPLETE, function(e : Event) {
				_onLoaded(parse(urlLoader.data));
			});
			
			urlLoader.load(urlRequest);
		}
		
		static function parse(_string : String) {
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