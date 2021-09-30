class core.UIList {
		
	public var container : MovieClip;
	
	public var elements : Array = [];
	
	public var isElementsSelectable : Boolean = false;
	
	public var onElementSelected : Function;
	
	private var elementLinkageName;
	private var elementsPool : Array = [];
	
	function UIList(_container : MovieClip, _elementLinkageName : String) {
		container = _container;
		
		elementLinkageName = _elementLinkageName;
	}
	
	public function addElement() : MovieClip {
		var self = this;
		
		var element : MovieClip;
		
		if (elements.length >= elementsPool.length) {
			element = createElement();
			var fieldIndex : Number = elements.length;
			if (isElementsSelectable == true) {
				element.onPress = function() {
					if (self.onElementSelected != null) {
						self.onElementSelected(fieldIndex);
					}
				}
			}
			elementsPool.push(element);
		}
		else {
			element = elementsPool[elements.length];
		}
		
		element._visible = true;
		element._y = element._height * elements.length;
		
		elements.push(element);
		
		return element;
	}
	
	public function clearElements() {
		for (var i : Number = 0; i < elements.length; i++) {
			elements[i]._visible = false;
			elements[i]._y = 0;
		}
		
		elements = [];
	}
	
	private function createElement() : MovieClip {
		return container.attachMovie(elementLinkageName, "field" + elements.length, elements.length);
	}
}