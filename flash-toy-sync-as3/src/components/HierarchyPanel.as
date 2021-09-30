package components {
	
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyPanel {
		
		private var base : Panel;
		
		public function HierarchyPanel(_parent : MovieClip) {
			base = new Panel(_parent, "Hierarchy", 200, 400);
		}
	}
}