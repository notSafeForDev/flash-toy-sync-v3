import flash.geom.Rectangle;
class core.MovieClipUtil {
	
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
		
		for (var i = 0; i < children.length; i++) {
			var name : String = children[i]._name;
			
			if (name.indexOf("instance") == 0) {
				name = "";
				while (name.length <= i) {
					name += "#";
				}
				name += getChildIndex(children[i]).toString();
			}
			
			path.push(name);
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
	
	static function getNestedChildren(_topParent : MovieClip) : Array {
		var children : Array = [];
		
		for (var childName : String in _topParent) {
			if (typeof _topParent[childName] == "movieclip") {
				children.push(_topParent[childName]);
				children = children.concat(getNestedChildren(_topParent[childName]));
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
	
	public static function create(_parent : MovieClip, _name : String) : MovieClip {
		return _parent.createEmptyMovieClip(_name, _parent.getNextHighestDepth());
	}
	
	public static function getParent(_movieClip : MovieClip) : MovieClip {
		return _movieClip._parent;
	}
	
	static function hasNestedAnimations(_topParent : MovieClip) : Boolean {
		return getMaxFramesInChildren(_topParent) > 1;
	}
	
	static function getCurrentFrame(_movieClip : MovieClip) : Number {
		return _movieClip._currentframe;
	}
	
	static function getTotalFrames(_movieClip : MovieClip) : Number {
		return _movieClip._totalframes;
	}
	
	static function isVisible(_movieClip : MovieClip) : Boolean {
		return _movieClip._visible;
	}
	
	static function setVisible(_movieClip : MovieClip, _state : Boolean) {
		_movieClip._visible = _state;
	}

	static function getAlpha(_movieClip : MovieClip) : Number {
		return _movieClip._alpha * 0.01;
	}
	
	static function setAlpha(_movieClip : MovieClip, _value : Number) {
		_movieClip._alpha = _value * 100;
	}
	
	static function getX(_movieClip : MovieClip) : Number {
		return _movieClip._x;
	}
	
	static function setX(_movieClip : MovieClip, _value : Number) {
		_movieClip._x = _value;
	}
	
	static function getY(_movieClip : MovieClip) : Number {
		return _movieClip._y;
	}
	
	static function setY(_movieClip : MovieClip, _value : Number) {
		_movieClip._y = _value;
	}

	static function getScaleX(_movieClip : MovieClip) : Number {
		return _movieClip._xscale * 0.01;
	}
	
	static function setScaleX(_movieClip : MovieClip, _value : Number) {
		_movieClip._xscale = _value * 100;
	}
	
	static function getScaleY(_movieClip : MovieClip) : Number {
		return _movieClip._yscale * 0.01;
	}
	
	static function setScaleY(_movieClip : MovieClip, _value : Number) {
		_movieClip._yscale = _value * 100;
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