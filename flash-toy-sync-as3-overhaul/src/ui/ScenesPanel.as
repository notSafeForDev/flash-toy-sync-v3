package ui {
	
	import core.CustomEvent;
	import core.TPMovieClip;
	import models.SceneModel;
	import states.AnimationSceneStates;
	import states.EditorStates;
	import utils.ArrayUtil;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class ScenesPanel extends Panel {
		
		/** Emitted when the user clicks on a scene in the panel, along with the sceneModel instance */
		public var sceneSelectedEvent : CustomEvent;
		
		private var listItems : Vector.<UIListItem>;
		private var uiList : UIList;
		
		public function ScenesPanel(_parent : TPMovieClip, _contentWidth : Number, _contentHeight : Number) {
			super(_parent, "Scenes", _contentWidth, _contentHeight);
			
			sceneSelectedEvent = new CustomEvent();
			
			var listContainer : TPMovieClip = TPMovieClip.create(content, "listContainer");
			
			listItems = new Vector.<UIListItem>();
			
			uiList = new UIList(listContainer, contentWidth, contentHeight);
			
			AnimationSceneStates.listen(this, onSceneStatesChange, [AnimationSceneStates.currentScene, AnimationSceneStates.scenes]);
		}
		
		public function update() : void {
			if (EditorStates.isEditor.value == false) {
				return;
			}
			
			var scenes : Array = AnimationSceneStates.scenes.value;
			var currentScene : SceneModel = AnimationSceneStates.currentScene.value;
			
			if (isMinimized() == true) {
				uiList.hideItems();
				return;
			}
			
			var i : Number;
			
			for (i = 0; i < scenes.length; i++) {
				if (i >= listItems.length) {
					addListItem();
				}
			}
			
			uiList.showItemsAtScrollPosition(scenes.length);
			
			for (i = 0; i < scenes.length; i++) {
				var scene : SceneModel = scenes[i];
				var startFrames : Vector.<Number> = scene.getStartFrames();
				var endFrames : Vector.<Number> = scene.getEndFrames();
				var primaryText : String = "Scene " + (i + 1);
				// var secondaryText : String = startFrames[startFrames.length - 1] + " - " + endFrames[endFrames.length - 1];
				var secondaryText : String = startFrames.join(",") + " - " + endFrames[endFrames.length - 1];
				
				if (scene.isForceStopped() == true) {
					primaryText += " | Stopped";
				}
				
				listItems[i].setPrimaryText(primaryText);
				listItems[i].setSecondaryText(secondaryText);
				
				if (scene == currentScene) {
					listItems[i].highlight();
				} else {
					listItems[i].clearHighlight();
				}
			}
		}
		
		private function onListItemClick(_index : Number) : void {
			var scenes : Array = AnimationSceneStates.scenes.value;
			sceneSelectedEvent.emit(scenes[_index]);
		}
		
		private function onSceneStatesChange() : void {
			if (EditorStates.isEditor.value == false) {
				return;
			}
			
			var scenes : Array = AnimationSceneStates.scenes.value;
			var index : Number = ArrayUtil.indexOf(scenes, AnimationSceneStates.currentScene.value);
			
			while (index >= listItems.length) {
				addListItem();
			}
			
			if (index >= 0) {
				uiList.scrollToItem(listItems[index], scenes.length);
			}
		}
		
		private function addListItem() : void {
			var container : TPMovieClip = uiList.getListItemsContainer();
			var width : Number = contentWidth - uiList.getScrollbarWidth();
			
			var listItem : UIListItem = new UIListItem(container, width, listItems.length);
			
			listItem.clickEvent.listen(this, onListItemClick);
			
			listItems.push(listItem);
			uiList.addListItem(listItem);
		}
	}
}