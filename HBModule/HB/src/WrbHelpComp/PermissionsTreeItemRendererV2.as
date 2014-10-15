package WrbHelpComp
{
	import mx.controls.treeClasses.TreeItemRenderer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.controls.CheckBox;
	import mx.controls.treeClasses.*;
	
	public class PermissionsTreeItemRendererV2 extends TreeItemRenderer{
		public var chk:CheckBox;
		public var itemXml:XML;
		public function PermissionsTreeItemRendererV2(){
			super();
			mouseEnabled = false;
		}
		override public function set data(value:Object):void{
			if(value != null){
				super.data = value;
				
				this.itemXml = XML(value);
				if(this.itemXml.@checked == "1"){
					this.chk.selected = true;
				}else{
					this.chk.selected = false;
				}
			}
		}
		override protected function createChildren():void{
			super.createChildren();
			chk = new CheckBox();
			chk.addEventListener(MouseEvent.CLICK, handleChkClick);
			addChild(chk);
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(super.data){
				var tld:TreeListData = TreeListData(super.listData);
				//In some cases you only want a checkbox to appear if an
				//item is a leaf
				//if so, then keep the following block uncommented, 
				//otherwise you can comment it out to display the checkbox
				//for branch nodes
				if(tld.hasChildren){
					this.chk.visible = false;
				}else{
					//You HAVE to have the else case to set visible to true
					//even though you'd think the default would be visible
					//it's an issue with itemrenderers...
					this.chk.visible = true;
				}
				if(chk.visible){
					//if the checkbox is visible then
					//reposition the controls to make room for checkbox
					this.chk.x = super.label.x
					super.label.x = this.chk.x + 17;
					this.chk.y = super.label.y+8;
				}
			}
		}
		
		private function handleChkClick(evt:MouseEvent):void{
			if(this.chk.selected){
				//this.checked = true;
				this.itemXml.@checked = "1";
			}else{
				//this.checked = false;
				this.itemXml.@checked = "0";
			}
		}
	}
}
