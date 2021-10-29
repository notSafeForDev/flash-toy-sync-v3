package stateTypes {
	
	import models.SceneModel;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenesArrayState extends State {
		
		public function ScenesArrayState(_defaultValue : Vector.<SceneModel>) {
			super(_defaultValue, ScenesArrayStateReference);
		}
		
		public function getValue() : Vector.<SceneModel> {
			return value;
		}
		
		public function setValue(_value : Vector.<SceneModel>) : void {
			value = _value;
		}
	}
}