import flash.net.FileReference;

/**
 * ...
 * @author notSafeForDev
 */
class core.SWFLoader {

	private var loader : MovieClipLoader;
	
	private var loadedSWF : MovieClip;
	
	public function SWFLoader() {
		loader = new MovieClipLoader();
	}
	
	public function browse(_scope, _onSelected : Function, _customFileDescription : String) : Void {
		var fileReference : FileReference = new FileReference();
		var jsonLoader : LoadVars = new LoadVars();
		var listener : Object = new Object();
		var fileDescription : String = _customFileDescription ? _customFileDescription : "swf";

		fileReference.addListener(listener);
		fileReference.browse([{description: fileDescription, extension: "*.swf"}]);

		listener.onSelect = function(_file : FileReference) {
			_onSelected.apply(_scope, [_file.name]);
		}
	}

	public function load(_path : String, _container : MovieClip, _scope, _onLoadedHandler : Function, _onErrorHandler : Function) : Void {
		var swf : MovieClip = _container.createEmptyMovieClip("loadedSWF", _container.getNextHighestDepth());
		loadedSWF = swf; // We need a local copy of the loadedSWF, otherwise it gives an unknow variable error when it's referenced in the function below
		
		var listener : Object = {
			onLoadInit: function() {
				_onLoadedHandler.apply(_scope, [swf, -1, -1, -1]);
			},
			onLoadError: function(_target : MovieClip, _errorCode : String, _httpStatus : Number) {
				_onErrorHandler.apply(_scope, [_errorCode]);
			}
		}

		loader.addListener(listener);

		swf._lockroot = true; // This ensures that the loaded swf still references it's own root, instead of the project's root
		loader.loadClip(_path, loadedSWF);
	}
	
	public function unload() : Void {
		loader.unloadClip(loadedSWF);
	}
}