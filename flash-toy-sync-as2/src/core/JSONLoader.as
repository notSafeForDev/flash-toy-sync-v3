import flash.net.FileReference;

import Core.JSON;

class core.JSONLoader {
	
	static function browse(_filePathFolder : String, _onLoaded : Function) {
		var fileReference : FileReference = new FileReference();
		var jsonLoader : LoadVars = new LoadVars();
		var listener : Object = new Object();
		
		fileReference.addListener(listener);
		fileReference.browse([{description: "json", extension: "*.json"}]);
		
		listener.onSelect = function(file : FileReference) {
			if (_filePathFolder == "") {
				JSONLoader.load(file.name, _onLoaded);
			}
			else {
				JSONLoader.load(_filePathFolder + "/" + file.name, _onLoaded);
			}
		}
	}
	
	static function load(_path : String, _onLoaded : Function) {
		var loader : LoadVars = new LoadVars();
		
		loader.onData = function(_data : String) {
			if (_data == undefined) {
				_onLoaded({error: _path + " not found"});
				return;
			}
			try {
				var json : Object = JSON.parse(_data);
				_onLoaded(json);
			} 
			catch (error) {
				_onLoaded({error: error.message});
			}
		};
		
		loader.load(_path);
	}
}