package ui {
	
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TextStyles {
		
		private static var font : String = "Consolas";
		
		public static function applyStatusStyle(_text : TextElement) : void {
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = font;
			textFormat.size = 16;
			textFormat.bold = true;
			textFormat.color = 0xFFFFFF;
			textFormat.align = TextElement.ALIGN_CENTER;
			
			_text.setTextFormat(textFormat);
			
			_text.element.filters = [new GlowFilter(0x000000, 0.5, 4, 4, 255)];
		}
		
		public static function applyListItemStyle(_text : TextElement) : void {
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = font;
			textFormat.color = 0xFFFFFF;
			
			_text.setTextFormat(textFormat);
		}
		
		public static function applyPanelTitleStyle(_text : TextElement) : void {
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = font;
			textFormat.color = 0xDDDDDD;
			textFormat.bold = true;
			textFormat.size = 14;
			
			_text.setTextFormat(textFormat);
		}
		
		public static function applyMarkerStyle(_text : TextElement) : void {
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = font;
			textFormat.color = 0xFFFFFF;
			textFormat.align = TextElement.ALIGN_CENTER;

			_text.setTextFormat(textFormat);
			_text.sourceTextField.autoSize = TextElement.AUTO_SIZE_CENTER;
			_text.element.height = 20;
			_text.element.filters = [new GlowFilter(0x000000, 0.5, 2, 2, 255)];
		}
		
		public static function applyButtonStyle(_text : TextElement) : void {
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = font;
			textFormat.color = 0x000000;
			textFormat.align = TextElement.ALIGN_CENTER;
			
			_text.setTextFormat(textFormat);
		}
		
		public static function applyMainMenuButtonStyle(_text : TextElement) : void {			
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = font;
			textFormat.color = 0x000000;
			textFormat.bold = true;
			textFormat.size = 14;
			textFormat.align = TextElement.ALIGN_CENTER;
			
			_text.setTextFormat(textFormat);
		}
		
		public static function applyInputStyle(_text : TextElement) : void {			
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = font;
			textFormat.color = 0x000000;
			
			_text.setTextFormat(textFormat);
			
			_text.sourceTextField.backgroundColor = 0xFFFFFF;
			_text.sourceTextField.background = true;
			_text.sourceTextField.selectable = true;
			_text.sourceTextField.border = true;
		}
	}
}