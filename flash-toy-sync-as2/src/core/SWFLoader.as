import flash.net.FileReference;

class core.SWFLoader {
	
	public var swf : MovieClip;
		
	public var onError : Function;
	
	function SWFLoader() {
		
	}
	
	public function browse(_onSelected : Function) {
		var fileReference : FileReference = new FileReference();
		var jsonLoader : LoadVars = new LoadVars();
		var listener : Object = new Object();
		
		fileReference.addListener(listener);
		fileReference.browse([{description: "swf", extension: "*.swf"}]);
		
		listener.onSelect = function(_file : FileReference) {
			_onSelected(_file);
		}
	}
	
	public function load(_path : String, _container : MovieClip, _onLoaded : Function) {		
		var self = this;
		
		var listener : Object = {
			onLoadInit: function() {
				_onLoaded(_container, -1, -1, -1);
			},
			onLoadError: function(target_mc : MovieClip, errorCode : String, httpStatus : Number) {
				if (self.onError != null) {
					self.onError(errorCode);
				}
			}
		}
		
		var loader : MovieClipLoader = new MovieClipLoader();
		loader.addListener(listener);
		
		_container._lockroot = true; // This ensures that the loaded swf still references it's own root, instead of the project's root
		loader.loadClip(_path, _container);
	}
}