package core {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SWFLoaderUtil {
		
		/**
		 * Opens a native OS file browse window and passes the selected file's name to the callback
		 * @param	_onSelected		function(_fileName : String) - Called when the user have selected a file, the name of the file is passed to the function
		 */
		public static function browse(_scope : *, _onSelectedHandler : Function, _customFileDescription : String = "") : void {
			var fileReference : FileReference = new FileReference();
			var fileDescription : String = _customFileDescription ? _customFileDescription : "swf";
			var fileFilter : FileFilter = new FileFilter(fileDescription, "*.swf");
			fileReference.browse([fileFilter]);
			
			fileReference.addEventListener(Event.SELECT, onSelect);
			
			function onSelect(e : Event) : void {
				_onSelectedHandler.apply(_scope, [fileReference.name]);
			}
		}
		
		/**
		 * Loads an swf file into a specified MovieClip
		 * @param	_path				The location of the swf file
		 * @param	_container			The MovieClip to load the swf into
		 * @param 	_onLoadedHandler 	(optional) function(_swf : MovieClip, _stageWidth : Number, _stageHeight : Number, _frameRate) 
		 * 								Called when the swf is loaded, the loaded content as a MovieClip is passed to the function
		 * @param 	_onErrorHandler 	(optional) function(_error : String) 
		 * 								Called when the swf is loaded, the loaded content as a MovieClip is passed to the function
		 */
		public static function load(_path : String, _container : MovieClip, _scope : *, _onLoadedHandler : Function = null, _onErrorHandler : Function = null) : void {	
			var loader : Loader = new Loader();
			
			function onLoaderComplete(e : Event) : void {
				var actionScriptVersion : Number = loader.contentLoaderInfo.actionScriptVersion;
				if (actionScriptVersion != 3) {
					_onErrorHandler.apply(_scope, ["Unable to load the swf, it's actionscript version: " + actionScriptVersion + ", can not be loaded"]);
					return;
				}
				
				var swf : MovieClip;
				
				try {
					swf = MovieClip(loader.content);
				} catch (error : Error) {
					if (_onErrorHandler != null) {
						_onErrorHandler.apply(_scope, [error.message]);
					}
					return;
				}
				
				_container.addChild(loader);
				if (_onLoadedHandler != null) {
					_onLoadedHandler.apply(_scope, [swf, loader.contentLoaderInfo.width, loader.contentLoaderInfo.height, loader.contentLoaderInfo.frameRate]);
				}
			}
			
			function onLoaderError(e : IOErrorEvent) : void {
				if (_onErrorHandler != null) {
					_onErrorHandler(e.text);
				}
			}
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
			
			loader.load(new URLRequest(_path));
		}
	}
}