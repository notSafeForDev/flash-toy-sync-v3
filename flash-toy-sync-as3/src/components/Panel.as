package components {
	
	import core.TextElement;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.UIDragableWindow;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class Panel {
		
		public var container : MovieClip;
		public var titleBar : MovieClip;
		public var background : MovieClip;
		
		public function Panel(_parent : MovieClip, _name : String, _width : Number, _height : Number) {
			var instanceName : String = _name.split(" ").join("");
			
			container = MovieClipUtil.create(_parent, instanceName);
			titleBar = MovieClipUtil.create(container,  "titleBar");
			background = MovieClipUtil.create(container, "background");
			
			/* var titleText : TextField = new TextField();
			titleText.text = _name;
			titleText.selectable = false;
			
			titleBar.addChild(titleText); */
			
			var titleText : TextElement = new TextElement(titleBar, _name);
			titleText.element.selectable = false;
			
			GraphicsUtil.beginFill(titleBar, 0xFFFFFF, 0.5);
			GraphicsUtil.drawRect(titleBar, 0, 0, _width, 20);
			
			GraphicsUtil.beginFill(background, 0x000000, 0.5);
			GraphicsUtil.drawRect(background, 0, 20, _width, _height - 20);
			
			var draggableWindow : UIDragableWindow = new UIDragableWindow(container, titleBar);
		}
	}
}