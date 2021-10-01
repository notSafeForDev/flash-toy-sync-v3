package components {
	
	import core.CustomEvent;
	import core.Fonts;
	import core.GraphicsUtil;
	import core.MouseEvents;
	import core.MovieClipUtil;
	import core.TextElement;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanelListItem {
		
		private var index : Number;
		
		private var background : MovieClip;
		private var text : TextElement;
		
		public var onMouseDown : CustomEvent;
		
		public function HierarchyPanelListItem(_parent : MovieClip, _index : Number, _width : Number) {
			index = _index;
			
			onMouseDown = new CustomEvent();
			
			background = MovieClipUtil.create(_parent, "background");
			text = new TextElement(background, "PLACEHOLDER");
			text.element.textColor = 0xFFFFFF;
			text.setFont(Fonts.COURIER_NEW);
			text.setBold(true);
			
			GraphicsUtil.beginFill(background, 0xFFFFFF, 0.2);
			GraphicsUtil.drawRect(background, 0, 0, _width, 20);
			MovieClipUtil.setY(background, _index * 20);
			
			MouseEvents.addOnMouseDown(this, background, onBackgroundMouseDown);
		}
		
		public function setVisible(_value : Boolean) : void {
			MovieClipUtil.setVisible(background, _value);
		}
		
		public function setText(_value : String) : void {
			text.setText(_value);
		}
		
		private function onBackgroundMouseDown() : void {
			onMouseDown.emit(index);
		}
	}
}