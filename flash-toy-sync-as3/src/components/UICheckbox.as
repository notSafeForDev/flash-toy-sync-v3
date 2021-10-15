package components {
	
	import flash.display.Sprite;
	
	import core.CustomEvent;
	import core.DisplayObjectUtil;
	import core.MouseEvents;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class UICheckbox {
		
		public var onToggle : CustomEvent;
		
		private var checkedIndicator : Sprite;
		
		private var isChecked : Boolean;
		
		public function UICheckbox(_background : Sprite, _checkedIndicator : Sprite, _isChecked : Boolean) {
			checkedIndicator = _checkedIndicator;
			isChecked = _isChecked;
			
			DisplayObjectUtil.setVisible(checkedIndicator, isChecked);
			
			onToggle = new CustomEvent();
			
			_background.buttonMode = true;
			
			MouseEvents.addOnMouseDown(this, _background, onMouseDown);
		}
		
		private function onMouseDown() {
			isChecked = !isChecked;
			DisplayObjectUtil.setVisible(checkedIndicator, isChecked);
			onToggle.emit(isChecked);
		}
	}
}