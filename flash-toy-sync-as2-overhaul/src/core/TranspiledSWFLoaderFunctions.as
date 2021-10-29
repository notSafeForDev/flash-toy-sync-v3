import flash.net.FileReference;

/**
 * ...
 * @author notSafeForDev
 */
class core.TranspiledSWFLoaderFunctions {

	public static function browse(_scope, _onSelected : Function, _customFileDescription : String) : Void {
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

	public static function load(_path : String, _container : MovieClip, _scope, _onLoadedHandler : Function, _onErrorHandler : Function) : Void {
		var listener : Object = {
			onLoadInit: function() {
				_onLoadedHandler.apply(_scope, [_container, -1, -1, -1]);
			},
			onLoadError: function(_target : MovieClip, _errorCode : String, _httpStatus : Number) {
				_onErrorHandler.apply(_scope, [_errorCode]);
			}
		}

		var loader : MovieClipLoader = new MovieClipLoader();
		loader.addListener(listener);

		_container._lockroot = true; // This ensures that the loaded swf still references it's own root, instead of the project's root
		loader.loadClip(_path, _container);
	}
}