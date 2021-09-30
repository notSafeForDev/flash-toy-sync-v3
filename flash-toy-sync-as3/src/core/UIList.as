package core {
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	
	public class UIList {
		
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
			var element : MovieClip;
			
			if (elements.length >= elementsPool.length) {
				element = createElement();
				container.addChild(element);
				if (isElementsSelectable == true) {
					element.addEventListener(MouseEvent.MOUSE_DOWN, function(e : MouseEvent) {
						if (onElementSelected != null) {
							onElementSelected(elements.indexOf(element));
						}
					});
				}
				elementsPool.push(element);
			}
			else {
				element = elementsPool[elements.length];
			}
			
			element.visible = true;
			element.y = element.height * elements.length;
			
			elements.push(element);
			
			return element;
		}
		
		public function clearElements() {
			for (var i : int = 0; i < elements.length; i++) {
				elements[i].visible = false;
				elements[i].y = 0;
			}
			
			elements = [];
		}
		
		private function createElement() : MovieClip {
			var C : Class = Class(getDefinitionByName(elementLinkageName));
			return MovieClip(new C());
		}
	}
}