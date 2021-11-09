package ui {
	
	import models.SceneModel;
	import states.AnimationSceneStates;
	import utils.ArrayUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class DialogueBoxes {
		
		public static function openDeleteScenesDialogueBox(_scope : *, _confirmHandler : Function) : void {
			var text : String = "Are you sure you want to delete the scene?";
			if (AnimationSceneStates.selectedScenes.value.length > 1) {
				text = "Are you sure you want to delete the scenes?";
			}
			
			var selectedScenes : Array = AnimationSceneStates.selectedScenes.value;
			var totalScenesWithScripts : Number = 0;
			for (var i : Number = 0; i < selectedScenes.length; i++) {
				var scene : SceneModel = selectedScenes[i];
				if (scene.getPlugins().getScript().hasAnyRecordedPositions() == true) {
					totalScenesWithScripts++;
				}
			}
			
			if (selectedScenes.length == 1 && totalScenesWithScripts == 1) {
				text += "\n";
				text += "\n" + "The scene has scripted positions.";
			} else if (selectedScenes.length > 1 && totalScenesWithScripts == 1) {
				text += "\n";
				text += "\n" + totalScenesWithScripts + " scene has scripted positions.";
			} else if (totalScenesWithScripts > 1) {
				text += "\n";
				text += "\n" + totalScenesWithScripts + " scenes has scripted positions.";
			}
			
			DialogueBox.open(text, _scope, _confirmHandler);
		}
		
		public static function openMergeScenesDialogueBox(_scope : *, _confirmHandler : Function) : void {
			var scenes : Array = AnimationSceneStates.scenes.value;
			var selectedScenes : Array = AnimationSceneStates.selectedScenes.value;
			var selectedSceneIndexes : Vector.<Number> = ArrayUtil.indexesOf(scenes, selectedScenes);
			
			var name1 : String = "Scene " + (selectedSceneIndexes[0] + 1);
			var name2 : String = "Scene " + (selectedSceneIndexes[1] + 1);
			
			var text : String = "Are you sure you want to merge " + name1 + " with " + name2 + "?";
			text += "\n";
			text += "\n" + "Scripted positions from " + name1 + " will override positions from " + name2 + ".";
			text += "\n" + "(Based on the selection order.)";
			
			DialogueBox.open(text, _scope, _confirmHandler);
		}
	}
}