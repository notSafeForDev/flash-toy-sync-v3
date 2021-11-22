package ui {
	
	import core.CustomEvent;
	import core.MouseEvents;
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import core.TPStage;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import utils.ArrayUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class UIDropdown {
		
		public var selectEvent : CustomEvent;
		
		public var element : TPMovieClip;
		
		private var parent : TPMovieClip;
		private var options : Array;
		private var defaultValue : String;
		private var width : Number;
		private var optionHeight : Number = 20;
		
		private var selectedText : TextElement;
		private var selectedIndex : Number;
		private var clickOutsideCatcher : TPMovieClip;
		private var list : TPMovieClip;
		
		public function UIDropdown(_parent : TPMovieClip, _options : Array, _default : String, _width : Number) {
			parent = _parent;
			options = _options;
			defaultValue = _default;
			width = _width;
			
			selectEvent = new CustomEvent();
			
			element = TPMovieClip.create(_parent, "dropdownBackground");
			
			selectedText = new TextElement(element, " > " + _default);
			selectedText.element.width = _width;
			
			selectedIndex = ArrayUtil.indexOf(_options, _default);
			
			element.graphics.beginFill(0xFFFFFF);
			element.graphics.drawRect(0, 0, width, optionHeight);
			
			element.buttonMode = true;
			
			TextStyles.applyDrowdownStyle(selectedText);
			
			MouseEvents.addOnMouseDown(this, element.sourceDisplayObject, onMouseDown);
		}
		
		public function setSelectedOption(_value : String) : void {
			selectedIndex = ArrayUtil.indexOf(options, _value);
			selectedText.text = " > " + _value;
			
			if (list != null) {
				close();
			}
		}
		
		private function onMouseDown() : void {
			selectedText.text = " v ";
			
			if (selectedIndex >= 0) {
				selectedText.text += options[selectedIndex];
			} else {
				selectedText.text += defaultValue;
			}
			
			clickOutsideCatcher = TPMovieClip.create(parent, "dropdownClickOutsideCatcher");
			
			var topLeftLocal : Point = parent.globalToLocal(new Point(0, 0));
			var bottomRightLocal : Point = parent.globalToLocal(new Point(TPStage.stageWidth, TPStage.stageHeight));
			
			clickOutsideCatcher.graphics.beginFill(0xFF0000, 0);
			clickOutsideCatcher.graphics.drawRect(topLeftLocal.x, topLeftLocal.y, bottomRightLocal.x - topLeftLocal.x, bottomRightLocal.y - topLeftLocal.y);
			clickOutsideCatcher.buttonMode = false;
			
			list = TPMovieClip.create(parent, "dropdownList");
			list.x = element.x;
			list.y = element.y + optionHeight;
			
			list.filters = [new GlowFilter(0x000000, 0.25)];
			
			var visibleItemCount : Number = 0;
			for (var i : Number = 0; i < options.length; i++) {
				if (i == selectedIndex) {
					continue;
				}
				
				displayListOption(visibleItemCount, options[i]);
				visibleItemCount++;
			}
			
			MouseEvents.addOnMouseDown(this, clickOutsideCatcher.sourceDisplayObject, onMouseDownOutside);
		}
		
		private function onMouseDownOutside() : void {
			close();
		}
		
		private function onListOptionMouseDown(_value : String) : void {
			selectedIndex = ArrayUtil.indexOf(options, _value);
			
			selectEvent.emit(_value);
			
			close();
		}
		
		private function displayListOption(_index : Number, _value : String) : void {
			var background : TPMovieClip = TPMovieClip.create(list, "option" + _value);
			background.graphics.beginFill(0xFFFFFF);
			background.graphics.drawRect(0, 0, width, optionHeight);
			
			background.y = optionHeight * _index;
			background.buttonMode = true;
			
			var text : TextElement = new TextElement(background, "optionsBackground");
			TextStyles.applyDrowdownStyle(text);
			
			text.text = _value;
			text.element.width = width;
			
			MouseEvents.addOnMouseDown(this, background.sourceDisplayObject, onListOptionMouseDown, _value);
		}
		
		private function close() : void {
			TPDisplayObject.remove(clickOutsideCatcher);
			TPDisplayObject.remove(list);
			
			selectedText.text = " > ";
			
			if (selectedIndex >= 0) {
				selectedText.text += options[selectedIndex];
			} else {
				selectedText.text += defaultValue;
			}
		}
	}
}