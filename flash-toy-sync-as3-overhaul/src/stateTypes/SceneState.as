package stateTypes {
	
	import models.SceneModel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class SceneState extends State {
		
		public function SceneState(_defaultValue : SceneModel) {
			super(_defaultValue, SceneStateReference);
		}
		
		public function getValue() : SceneModel {
			return value;
		}
		
		public function setValue(_value : SceneModel) : void {
			changeValue(_value);
		}
	}
}