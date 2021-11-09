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
		/** Emitted when the user clicks on the merge button in the panel */
		public var mergeScenesEvent : CustomEvent;
		/** Emitted when the user clicks on the delete button in the panel */
		public var deleteScenesEvent : CustomEvent;
		
		private var listItems : Vector.<ScenesUIListItem>;
		private var uiList : UIList;
		
		private var deleteButton : UIButton;
		private var mergeButton : UIButton;
		
		public function ScenesPanel(_parent : TPMovieClip, _contentWidth : Number, _contentHeight : Number) {
			super(_parent, "Scenes", _contentWidth, _contentHeight);
			
			sceneSelectedEvent = new CustomEvent();
			mergeScenesEvent = new CustomEvent();
			deleteScenesEvent = new CustomEvent();
			
			var iconsBarHeight : Number = 20;
			var listHeight : Number = _contentHeight - iconsBarHeight;
			
			var listContainer : TPMovieClip = TPMovieClip.create(content, "listContainer");
			
			listItems = new Vector.<ScenesUIListItem>();
			
			uiList = new UIList(listContainer, contentWidth, listHeight);
			
			var iconsBar : TPMovieClip = TPMovieClip.create(content, "iconsBar");
			iconsBar.graphics.beginFill(0x000000, 0.25);
			iconsBar.graphics.drawRect(0, 0, contentWidth, iconsBarHeight);
			
			iconsBar.graphics.lineStyle(1, 0xFFFFFF, 0.1);
			iconsBar.graphics.moveTo(0, 0);
			iconsBar.graphics.lineTo(contentWidth, 0);
			
			iconsBar.y = listHeight;
			
			var mergeButtonElement : TPMovieClip = TPMovieClip.create(iconsBar, "mergeButtonElement");
			mergeButtonElement.graphics.beginFill(0xFFFFFF, 0);
			mergeButtonElement.graphics.drawRect(0, 0, 20, 20);
			mergeButtonElement.graphics.beginFill(0xFFFFFF);
			
			Icons.drawMergeIcon(mergeButtonElement.graphics, 4, 4, 12, 12);
			
			mergeButton = new UIButton(mergeButtonElement);
			mergeButton.mouseClickEvent.listen(this, onMergeButtonClick);
			
			var deleteButtonElement : TPMovieClip = TPMovieClip.create(iconsBar, "deleteButtonElement");
			deleteButtonElement.graphics.beginFill(0xFFFFFF, 0);
			deleteButtonElement.graphics.drawRect(0, 0, 20, 20);
			deleteButtonElement.graphics.beginFill(0xFFFFFF);
			deleteButtonElement.x = 20;
			
			Icons.drawDeleteIcon(deleteButtonElement.graphics, 4, 4, 12, 12);
			
			deleteButton = new UIButton(deleteButtonElement);
			deleteButton.mouseClickEvent.listen(this, onDeleteButtonClick);
			
			AnimationSceneStates.listen(this, onSceneStatesChange, [AnimationSceneStates.currentScene, AnimationSceneStates.scenes]);
			AnimationSceneStates.listen(this, onSelectedScenesStateChange, [AnimationSceneStates.selectedScenes]);
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
				var primaryText : String = "   Scene " + (i + 1);
				var secondaryText : String = startFrames.join(",") + " - " + endFrames[endFrames.length - 1];
				
				if (scene.isForceStopped() == true) {
					primaryText += " | Stopped";
				}
				
				listItems[i].setPrimaryText(primaryText);
				listItems[i].setSecondaryText(secondaryText);
				listItems[i].update();
				
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
		
		private function onSelectedScenesStateChange() : void {
			var selectedSceneCount : Number = AnimationSceneStates.selectedScenes.value.length;
			
			deleteButton.setEnabled(selectedSceneCount > 0);
			mergeButton.setEnabled(selectedSceneCount == 2);
		}
		
		private function onMergeButtonClick() : void {
			mergeScenesEvent.emit();
		}
		
		private function onDeleteButtonClick() : void {
			deleteScenesEvent.emit();
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
			
			var listItem : ScenesUIListItem = new ScenesUIListItem(container, width, listItems.length);
			
			listItem.clickEvent.listen(this, onListItemClick);
			
			listItems.push(listItem);
			uiList.addListItem(listItem);
		}
	}
}