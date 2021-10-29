/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import ui.*
import core.JSON

import flash.filters.GlowFilter;

/**
 * ...
 * @author notSafeForDev
 */
class ui.TextStyles {
	
	private static var font : String = "Consolas";
	
	public static function applyErrorStyle(_text : TextElement) : Void {
		var textFormat : TextFormat = new TextFormat();
		textFormat.font = font;
		textFormat.size = 16;
		textFormat.bold = true;
		textFormat.color = 0xFFFFFF;
		
		_text.setTextFormat(textFormat);
		
		_text.element.filters = [new GlowFilter(0x000000, 0.5, 4, 4, 255)];
	}
	
	public static function applyListItemStyle(_text : TextElement) : Void {
		var textFormat : TextFormat = new TextFormat();
		textFormat.font = font;
		textFormat.color = 0xFFFFFF;
		
		_text.setTextFormat(textFormat);
	}
	
	public static function applyPanelTitleStyle(_text : TextElement) : Void {
		var textFormat : TextFormat = new TextFormat();
		textFormat.font = font;
		textFormat.color = 0xDDDDDD;
		textFormat.bold = true;
		textFormat.size = 14;
		
		_text.setTextFormat(textFormat);
	}
	
	public static function applyMarkerStyle(_text : TextElement) : Void {
		var textFormat : TextFormat = new TextFormat();
		textFormat.font = font;
		textFormat.color = 0xFFFFFF;
		
		_text.setTextFormat(textFormat);
		
		_text.element.filters = [new GlowFilter(0x000000, 0.5, 2, 2, 255)];
	}
	
	public static function applyButtonStyle(_text : TextElement) : Void {
		var textFormat : TextFormat = new TextFormat();
		textFormat.font = font;
		textFormat.color = 0x000000;
		textFormat.align = TextElement.ALIGN_CENTER;
		
		_text.setTextFormat(textFormat);
	}
	
	public static function applyMainMenuButtonStyle(_text : TextElement) : Void {			
		var textFormat : TextFormat = new TextFormat();
		textFormat.font = font;
		textFormat.color = 0x000000;
		textFormat.bold = true;
		textFormat.size = 14;
		textFormat.align = TextElement.ALIGN_CENTER;
		
		_text.setTextFormat(textFormat);
	}
	
	public static function applyInputStyle(_text : TextElement) : Void {			
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