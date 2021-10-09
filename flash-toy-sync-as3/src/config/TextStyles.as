package config {
	
	import flash.filters.GlowFilter;
	
	import core.TextElement;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TextStyles {
		
		private static var font : String = "Consolas";
		
		public static function applyListItemStyle(_text : TextElement) : void {
			_text.element.textColor = 0xFFFFFF;
			_text.setFont(font, false);
		}
		
		public static function applyPanelTitleStyle(_text : TextElement) : void {
			_text.element.textColor = 0x333333;
			_text.setFont(font, false);
			_text.setBold(true);
			_text.setFontSize(14);
		}
		
		public static function applyMarkerStyle(_text : TextElement) : void {
			var textOutlineFilter : GlowFilter = new GlowFilter(0x000000, 0.5, 2, 2, 255);
			var textFilters : Array = [textOutlineFilter];
			
			_text.element.textColor = 0xFFFFFF;
			_text.setFont(font, false);
			_text.setFilters(textFilters);
		}
		
		public static function applyButtonStyle(_text : TextElement) : void {
			_text.element.textColor = 0x000000;
			_text.setFont(font, false);
		}
	}
}