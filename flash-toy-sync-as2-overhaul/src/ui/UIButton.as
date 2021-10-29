/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import ui.*
import core.JSON

import core.TranspiledMovieClip;
import core.MouseEvents;
import core.CustomEvent;
import flash.geom.ColorTransform;

class ui.UIButton {
	
	public var element : TranspiledMovieClip;
	
	/** Gets emitted when the user presses their mouse button */
	public var mouseDownEvent : CustomEvent;
	/** Gets emitted when the user releases their mouse button */
	public var mouseUpEvent : CustomEvent;
	/** Gets emitted when the user releases their mouse button without dragging */
	public var mouseClickEvent : CustomEvent;
	/** Gets emitted when the user first moves their mouse while it is pressed */
	public var startDragEvent : CustomEvent;
	
	public var isMouseDown : Boolean;
	public var isMouseOver : Boolean;
	public var isDragging : Boolean;
	
	public var disabledAlpha : Number = 0.5;
	
	private var movieClip : MovieClip;
	
	private var defaultColorTransform : ColorTransform;
	private var overColorTransform : ColorTransform;
	private var downColorTransform : ColorTransform;
	private var disabledColorTransform : ColorTransform;
	
	function UIButton(_button : MovieClip) {
		movieClip = _button;
		element = new TranspiledMovieClip(_button);
		
		movieClip.buttonMode = true;
		movieClip.mouseEnabled = true;
		
		defaultColorTransform = new ColorTransform();
		overColorTransform = new ColorTransform();
		disabledColorTransform = new ColorTransform();
		
		overColorTransform.redOffset = 100;
		overColorTransform.greenOffset = 100;
		overColorTransform.blueOffset = 100;
		
		disabledColorTransform.redMultiplier = 0.5;
		disabledColorTransform.greenMultiplier = 0.5;
		disabledColorTransform.blueMultiplier = 0.5;
		
		mouseDownEvent = new CustomEvent();
		mouseUpEvent = new CustomEvent();
		mouseClickEvent = new CustomEvent();
		startDragEvent = new CustomEvent();
		
		MouseEvents.addOnMouseOver(this, _button, _onMouseOver);
		MouseEvents.addOnMouseOut(this, _button, _onMouseOut);
		MouseEvents.addOnMouseDown(this, _button, _onMouseDown);
		MouseEvents.addOnMouseUp(this, _button, _onMouseUp);
		MouseEvents.addOnMouseMove(this, _button, _onMouseMove);
	}
	
	private function _onMouseOver() : Void {
		if (element.buttonMode == false) { // Needed for AS2
			return;
		}
		
		isMouseOver = true;
		
		element.colorTransform = overColorTransform;
	}
	
	private function _onMouseOut() : Void {
		if (element.buttonMode == false) {
			return;
		}
		
		isMouseOver = false;
		isMouseDown = false;
		isDragging = false;
		
		element.colorTransform = defaultColorTransform;
	}
	
	private function _onMouseDown() : Void {
		if (element.buttonMode == false) {
			return;
		}
		
		isMouseDown = true;
		isDragging = false;
		mouseDownEvent.emit();
		
		// Due to differences in mouse out behaviour from AS3 and AS2, 
		// we use the default colorTransform for mouse down, as opposed to a different one
		element.colorTransform = defaultColorTransform;
	}
	
	private function _onMouseUp() : Void {
		if (element.buttonMode == false) {
			return;
		}
		
		var wasDragging : Boolean = isDragging;
		isMouseDown = false;
		isDragging = false;
		
		mouseUpEvent.emit();
		if (wasDragging == false) {
			mouseClickEvent.emit();
		}
		
		element.colorTransform = overColorTransform;
	}
	
	private function _onMouseMove() : Void {
		if (element.buttonMode == false) {
			return;
		}
		
		if (isMouseDown == true && isDragging == false) {
			startDragEvent.emit();
			isDragging = true;
		}
	}
	
	public function enable() : Void {
		element.buttonMode = true;
		movieClip.mouseEnabled = true;
		
		if (isMouseOver) {
			element.colorTransform = overColorTransform;
		} else {
			element.colorTransform = defaultColorTransform;
		}
	}
	
	public function disable() : Void {
		element.buttonMode = false;
		movieClip.mouseEnabled = false;
		
		element.colorTransform = disabledColorTransform;
	}
	
	public function setEnabled(_enabled : Boolean) : Void {
		if (_enabled == true) {
			enable();
		} else {
			disable();
		}
	}
}