import core.FunctionUtil;
import core.JSON;
import flash.net.FileReference;

class core.JSONLoader {
	
	static function browse(_filePathFolder : String, _scope, _onLoaded : Function) {
		var fileReference : FileReference = new FileReference();
		var jsonLoader : LoadVars = new LoadVars();
		var listener : Object = new Object();
		
		var onLoaded : Function = FunctionUtil.bind(_scope, _onLoaded);
		
		fileReference.addListener(listener);
		fileReference.browse([{description: "json", extension: "*.json"}]);
		
		listener.onSelect = function(file : FileReference) {
			if (_filePathFolder == "") {
				JSONLoader.load(file.name, onLoaded);
			}
			else {
				JSONLoader.load(_filePathFolder + "/" + file.name, onLoaded);
			}
		}
	}
	
	static function load(_path : String, _scope, _onLoaded : Function) {
		var loader : LoadVars = new LoadVars();
		
		loader.onData = function(_data : String) {
			if (_data == undefined) {
				_onLoaded.apply(_scope, [{error: _path + " not found"}]);
				return;
			}
			try {
				var json : Object = JSON.parse(_data);
				_onLoaded.apply(_scope, [json]);
			} 
			catch (error) {
				_onLoaded.apply(_scope, [{error: error.message}]);
			}
		};
		
		loader.load(_path);
	}
}