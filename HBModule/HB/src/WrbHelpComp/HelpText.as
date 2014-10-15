package WrbHelpComp
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.sampler.NewObjectSample;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.containers.Canvas;
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.ComponentDescriptor;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ValidationResultEvent;
	import mx.styles.StyleManager;
	import mx.utils.StringUtil;
	import mx.validators.StringValidator;
	
	import spark.components.Group;
	import spark.components.TextInput;
	
	[Event("onselection")]
	[Event("onbeforeselection")]
	
	public class HelpText extends Group {
		private var _collection :ArrayCollection=new ArrayCollection();
		private var _dspHeight:Number=200;
		private var _fldWidth:String="";
		private var _dspToolTip:String="";
		private var _fldName:String="";
		private var _qryText:String="";
		private var _srhLen:int;
		private var _text:String="";
		private var _dataRow:Array;
		private var _w:Number=140;
		private var _h:Number=20;
		private var _t:Number=0;
		private var iC:Number;
		private var _tf:Boolean;
		private var _selRow:Array= new Array();
		private var tbxOffer:spark.components.TextInput=new spark.components.TextInput ;
		private var grdOffer:DataGrid=new DataGrid();
		private var dgcOffer:DataGridColumn;
		private var params:Array;
		private var cols:Array;
		private var _IsOk:Boolean;
		private var _IsReq:Boolean=false;
		private var _IsEnb:Boolean;
		private var _FstNonHdnIndx:int;
		private var KeyChangeFlag:Boolean=false;
		private var _GrdY:Number = 0;
		[Bindable]
		private var collectionData:ArrayCollection;
		private var flag:Boolean=false;
		private var _dataProvider:ArrayCollection=new ArrayCollection();
		public static const onsel:String = "onselection";
		public static const onbeforesel:String = "onbeforeselection";
		private var _SelectRow:Object={};
		private var sValid:StringValidator;
		public function set PxGridSetUp(val:Number):void
		{				
			this._GrdY = val				
		}
		public function get PxGridSetUp():Number
		{return this._GrdY}
		
		public function HelpText(){
			super();
			this.tbxOffer.width=140;
			this.tbxOffer.height=22;			
			_fldName=this._fldName;
			this.tbxOffer.setStyle("borderStyle", "solid");
			this.tbxOffer.setStyle("borderColor", 0x66CC33);			
			sValid=new StringValidator();
			sValid.source=this.tbxOffer;
			sValid.property="text";
			
			grdOffer.doubleClickEnabled=true;
			this.addElement(this.tbxOffer);
			//<>Bharani
			this.addEventListener("focusOut",fnLostFocus);
			
			sValid.addEventListener(ValidationResultEvent.INVALID,TestInvalid);
			sValid.addEventListener(ValidationResultEvent.VALID,TestValid);
			
			tbxOffer.addEventListener(KeyboardEvent.KEY_DOWN,doCSelection);
			tbxOffer.addEventListener(KeyboardEvent.KEY_DOWN,pxFunI);
			
			tbxOffer.addEventListener(Event.CHANGE,pxFunP);
			tbxOffer.addEventListener(MouseEvent.CLICK,pxFunA);
			
			grdOffer.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,pxFunN); //Modified by kolanchinathan
			grdOffer.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, doMSelection); //Modified by kolanchinathan
			
			grdOffer.addEventListener(KeyboardEvent.KEY_DOWN,pxFunK);
			grdOffer.addEventListener(KeyboardEvent.KEY_DOWN, doKSelection);
						
			this.showDataTip = true;
		}
		
		public function getDataGridColumn(_cols:Array):Array
		{
			var DGrid = new DataGrid();
			var gridColumn:DataGridColumn;
			DGrid.columns = new Array;
			var dgColumn = DGrid.columns;
			var width:int;
			var colsWidth:Array = this.pxSetColumnsWidth.split(",");
			for(var i:int=0;i<_cols.length;i++)
			{	
				width = Number(colsWidth[i]);
				
				if(width == 0)
					width = 100;
				
				gridColumn = new DataGridColumn();
				gridColumn.dataField = _cols[i];
				gridColumn.headerText = _cols[i];
				gridColumn.width = width;
				dgColumn.push(gridColumn);
			}
			
			
			DGrid = null;
			width = null;
			colsWidth = null;
			gridColumn = null;
			return dgColumn;
		}
		
		public function fnClear(){
			_SelectRow=null;
			tbxOffer.text = "";
		}
		public function set showDataTip(value:Boolean):void //Modified by kolanchinathan
		{
			this.grdOffer.showDataTips = value;
		}
		
		protected function fnLostFocus(event:FocusEvent):void{
			try{
				
				if ((event.relatedObject!=tbxOffer) && (event.relatedObject != grdOffer)
					&& (event.relatedObject.parent.parent.parent.parent.parent != grdOffer))				
				{	
					grdOffer.visible=false;
					if (KeyChangeFlag == true)
					{
						KeyChangeFlag == false;
						dispatchEvent(new Event(onsel));
					}
				}
			}catch(exp:Error){}
		}
		
		private function TestValid(event:ValidationResultEvent):void{
			if(pxIsRequired)
				sValid.required=true;
			else
				sValid.required=false;
			IsValid=true;
		}
		private function TestInvalid(event:ValidationResultEvent):void{
			IsValid=false;
		} 
		private function setTheIndex(obj:Sprite):void{   
			setChildIndex(obj,0);  
		}
		protected function doMSelection(evt:ListEvent):void {
			dispatchEvent(new Event(onsel));
		}
		private var lastIndex:int=0;
		protected function doKSelection(evt:KeyboardEvent):void {
			if(evt.keyCode==Keyboard.ENTER || evt.keyCode==Keyboard.ESCAPE){
				KeyChangeFlag=false;
				dispatchEvent(new Event(onsel));
			}
			
			//Added by kolanchinathan
			if(evt.keyCode == Keyboard.UP)
			{
				if(lastIndex == -1)
				{
					this.grdOffer.visible = false;this.tbxOffer.setFocus();
				}
				else
				{
					if(!this.grdOffer.visible){this.grdOffer.visible = true;}
				}
				lastIndex = this.grdOffer.selectedIndex - 1; 
			}
			else if(evt.keyCode == Keyboard.DOWN && lastIndex == -1)
			{
				lastIndex = 0;
			}
			
			
		}
		
		protected function doCSelection(evt:KeyboardEvent):void {
			if(evt.keyCode==Keyboard.ESCAPE || evt.keyCode==Keyboard.TAB){
				if(KeyChangeFlag==true){
					KeyChangeFlag=false;
					dispatchEvent(new Event(onsel));
				}
				
				return;
			}
			
		}
		public function filterReset():void {
			try{
				//collectionData=this.dataProvider;
				collectionData.filterFunction = null;
				collectionData.refresh();
			}catch(e:Error){}
		}
		public function filterResults():void{
			try{
				collectionData.filterFunction = _sortRows;
				collectionData.refresh();
				if(collectionData.length>0)
				{this.grdOffer.visible=true;} 
				else
				{
					this.grdOffer.visible=false;
					filterReset();
				}
			}catch(e:Error)
			{
				this.grdOffer.visible=false;
				//dispatchEvent(new Event(onbeforesel))
			}
		}
		public function EnableDisable(ed:Boolean):void{			
			tbxOffer.editable=ed;			
		}
		public function selected():Boolean{
			if(_SelectRow != null)
				return true;
			else
				return false;
		}
		private function _sortRows(item:Object):Boolean{
			var key:String = this.tbxOffer.text;
			var ln:int = pxSearchLength;
			key = key.toLowerCase();
			if(ln==0) ln=3;
			try{
				if (key.length >= ln){
					if (cols[_FstNonHdnIndx].dataField != ""){
						var value:String = item[cols[_FstNonHdnIndx].dataField];	
						value = value.toLowerCase();	
						if (value.indexOf(key) >= 0){
							return true;}
					} 
					else {
						for (var o:String in item){
							value = item[o];
							if (value.indexOf(key) >= 0){
								return true;}
						}
					}
				} else {
					return true;}
			}catch(e:Error)
			{}
			return false;
		}
		private function pxFunN(event:Event):void {
			flag=true;
			_SelectRow={};
			if(collectionData.length > 0){
				this.tbxOffer.text=this.grdOffer.selectedItem[pxSetFieldName];
				this._text=this.tbxOffer.text;
				for(var x:int=0;x<cols.length;x++){
					_selRow.push(this.grdOffer.selectedItem[cols[x].dataField]);
					_SelectRow[cols[x].dataField.toString()]=this.grdOffer.selectedItem[cols[x].dataField]
				}
				getDataRow=_selRow;
				this.grdOffer.visible=false;
				this.tbxOffer.setFocus();
			}
			else{
				this._text=this.tbxOffer.text;
				getDataRow=_selRow;
				this.grdOffer.visible=false;
				this.tbxOffer.setFocus();
			}
		}
		private function pxFunP(event:Event):void {
			
			this.grdOffer.selectedIndex = 0;
				
			this.addElement(this.grdOffer);
				
			if(StringUtil.trim(this.tbxOffer.text) != ''){
				if(StringUtil.trim(this.tbxOffer.text)!="%"){
					filterResults();
				}
				else{
					if(collectionData.length > 0){
						this.grdOffer.visible=true; 
					}
					else{
						this.grdOffer.visible=false;
					}
				}
			}
			else{
				this.grdOffer.visible=false;	
				filterReset();
			}
			if(PxGridSetUp != 0)
			{
				this.grdOffer.y = PxGridSetUp;
			}

		}
		private function pxFunAA(event:Event):void {
		}
		private function pxFunU(event:Event):void {
		}
		private function pxFunV(event:Event):void {
			flag=true;
			_SelectRow={};
			if(collectionData.length > 0){
				this.tbxOffer.text=this.grdOffer.selectedItem[pxSetFieldName];
				this._text=this.tbxOffer.text;
				for(var x:int=0;x<cols.length;x++){
					_selRow.push(this.grdOffer.selectedItem[cols[x].dataField]);
					_SelectRow[cols[x].dataField.toString()]=this.grdOffer.selectedItem[cols[x].dataField]
				}
				getDataRow=_selRow;
				this.grdOffer.visible=false;
				this.tbxOffer.setFocus();
			}
			else{
				this._text=this.tbxOffer.text;
				getDataRow=_selRow;
				this.grdOffer.visible=false;
				this.tbxOffer.setFocus();
			}
		}
		private function pxFunA(event:Event):void {
			this.grdOffer.visible=false;
		}
		private function pxFunO(event:Event):void{
		}
		private function pxFunNN(event:Event):void {
			try{
				if(flag){
					flag=false;
					this._text=this.tbxOffer.text;
					this.grdOffer.visible=true;
				}
				else{
					this._text=this.tbxOffer.text;
					this.grdOffer.visible=false;
				}
			}
			catch(e:Error){}
		}
		private function pxFunI(event:KeyboardEvent):void {
			_selRow=[];
			if(event.keyCode!=Keyboard.F2 && event.keyCode!=Keyboard.TAB && tbxOffer.editable==true && KeyChangeFlag==false){
				KeyChangeFlag=true;
				_SelectRow=null;
			}
			
			var grdDetails:Object=collectionData;
			if (grdDetails != null)  
				var cellData:IViewCursor=grdDetails.createCursor();
			if(event.keyCode==Keyboard.ESCAPE || event.keyCode==Keyboard.TAB || event.keyCode==Keyboard.UP){_SelectRow=null;this.grdOffer.visible=false;return;}
			if((event.keyCode==Keyboard.F2 || event.keyCode==Keyboard.DOWN ) && this.tbxOffer.editable==true)
			{
				//Added by kolanchinathan
				
				if(this.grdOffer.dataProvider == null)
				{
					this.grdOffer.visible=false;
					return;
				}
				
				if(this.grdOffer.dataProvider.length == 0)
				{
					this.grdOffer.visible=false;
					return;
				}
				else
				{
					lastIndex = 0;
					pxFunP(event);
					//this.grdOffer.selectedIndex = 0;
					this.grdOffer.visible=true;
					flag=true;
					this.grdOffer.setFocus();
				}
				
			}
		
		}
		private function pxFunK(event:KeyboardEvent):void{
			try{
				_selRow=[];
				if(event.keyCode==Keyboard.ESCAPE || event.keyCode==Keyboard.TAB){_SelectRow=null;this.grdOffer.visible=false; this.tbxOffer.setFocus();return;}
				if(event.keyCode==Keyboard.ENTER){
					_SelectRow={};
					if(collectionData.length > 0){	
						this.tbxOffer.text=this.grdOffer.selectedItem[pxSetFieldName];
						this._text=this.tbxOffer.text;
						for(var x:int=0;x<cols.length;x++){
							_selRow.push(this.grdOffer.selectedItem[cols[x].dataField]);
							_SelectRow[cols[x].dataField.toString()]=this.grdOffer.selectedItem[cols[x].dataField]
						}
						getDataRow=_selRow;
						this.grdOffer.visible=false;
						this.tbxOffer.setFocus();
					}
					else{
						this._text=this.tbxOffer.text;
						getDataRow=_selRow;
						this.grdOffer.visible=false;
						this.tbxOffer.setFocus();
					}
				}
			}
			catch(e:Error){}
		}
		private var _gridColumn:Array;
		public function set dgridColumns(value:Array):void
		{
			_gridColumn = value;
			this.grdOffer.columns = _gridColumn;
		}
		
		[Bindable]
		public function set dataProvider(val:ArrayCollection):void{			
			this._collection = val;
			collectionData= val;			
			setGrdConfig();
		}
		public function set PxMaxChar(val:int):void{	
			this.tbxOffer.maxChars=val
		}
		public function set PxRestrict(val:String):void{	
			this.tbxOffer.restrict=val
		}
		public function get dataProvider():ArrayCollection
		{return this._collection;}
		
		public function set dataProvider1(obj:Object):void
		{
			if(obj == null) return;
			var tmpArr:Array = new Array();
			try
			{
				tmpArr = obj.Columns.source as Array;
				tmpArr = getDataGridColumn(tmpArr);
				_gridColumn = tmpArr;
				this.grdOffer.columns = _gridColumn;				
				this._collection = obj.Rows;			
				collectionData= obj.Rows;
				setGrdConfig();
			}catch(er:Error)
			{
				throw new Error("You must assign Table only");				
			}
			finally
			{
				tmpArr = null;
			}
			
		}
		public function get dataProvider1():Object
		{return this._collection;}
		
		private function setGrdConfig():void
		{	
			
			this.grdOffer.dataProvider = collectionData;			 
			cols = this.grdOffer.columns;
			
			if(this.grdOffer.dataProvider == 0)
			{
				return;
			}
			
			if(StringUtil.trim(this._fldName)=="")
				this._fldName=cols[0].dataField;
			var colsWidth:Array = this.pxSetColumnsWidth.split(",");	
			for (var i:int =0;i<this.grdOffer.columnCount;i++){
				var width1:Number = Number(colsWidth[i]);
				if ((this.grdOffer.columns[i].dataField.toUpperCase().indexOf("PK")!=-1)||(this.grdOffer.columns[i].dataField.toUpperCase().indexOf("FK")!=-1)||(this.grdOffer.columns[i].dataField.toUpperCase().indexOf("ID")!=-1)||(this.grdOffer.columns[i].dataField.toUpperCase().indexOf("HDN")!=-1)){
					this.grdOffer.columns[i].width=0;
					this.grdOffer.columns[i].visible=false;
				}
				else if(_FstNonHdnIndx==-1)
				{
					
					_FstNonHdnIndx=i;
				}
				else
				{
					if((width1==0)||(width1== NaN))
					{
						this.grdOffer.columns[i].width=100;
					}
					else
					{
						this.grdOffer.columns[i].width=width1;
					}
					
				}
				
				var Dcl:DataGridColumn=this.grdOffer.columns[i];
				var Cf:ClassFactory= new ClassFactory(HlpGridHdr);
				Dcl.headerRenderer= Cf;
			}
			
			
			var gH:Number=pxSetHeight;
			var bH:Number=this.tbxOffer.height;
			var bW:Number=this.tbxOffer.width;
			var tH:Number=0;
			var gW:Number=iC;
			this.grdOffer.height=gH;
			this.grdOffer.width=gW;
			this.grdOffer.x=this.tbxOffer.x;
			this.grdOffer.y=this.tbxOffer.y + bH;
			this.tbxOffer.height=bH;
			this.tbxOffer.width=bW;
			tH=bH+gH;
			this.height=tH;
			this.width=gW;
			this.tbxOffer.height=bH;
			this.tbxOffer.width=bW;
			this.grdOffer.width=gW;
			this.grdOffer.id="Hlp_Grid";
			gH=0;
			bH=0;
			bW=0;
			gW=0;
			this.grdOffer.depth=1;
			this.grdOffer.setStyle("borderStyle", "solid");
			this.grdOffer.setStyle("borderColor", 0x0000FF);
			
			this.grdOffer.sortableColumns=false;			
		}
		public function  _setFocus():void		
		{
			this.tbxOffer.setFocus();
			
		}		
		[Bindable]
		public function set pxSetPrompt(val:String):void
		{
			this.tbxOffer.prompt=val;}
		[Bindable]
		public function set pxSetToolTip(val:String):void
		{this._dspToolTip = val;
		this.tbxOffer.toolTip=val;}		
		[Bindable]
		public function set pxSetHeight(val:Number):void
		{this._dspHeight = val;}
		public function get pxSetHeight():Number
		{return this._dspHeight;}
		[Bindable]
		public function set pxSetColumnsWidth(val:String):void
		{this._fldWidth = val;}
		public function get pxSetColumnsWidth():String
		{return this._fldWidth;}
		[Bindable]
		public function set pxSetFieldName(val:String):void
		{this._fldName = val;}
		public function get pxSetFieldName():String
		{return this._fldName;}
		[Bindable]
		override public function set width(val:Number) : void{
			this._w = val;
			this.tbxOffer.width=val;
			commitProperties();
			measure();
			invalidateProperties();
			invalidateSize(); 
		}
		override public function get width():Number
		{return this._w;}
		[Bindable]
		override public function set height(val:Number) : void{
			this._h = val;
			this.tbxOffer.height=val;
			commitProperties();
			measure();
			invalidateProperties();
			invalidateSize();
		}
		override public function get height():Number
		{return this._h;}
		public function set Focus(value:Boolean):void{
			this._tf=value;
			if(_tf)
				this.tbxOffer.setFocus();
			else
				this.tbxOffer.stage.focus=null;
		}
		public function get Focus():Boolean
		{return this._tf;}
		[Bindable]
		public function set pxTabIndex(val:Number): void{
			this._t = val;
			this.tbxOffer.tabIndex=_t;
		}
		public function get pxTabIndex():Number
		{return this._t;}
		[Bindable]
		public function set text(val:String) : void{
			//this._text = val;
			this.tbxOffer.text=val;
			this._text = val;
		}
		public function get text():String
		{
			//return this._text;
			return this.tbxOffer.text;
		}
		[Bindable]
		public function set pxQueryText(val:String):void
		{this._qryText = val;}
		public function get pxQueryText():String
		{return this._qryText;}
		[Bindable]
		public function set pxSearchLength(val:Number):void
		{this._srhLen = val;}
		public function get pxSearchLength():Number
		{return this._srhLen;}
		[Bindable]
		public function set getDataRow(val:Array) : void
		{this._dataRow = val;}
		public function get getDataRow() : Array
		{return this._dataRow;}
		public function get Select_Row():Object 
		{return _SelectRow;}
		public function set Select_Row(Object): void
		{_SelectRow = Object;}
		
		[Bindable]
		public function set IsValid(val:Boolean) : void
		{this._IsOk = val;}
		public function get IsValid() : Boolean
		{return this._IsOk;}
		[Bindable]
		public function set pxIsRequired(val:Boolean) : void
		{this._IsReq = val;}
		public function get pxIsRequired() : Boolean
		{return this._IsReq;}
		[Bindable]
		public function set pxIsEnabled(val:Boolean) : void
		{this._IsEnb = val;}
		public function get pxIsEnabled() : Boolean
		{return this._IsEnb;}
		override protected function commitProperties():void { 
			super.commitProperties(); 
			invalidateDisplayList();  
		} 
	}
}