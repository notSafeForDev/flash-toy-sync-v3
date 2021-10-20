package components.stateTypes {
	
	import core.stateTypes.State;
	
	import components.Scene;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneState extends State {
		
		public function SceneState() {
			super();
		}
		
		public function setValue(_value : Scene) : void {
			value = _value;
		}
		
		public function getValue() : Scene {
			return value;
		}
	}
}