package components {
	
	import flash.display.MovieClip;
	
	import core.TextElement;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.UIDragableWindow;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Panel {
		
		private var titleBarHeight : Number = 24;
		
		public var container : MovieClip;
		public var titleBar : MovieClip;
		public var background : MovieClip;
		public var content : MovieClip;
		
		public function Panel(_parent : MovieClip, _name : String, _width : Number, _height : Number) {
			var instanceName : String = _name.split(" ").join("");
			
			container = MovieClipUtil.create(_parent, instanceName);
			titleBar = MovieClipUtil.create(container,  "titleBar");
			background = MovieClipUtil.create(container, "background");
			content = MovieClipUtil.create(background, "content");
			
			MovieClipUtil.setY(background, titleBarHeight);
			
			var titleText : TextElement = new TextElement(titleBar, _name);
			titleText.element.selectable = false;
			
			GraphicsUtil.beginFill(titleBar, 0xFFFFFF, 0.5);
			GraphicsUtil.drawRect(titleBar, 0, 0, _width, titleBarHeight);
			
			GraphicsUtil.beginFill(background, 0x000000, 0.5);
			GraphicsUtil.drawRect(background, 0, 0, _width, _height - titleBarHeight);
			
			var draggableWindow : UIDragableWindow = new UIDragableWindow(container, titleBar);
		}
		
		public function clearContent() : void {
			MovieClipUtil.remove(content);
			content = MovieClipUtil.create(background, "content");
		}
	}
}