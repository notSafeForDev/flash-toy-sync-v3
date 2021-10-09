package components {
	
	import flash.display.MovieClip;
	
	import core.DisplayObjectUtil;
	import core.Fonts;
	import core.TextElement;
	import core.GraphicsUtil;
	import core.MovieClipUtil;
	import core.DraggableObject;
	
	import config.TextStyles;

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
			
			DisplayObjectUtil.setY(background, titleBarHeight);
			
			var titleText : TextElement = new TextElement(titleBar, _name);
			titleText.element.selectable = false;
			titleText.setX(3);
			titleText.setY(1);
			TextStyles.applyPanelTitleStyle(titleText);
			
			GraphicsUtil.beginFill(titleBar, 0xFFFFFF, 0.5);
			GraphicsUtil.drawRect(titleBar, 0, 0, _contentWidth, titleBarHeight);
			
			GraphicsUtil.beginFill(background, 0x000000, 0.5);
			GraphicsUtil.drawRect(background, 0, 0, _contentWidth, _contentHeight);
			
			var draggable : DraggableObject = new DraggableObject(container, titleBar);
			draggable.bringToFrontOnDrag = true;
		}
		
		public function clearContent() : void {
			MovieClipUtil.remove(content);
			content = MovieClipUtil.create(background, "content");
		}
		
		public function setPosition(_x : Number, _y : Number) : void {
			DisplayObjectUtil.setX(container, _x);
			DisplayObjectUtil.setY(container, _y);
		}
	}
}