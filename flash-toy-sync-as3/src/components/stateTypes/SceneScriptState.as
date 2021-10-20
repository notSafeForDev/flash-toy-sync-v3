package components.stateTypes {
	
	import core.stateTypes.State;
	
	import components.SceneScript;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneScriptState extends State {
		
		public function SceneScriptState() {	
			super();
		}
		
		public function setValue(_value : SceneScript) : void {
			value = _value;
		}
		
		public function getValue() : SceneScript {
			return value;
		}
	}
}