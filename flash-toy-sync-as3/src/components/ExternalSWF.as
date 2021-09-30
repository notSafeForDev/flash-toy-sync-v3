package components {
	
	import flash.display.MovieClip;
	
	import core.CustomEvent;
	import core.FunctionUtil;
	import core.SWFLoader;
	
	public class ExternalSWF {
	
		public var onLoaded : CustomEvent;
		public var onError : CustomEvent
		
		public function ExternalSWF(_path : String, _container : MovieClip) {
			onLoaded = new CustomEvent();
			onError = new CustomEvent();
			
			var loader : SWFLoader = new SWFLoader();
			loader.load(_path, _container, FunctionUtil.bind(this, _onLoaded));
		}
		
		private function _onLoaded(_swf : MovieClip) : void {
			onLoaded.emit(_swf);
		}
	}
}