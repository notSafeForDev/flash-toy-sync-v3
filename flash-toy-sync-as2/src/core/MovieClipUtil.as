import core.FunctionUtil;
import core.MovieClipUtil;
import flash.geom.Rectangle;
class core.MovieClipUtil {
	
	static function getChildPathPart(_child : MovieClip, _depth : Number) : String {
		if (_child._name.indexOf("instance") != 0) {
			return _child._name;
		}
		
		var name : String = "";
		
		while (name.length <= _depth) {
			name += "#";
		}
		
		name += getChildIndex(_child).toString();
		return name;
	}
	
	static function getChildPath(_topParent : MovieClip, _child : MovieClip) : Array {
		if (_child == _topParent) {
			return [];
		}
		if (_child._parent == null) {
			return null;
		}
		
		var path : Array = [];
		var children : Array = [];
		var currentChild : MovieClip = _child;
		children.push(currentChild);
		
		while (currentChild._parent != _topParent) {
			currentChild = currentChild._parent;
			children.push(currentChild);
		}
		
		children.reverse();
		
		for (var i : Number = 0; i < children.length; i++) {
			path.push(getChildPathPart(children[i], i));
		}
		
		return path;
	}
	
	static function getChildFromPath(_topParent : MovieClip, _path : Array) : MovieClip {
		var child : MovieClip = _topParent;
		
		for (var i : Number = 0; i < _path.length; i++) {
			if (child == null) {
				return null;
			}
			
			var lastHashIndex : Number = _path[i].lastIndexOf("#");
			
			if (lastHashIndex < 0) {
				child = child[_path[i]];
				continue;
			}
			
			var childIndex : Number = parseInt(_path[i].substr(lastHashIndex + 1));
			child = getChildAtIndex(child, childIndex);
		}
		
		return child;
	}
	
	static function getNestedChildren(_topParent : MovieClip, _evaluator : Function, _scope, _currentDepth : Number) : Array {
		var children : Array = [];
		var evaluator : Function = _evaluator;
		if (_evaluator != undefined && _scope != undefined) {
			evaluator = FunctionUtil.bind(_scope, _evaluator);
		}
		if (_currentDepth == undefined) {
			_currentDepth = 0;
		}
		
		for (var childName : String in _topParent) {
			if (typeof _topParent[childName] == "movieclip") {
				var child : MovieClip = _topParent[childName];
				if (evaluator == undefined || evaluator(child, _currentDepth + 1) == true) {
					children.push(_topParent[childName]);
					children = children.concat(getNestedChildren(child, evaluator, undefined, _currentDepth + 1));
				}
			}
		}
		
		return children;
	}
	
	static function getMaxFramesInChildren(_topParent : MovieClip) : Number {
		var children : Array = getNestedChildren(_topParent);
		var maxFrames : Number = -1;
		
		for (var i : Number = 0; i < children.length; i++) {
			maxFrames = Math.max(maxFrames, children[i]._totalframes);
		}
		
		return maxFrames;
	}
	
	static function getChildIndex(_movieClip : MovieClip) : Number {
		var i : Number = 0;
		
		for (var childName in _movieClip._parent) {
			if (typeof _movieClip._parent[childName] == "movieclip") {
				if (childName == _movieClip._name) {
					return i;
				}
				i++;
			}
		}
	}
	
	public static function hitTest(_child : MovieClip, _stageX : Number, _stageY : Number, _shapeFlag : Boolean) : Boolean {
		return _child.hitTest(_stageX, _stageY, _shapeFlag);
	}
	
	public static function create(_parent : MovieClip, _name : String) : MovieClip {
		return _parent.createEmptyMovieClip(_name, _parent.getNextHighestDepth());
	}

	public static function remove(_movieClip : MovieClip) : Void {
		 // MovieClips created through Adobe Flash/Animate, have a negative depth, and can't be removed
		 // this gives it a positive depth so that it can be removed
		_movieClip.swapDepths(10000);
		_movieClip.removeMovieClip();
	}
	
	public static function getParent(_movieClip : MovieClip) : MovieClip {
		return _movieClip._parent;
	}
	
	public static function getParents(_movieClip : MovieClip) : Array {
		var parents : Array = [];
		var parent = _movieClip._parent;
		while (true) {
			if (typeof parent != "movieclip") {
				break;
			}
			parents.push(parent);
			parent = parent.parent;
		}
		return parents;
	}
	
	static function hasNestedAnimations(_topParent : MovieClip) : Boolean {
		var output : Boolean = false;
		
		iterateOverChildren(_topParent, function(_child : MovieClip) : Number {
			if (_child._totalframes > 1) {
				output = true;
				return MovieClipUtil.ITERATE_ABORT;
			}
			return MovieClipUtil.ITERATE_CONTINUE;
		});
		
		return output;
	}
	
	static var ITERATE_CONTINUE : Number = 0;
	static var ITERATE_SKIP_NESTED : Number = 1;
	static var ITERATE_ABORT : Number = 2;
	
	static function iterateOverChildren(_topParent : MovieClip, _handler : Function, _scope, _currentDepth : Number) : Void {
		var handler : Function = _handler;
		if (_handler != undefined && _scope != undefined) {
			handler = FunctionUtil.bind(_scope, _handler);
		}
		if (_currentDepth == undefined) {
			_currentDepth = 0;
		}
		
		for (var childName : String in _topParent) {
			if (typeof _topParent[childName] == "movieclip") {
				var child : MovieClip = _topParent[childName];
				var code : Number = handler(child, _currentDepth + 1);
				if (code == ITERATE_ABORT) {
					break;
				}
				if (code != ITERATE_SKIP_NESTED) {
					iterateOverChildren(child, handler, _scope, _currentDepth + 1);
				}
			}
		}
	}
	
	static function getCurrentFrame(_movieClip : MovieClip) : Number {
		return _movieClip._currentframe;
	}
	
	static function getTotalFrames(_movieClip : MovieClip) : Number {
		return _movieClip._totalframes;
	}
	
	static function getBounds(_movieClip : MovieClip, _targetCoordinateSpace : MovieClip) : Rectangle {
		var bounds : Object = _movieClip.getBounds(_targetCoordinateSpace || _movieClip._parent);
		return new Rectangle(bounds.xMin, bounds.yMin, bounds.xMax - bounds.xMin, bounds.yMax - bounds.yMin);
	}
	
	private static function getChildAtIndex(_movieClip : MovieClip, _index : Number) : MovieClip {
		var i : Number = 0;
		
		for (var childName in _movieClip) {
			if (typeof _movieClip[childName] == "movieclip") {
				if (i == _index) {
					return _movieClip[childName];
				}
				i++;
			}
		}
	}
}