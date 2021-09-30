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
		public function browse(_onSelected : Function) : void {
			var fileReference : FileReference = new FileReference();
			var fileFilter : FileFilter = new FileFilter("swf", "*.swf");
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
					_onLoaded(swf);
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