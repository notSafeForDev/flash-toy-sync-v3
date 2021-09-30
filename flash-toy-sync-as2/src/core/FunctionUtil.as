class core.FunctionUtil {
	
	static function bind(_scope, _function) : Function {
		return function() {
			_function.apply(_scope, arguments);
		}
	}
}