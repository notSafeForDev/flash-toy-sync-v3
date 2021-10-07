package components {
	
	import core.Fonts;
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
		
		public function Panel(_parent : MovieClip, _name : String, _contentWidth : Number, _contentHeight : Number) {
			var instanceName : String = _name.split(" ").join("");
			
			container = MovieClipUtil.create(_parent, instanceName);
			titleBar = MovieClipUtil.create(container,  "titleBar");
			background = MovieClipUtil.create(container, "background");
			content = MovieClipUtil.create(background, "content");
			
			MovieClipUtil.setY(background, titleBarHeight);
			
			var titleText : TextElement = new TextElement(titleBar, _name);
			titleText.element.selectable = false;
			titleText.setFont(Fonts.COURIER_NEW);
			titleText.setBold(true);
			titleText.setFontSize(14);
			
			GraphicsUtil.beginFill(titleBar, 0xFFFFFF, 0.5);
			GraphicsUtil.drawRect(titleBar, 0, 0, _contentWidth, titleBarHeight);
			
			GraphicsUtil.beginFill(background, 0x000000, 0.5);
			GraphicsUtil.drawRect(background, 0, 0, _contentWidth, _contentHeight);
			
			var draggableWindow : UIDragableWindow = new UIDragableWindow(container, titleBar);
		}
		
		public function clearContent() : void {
			MovieClipUtil.remove(content);
			content = MovieClipUtil.create(background, "content");
		}
		
		public function setPosition(_x : Number, _y : Number) : void {
			MovieClipUtil.setX(container, _x);
			MovieClipUtil.setY(container, _y);
		}
	}
}