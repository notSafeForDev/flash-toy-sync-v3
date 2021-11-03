package components {
	
	import core.TPDisplayObject;
	import core.TPMovieClip;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import states.AnimationInfoStates;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class HierarchyChildInfo {
		
		public var child : TPDisplayObject;
		public var depth : Number;
		public var childIndex : Number;
		public var isExpandable : Boolean;
		public var isExpanded : Boolean;
	}
}