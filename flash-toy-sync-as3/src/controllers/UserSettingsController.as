package controllers {
	
	import core.VersionUtil;
	import flash.net.SharedObject;
	import global.GlobalState;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class UserSettingsController {
		
		private var sharedObject : SharedObject;
		
		public function UserSettingsController(_globalState : GlobalState) {
			// AS3 can't read shared objects created or modified by the AS2 version
			var name : String = VersionUtil.isActionscript3() ? "flash-toy-sync-as3-user-settings" : "flash-toy-sync-as2-user-settings";
			
			sharedObject = SharedObject.getLocal(name, "/");
			
			if (sharedObject.data.theHandyConnectionKey != undefined) {
				_globalState._theHandyConnectionKey.setState(sharedObject.data.theHandyConnectionKey);
			}
			
			GlobalState.listen(this, onUserSettingsStatesChange, [GlobalState.theHandyConnectionKey]);
		}
		
		private function onUserSettingsStatesChange() : void {
			sharedObject.data.theHandyConnectionKey = GlobalState.theHandyConnectionKey.state;
		}
	}
}