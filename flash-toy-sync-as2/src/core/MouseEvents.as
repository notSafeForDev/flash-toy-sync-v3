import core.FunctionUtil;
import core.MouseEvents;
/**
 * ...
 * @author notSafeForDev
 */
class core.MouseEvents {
	
	public function MouseEvents() {
		
	}
	
	public static function addOnMouseDown(_scope, _target : MovieClip, _handler : Function) {
		add(_scope, _target, "mouseDown", _handler);
	}
	
	private static function add(_scope, _target : MovieClip, _type : String, _handler : Function) {
		var functionName = "";
		if (_type == "click") {
			functionName = "onPress"; // Not recommended as that blocks other click events in the children
		} else if (_type == "mouseDown") {
			functionName = "onMouseDown";
		} else if (_type == "mouseUp") {
			functionName = "onMouseUp";
		}
		
		var handler = FunctionUtil.bind(_scope, _handler);
		
		var originalFunction = _target[functionName];
		_target[functionName] = function() {
			if (originalFunction !== undefined) {
				originalFunction();
			}
			
			var nestedChildren : Array = MouseEvents.getNestedChildren(_target);
			var clickedChildren : Array = [];
			
			for (var i = 0; i < nestedChildren.length; i++) {
				var child : MovieClip = nestedChildren[i];
				var hitting : Boolean = child.hitTest(_root._xmouse, _root._ymouse, true);
				if (hitting == true) {
					clickedChildren.push(child);
				}
			}
			
			handler(clickedChildren);
		}
	}
	
	private static function getNestedChildren(_topParent : MovieClip) : Array {
		var children : Array = [];
		
		for (var childName : String in _topParent) {
			if (typeof _topParent[childName] == "movieclip") {
				children.push(_topParent[childName]);
				children = children.concat(getNestedChildren(_topParent[childName]));
			}
		}
		
		return children;
	}
}