import core.TPMovieClip;
/**
 * ...
 * @author notSafeForDev
 */
class core.TPTextField {
	
	public static function create(_parent : TPMovieClip) : TextField {
		return _parent.sourceDisplayObjectContainer.createTextField("TextField", _parent.sourceDisplayObjectContainer.getNextHighestDepth(), 0, 0, 100, 100);
	}
	
	public static function addOnChangeListener(_textField : TextField, _scope, _handler : Function) : Void {
		_textField.onChanged = function() {
			_handler.apply(_scope, [_textField.text]);
		}
	}
}