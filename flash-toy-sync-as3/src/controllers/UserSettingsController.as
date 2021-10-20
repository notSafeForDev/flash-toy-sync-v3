package controllers {
	
	import flash.net.SharedObject;
	
	import core.VersionUtil;

	import global.ToyState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class UserSettingsController {
		
		private var sharedObject : SharedObject;
		
		public function UserSettingsController(_toyState : ToyState) {
			// AS3 can't read shared objects created or modified by the AS2 version
			var name : String = VersionUtil.isActionscript3() ? "flash-toy-sync-as3-user-settings" : "flash-toy-sync-as2-user-settings";
			
			sharedObject = SharedObject.getLocal(name, "/");
			
			if (sharedObject.data.theHandyConnectionKey != undefined) {
				_toyState._theHandyConnectionKey.setValue(sharedObject.data.theHandyConnectionKey);
			}
			
			ToyState.listen(this, onUserSettingsStatesChange, [ToyState.theHandyConnectionKey]);
		}
		
		private function onUserSettingsStatesChange() : void {
			sharedObject.data.theHandyConnectionKey = ToyState.theHandyConnectionKey.value;
		}
	}
}