package core {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class SWFLoader {
		
		public var swf : MovieClip;
		
		public var onError : Function;
		
		function SWFLoader() {
			
		}
		
		/**
		 * Opens a native OS file browse window and passes the selected file's name to the callback
		 * @param	_onSelected		Called when the user have selected a file, the name of the file is passed to the function
		 */
		public function browse(_onSelected : Function, _customFileDescription : String = "") : void {
			var fileReference : FileReference = new FileReference();
			var fileDescription : String = _customFileDescription ? _customFileDescription : "swf";
			var fileFilter : FileFilter = new FileFilter(fileDescription, "*.swf");
			fileReference.browse([fileFilter]);
			
			fileReference.addEventListener(Event.SELECT, onSelect);
			
			function onSelect(e : Event) : void {
				_onSelected(fileReference.name);
			}
		}
		
		/**
		 * Loads an swf file into a specified MovieClip
		 * @param	_path		The location of the swf file
		 * @param	_container	The MovieClip to load the swf into
		 * @param 	_onLoaded 	(optional) Called when the swf is loaded, the loaded content as a MovieClip is passed to the function
		 */
		public function load(_path : String, _container : MovieClip, _onLoaded : Function = null) : void {	
			var loader : Loader = new Loader();
			
			function onLoaderComplete(e : Event) : void {
				var actionScriptVersion : Number = loader.contentLoaderInfo.actionScriptVersion;
				if (actionScriptVersion != 3) {
					onError("Unable to load the swf, it's actionscript version: " + actionScriptVersion + ", can not be loaded");
					return;
				}
				
				try {
					swf = MovieClip(loader.content);
				} catch (error : Error) {
					if (onError != null) {
						onError(error);
					}
					return;
				}
				
				_container.addChild(loader);
				if (_onLoaded != null) {
					_onLoaded(swf, loader.contentLoaderInfo.width, loader.contentLoaderInfo.height, loader.contentLoaderInfo.frameRate);
				}
			}
			
			function onLoaderError(e : IOErrorEvent) : void {
				onError(e.text);
			}
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			
			if (onError != null) {
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
			}
			
			loader.load(new URLRequest(_path));
		}
	}
}