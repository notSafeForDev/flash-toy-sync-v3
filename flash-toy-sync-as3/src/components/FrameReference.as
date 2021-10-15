package components {
	
	import flash.display.MovieClip;
	
	import core.DisplayObjectUtil;
	import core.MovieClipUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class FrameReference {
		
		private var path : Array = null;
		private var frames : Array = null;
		
		public function FrameReference(_topParent : MovieClip, _child : MovieClip) {
			path = DisplayObjectUtil.getChildPath(_topParent, _child);
			frames = [MovieClipUtil.getCurrentFrame(_child)];
			
			if (path == null) {
				throw new Error("Unable to create FrameReference, the provided child is not in the display list");
			}
			
			var parents : Array = DisplayObjectUtil.getParents(_child);
			for (var i : Number = 0; i < parents.length; i++) {
				frames.push(MovieClipUtil.getCurrentFrame(parents[i]));
				if (parents[i] == _topParent) {
					break;
				}
			}
			
			// Order it starting with the top parent, ending with the child
			frames.reverse();
		}
		
		public function getPath() : Array {
			return path.slice();
		}
		
		public function getFrames() : Array {
			return frames.slice();
		}
	}
}