class core.FunctionUtil {
	
	static function bind(_scope, _function) : Function {
		var args : Array = arguments.slice(2);
		return function() {
			var allArguments : Array = args.concat(arguments);
			return _function.apply(_scope, allArguments);
		}
	}
}