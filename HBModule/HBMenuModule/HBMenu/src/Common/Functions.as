
	//import com.adobe.fiber.runtime.lib.StringFunc;
	
	//import Master.FrmMenuScreen;
	
	//import com.google.maps.controls.ZoomControl;
	
	//import Master.Default;
	
	import Master.Menu;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.profiler.showRedrawRegions;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.effects.Zoom;
	import mx.effects.easing.Bounce;
	import mx.events.DataGridEvent;
	import mx.events.ValidationResultEvent;
	import mx.formatters.DateFormatter;
	import mx.geom.RoundedRectangle;
	import mx.managers.PopUpManager;
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.rpc.xml.SimpleXMLEncoder;
	import mx.utils.ArrayUtil;
	import mx.utils.StringUtil;
	import mx.validators.NumberValidator;
	import mx.validators.StringValidator;
	
	import spark.components.TextInput;
	

	private var GlobalObj:Object;
	private var GlobalVar:String = ""; //"<FlexServiceUrl>http://testingserver/IBASDataService/clsDataInterface.asmx?WSDL</FlexServiceUrl><FlexSwfUrl>http://pro61/scmflex/ </FlexSwfUrl><gVchTypCd>PO2</gVchTypCd><gVchTypDesc>Flex Purchase Order</gVchTypDesc><gVchTypFk>1651</gVchTypFk><gLocFk>1</gLocFk><gUmpFk></gUmpFk><gFyrFk>3</gFyrFk><gUsr>ADMIN</gUsr><gUsrFk>1</gUsrFk><gCur>Indian Rupees</gCur><gCurFk>1</gCurFk><gCurRt> 1.0000000</gCurRt>"
	private var gCPRights:String = ""; //"11111111";
	private var Flx_CurDt:String;
	public static var ScreenVal:String= "";
	private var gVchTypDesc:String = "", gVchTypCd:String = "", gVchTypFk:int = 0, gUsrFk:int = 0;
	private var gAction:String = "";
	private var gKeyValue:int = 0;
	private var weburl:String;


	private function getCurrentDate()
	{	
		Flx_CurDt= DateField.dateToString(new Date(),"DD/MM/YYYY")
	}
	
	public function ScreenDtls(Arr:ArrayCollection):void
	{
		//ScreenVal=Arr
		//var GobalXml:String = "<ROOT>";
		//GobalXml += ObjToXmlStr_Comm(ScreenVal,"GobalXml")
		//GobalXml += "</ROOT>";
	}
	public function DecimalChangeCheck(Str:String):void
	{
		var Temp_TxtString:String=this[Str].text;
		var Temp_TxtAC:Array=new Array();
		Temp_TxtAC=Temp_TxtString.split('.');
		
		if(Temp_TxtAC.length>2)
		{
			this[Str].errorString="Only 1 Decimal Point Allow.";
			this[Str].setFocus();					
		}
		
	}
	static public function encrypt(str:String):String {
		
		var result:String = '';
		
		for (var i:int = 0; i < str.length; i++) {
			
			var char:String = str.substr(i, 1);
			
			//var keychar:String = key.substr((i % key.length) - 1, 1);
			
			var ordChar:int = char.charCodeAt(0);
			
			//var ordKeychar:int = keychar.charCodeAt(0);
			
			var sum:int = ordChar +5;
			
			char = String.fromCharCode(sum);
			
			result = result + char;
			
		}
		
		return result;
	}
	static public function decrypt(str:String):String {
		
		var result:String = '';
		
		for (var i:int = 0; i < str.length; i++) {
			
			var char:String = str.substr(i, 1);
			
			//var keychar:String = key.substr((i % key.length) - 1, 1);
			
			var ordChar:int = char.charCodeAt(0);
			
			//var ordKeychar:int = keychar.charCodeAt(0);
			
			var sum:int = ordChar-5;
			
			char = String.fromCharCode(sum);
			
			result = result + char;
			
		}
		
		return result;
		
		
	}

	private function objectToXML(obj:Object,RootXmlNm:String):XML  
	{
		var qName:QName = new QName(RootXmlNm);                     
		var xmlDocument:XMLDocument = new XMLDocument();   
		var simpleXMLEncoder:SimpleXMLEncoder= new SimpleXMLEncoder(xmlDocument);      
		var xmlNode:XMLNode= simpleXMLEncoder.encodeValue(obj, qName, xmlDocument); 
		var xml:XML = new XML(xmlDocument.toString());   
		return xml;
	}
	private function ObjToXmlStr_Comm(XMLArrCol:ArrayCollection,Root:String):String {
		
		var XMLStr="";
		//XMLStr = "<GRID>";
		for each(var XMLNodeObj:Object in XMLArrCol) {
			
			XMLStr += "<"+Root+" "
			for(var tempObject1:Object in XMLNodeObj)
			{
				XMLStr += tempObject1 + "= '"+  ReplaceSplChar(XMLNodeObj[tempObject1]) + "'  "
			}
			XMLStr += " />";
		}
		//XMLStr += "</GRID>"
		return	 XMLStr
	}
private function ReplaceSplChar(Str:String):String
{
	var myStr:String =""; 
	var Arr:Array=new Array();
	
	if(Str)
	{
		Arr=Str.split('&')
			if(Arr.length>1)
			{
				for(var i:int=0;i<Arr.length;i++)
				{
					if(i!=Arr.length-1)
					{
						myStr=myStr+Arr[i]+"&amp;";
					}
					else
					{
						myStr=myStr+Arr[i];
					}				
				}
			}
			else
			{
				myStr=Str;
			}			
			Arr=new Array();
			Arr=myStr.split("'");
			if(Arr.length>1)
			{
				myStr="";
				for(var i:int=0;i<Arr.length;i++)
				{
					if(i!=Arr.length-1)
					{
						myStr=myStr+Arr[i]+"&apos;";
					}
					else
					{
						myStr=myStr+Arr[i];
					}				
				}
			}
			else
			{
				myStr=myStr;
			}
			Arr=new Array();
			Arr=myStr.split("<");
			if(Arr.length>1)
			{
				myStr="";
				for(var i:int=0;i<Arr.length;i++)
				{
					if(i!=Arr.length-1)
					{
						myStr=myStr+Arr[i]+"&lt;";
					}
					else
					{
						myStr=myStr+Arr[i];
					}				
				}
			}
			else
			{
				myStr=myStr;
			}
			Arr=new Array();
			Arr=myStr.split(">");
			if(Arr.length>1)
			{
				myStr="";
				for(var i:int=0;i<Arr.length;i++)
				{
					if(i!=Arr.length-1)
					{
						myStr=myStr+Arr[i]+"&gt;";
					}
					else
					{
						myStr=myStr+Arr[i];
					}				
				}
			}
			else
			{
				myStr=myStr;
			}
			Arr=new Array();
			Arr=myStr.split('"');
			if(Arr.length>1)
			{
				myStr="";
				for(var i:int=0;i<Arr.length;i++)
				{
					if(i!=Arr.length-1)
					{
						myStr=myStr+Arr[i]+"&quot;";
					}
					else
					{
						myStr=myStr+Arr[i];
					}				
				}
			}
			else
			{
				myStr=myStr;
			}			
	}
	else
	{
		myStr="";
	}
	
	return myStr;
}
private function ObjToXmlStr_CommAdd(XMLArrCol:ArrayCollection,Root:String):String {
	
	var XMLStr="";
	//XMLStr = "<GRID>";
	for each(var XMLNodeObj:Object in XMLArrCol) {
		
		XMLStr += "<GridXml  "
		for(var tempObject1:Object in XMLNodeObj)
		{
			XMLStr += tempObject1 + "= '"+  XMLNodeObj[tempObject1] + "'  "
		}
		XMLStr +="AddressType='"+Root+"'"
		XMLStr += " />";
	}
	//XMLStr += "</GRID>"
	return	 XMLStr
}	
	private function ConvertToXml(object:Object,RootNm:String="Root",ElementNm:String="item"):XML
	{
		var xml:XML=<{RootNm}/>;
		
		for each(var obj:Object in object)
		{
			var element:XML = <{ElementNm}/>;
			for (var attribute:String in obj)
			{
				if(attribute != "mx_internal_uid")
				{
					element.@[attribute] = obj[attribute];
				}
			}
			
			xml.appendChild(element);
		}
		
		return xml;
	}
	private function convertXmlToArrayCollection(file:String):Object
	{
		var xml:XMLDocument = new XMLDocument( file );
		
		var decoder:SimpleXMLDecoder= new SimpleXMLDecoder();
		var data:Object = decoder.decodeXML( xml );
		//var array:Array = ArrayUtil.toArray(data.rows.row);
		
		return  data;
	}
	private function convertToDecimal(event:Event,precision:int):void
	{
		if(event.currentTarget.text != "")
		{
			event.currentTarget.text = Number(event.currentTarget.text).toFixed(precision).toString();
		}
	}
	
	
	private function convertDDMMYYYY(DDMMMYYYY:String):String
	{
		var dtStr:String="";
		
		if(DDMMMYYYY == "")return dtStr;
		
		var arr:Array = DDMMMYYYY.split("-");
		var arrMonth:ArrayCollection = new ArrayCollection([
			{str:"JAN",value:"01"},
			{str:"FEB",value:"02"},
			{str:"MAR",value:"03"},
			{str:"APR",value:"04"},
			{str:"MAY",value:"05"},
			{str:"JUN",value:"06"},
			{str:"JUL",value:"07"},
			{str:"AUG",value:"08"},
			{str:"SEP",value:"09"},
			{str:"OCT",value:"10"},
			{str:"NOV",value:"11"},
			{str:"DEC",value:"12"}]);
		
		if(arr.length == 1)
		{
			arr = DDMMMYYYY.split("/");
		}
		
		for (var i:int;i<arrMonth.length;i++)
		{
			if(arr[1].toString().toUpperCase() == arrMonth.source[i].str)
			{
				dtStr = arr[0] + "/" + arrMonth.source[i].value + "/" + arr[2];
				i = arrMonth.length;
			}
		}
		
		return dtStr;
	}
	private function SepDate(DDMMMYYYY:String):String
	{
		var dtStr:String="";
		if(DDMMMYYYY != "")
		{		
		var D:String="";
		var M:String="";
		var Y:String="";
		var YY:String=""
		Flx_CurDt= DateField.dateToString(new Date(),"DD/MM/YYYY")
		
		var arr:Array =DDMMMYYYY.split("/");
		if(arr.length!=3)
		{
			
		D=DDMMMYYYY.substr(0,2)
		M=DDMMMYYYY.substr(2,2)
		if(DDMMMYYYY.length==8)
		{
		Y=DDMMMYYYY.substr(4,4)
		}
		else
		{
		arr =Flx_CurDt.split("/");
		Y=arr[2].toString()
		//Y=YY.substr(0,2)
		//Y+=DDMMMYYYY.substr(4,2)
		}
		dtStr = D + "/" + M + "/" + Y;
		}
		else
		{
			dtStr=DDMMMYYYY
		}
		}
		return dtStr;
	}
	
	/*
	private function funTIRestrict(mainObj:Object):void
	{
		var obj:Object = new Object();
		for (var i:int=0;i<1000;i++)
		{	
			try
			{
				obj = mainObj.getElementAt(i);
				switch(obj.className)
				{
					case "VGroup":
					case "HGroup":
					case "Group":
					case "NavigatorContent":
					case "TabNavigator":
						funTIRestrict(obj);
						break;
					case "TextInput":
					case "HelpText":
						if(obj.restrict == null)
							obj.restrict = "0-9A-Za-z";
						break;
				}
			}catch(er:Error){return;}
		}
		obj = null;
	}*/
	protected function MousDownHandler(event:MouseEvent):void
	{
		//Alert.show("Mouse Down");
		ExternalInterface.call("MakeSelectVisible");
	}
	public function funLoginInfo(ScrGlobalPram:String=""):ArrayCollection
	{
		//funTIRestrict(this);
		this.addEventListener(MouseEvent.MOUSE_DOWN, MousDownHandler)
		if(FlexGlobals.topLevelApplication.parameters.loginInfo != null) 
			GlobalVar = FlexGlobals.topLevelApplication.parameters.loginInfo;
		var ScrDtls:ArrayCollection=new ArrayCollection();
		var ObjMn:Menu=new Menu;	
		ScrDtls=ObjMn.UsrNmVal();	
		if((ScrDtls.source==null)||(ScrDtls.length==0))
		{
			GlobalObj = convertXmlToArrayCollection(ScrGlobalPram)
			var Scr:ArrayCollection = new ArrayCollection
				([{					
					UsrId:GlobalObj.gUsrFk,UsrName:GlobalObj.gUsr,sav:"true",SctId:GlobalObj.gScrId,
					Del:"true",ScrNM:"Screen&Name&",ServicePath:"",ReportUrl:"",
					RoleId:0,RoleName:""
				}]);
			ScrDtls=Scr;
		}
		return ScrDtls;
	}

	/*
	[Bindable]
	[Embed(source='../Assets/error.png')]
	private var ErrIcon:Class;
	*/

	//Error Large
	[Bindable]
	[Embed(source='../Assets/CrossLarge2.png')]
	private var iconErrLarge:Class;


	[Bindable]
	[Embed(source='../Assets/warning3.png')]
	private var iconWarning:Class;


	[Bindable]
	[Embed(source='../Assets/Tickbig.png')]
	private var iconTickLarge:Class;


	[Bindable]
	[Embed(source='../Assets/TickSmall.png')]
	private var iconTickSmall:Class;

	[Bindable]
	[Embed(source='../Assets/CrossSmall.png')]
	private var iconCrossSmall:Class;

	
	
	private function MoveScr(alert:Alert,align:int=0,type:String="error"):void
	{	
		
	}
	private function alignAlert(alert:Alert,align:int=0,type:String="error"):void
	{	
		alert.setStyle("iconClass", iconTickLarge);
		var zoom:Zoom=new Zoom();
		zoom.easingFunction=Bounce.easeOut;	
		alert.visible=true;
		alert.setStyle("creationCompleteEffect",zoom);
		alert.setStyle("iconClass", iconTickLarge);
		
		//alert.setStyle("icon", iconTickLarge);
		var _alert:Alert = alert;		
		var buttonArray:Array = _alert.mx_internal::alertForm.mx_internal::buttons;
		buttonArray[0].setStyle("icon", iconTickSmall);
		try
		{
			buttonArray[1].setStyle("icon", iconCrossSmall);	
		}catch(er:Error){}
		
		if(_alert.title == "")_alert.title = "Alert";
		
		PopUpManager.centerPopUp(_alert);
		switch(align)
		{
			case 0:
				if(_alert.y == 0 )
				{
					_alert.move(((this.width - _alert.width) /2),50);
				}
				else
				{
					_alert.move(((this.width - _alert.width) /2),(this.height /3) - _alert.height);	
				}
				break;
		}
		
	}

	private function alignPopUp(popup:IFlexDisplayObject,VAlign:Number=0,HAlign:Number=1):void
	{	
		switch(VAlign)
		{
			case 0:
				PopUpManager.centerPopUp(popup);
				popup.move(((this.width - popup.width) /2),25);
				break;
		}
		switch(HAlign)
		{
			case 0:
				PopUpManager.centerPopUp(popup);
				popup.move(0,0);
				break;
		}
	}
	private function isDate(dt:String,dtFormat:int):Boolean
	{
		var regx:RegExp; 
			
		switch(dtFormat)
		{
			//DD/MMM/yyyy
			case 0:
				regx =/^([01][0-9]|2[0-9]|3[0-1])(\/|-|.)(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(\/|-|.)(\d{4})$/
				break;
			//DD/MM/YYYY
			case 1:
				regx =/^([01][1-9]|3[0-1])\/([01][1-9]|1[0-2])\/(\d{4})$/
				break;
		}
		
		if(regx.test(StringUtil.trim(dt.toUpperCase())))
			return true;
		else
			return false;
			
		
	}
	private var sValid:StringValidator=new StringValidator();
	private function Valivation(event:Object)
	{
		
		sValid.source= event.currentTarget;
		sValid.property="text";		
		
		if(event.currentTarget.text=="")
		{	
			event.currentTarget.setFocus();
			return false;
		}
		else
		{
			return true;
		}
	}
	
		
	private function isNumber(event:Object):Boolean
	{
		var numVal:NumberValidator = new NumberValidator();
		numVal.decimalSeparator = ".";
		numVal.property = "text";
		numVal.required = false;
		numVal.triggerEvent = event.type;
		numVal.source = event.currentTarget;
		numVal.trigger = event.currentTarget;
		
		if(isNaN(Number(StringUtil.trim(event.currentTarget.text))))
		{	
			event.currentTarget.setFocus();
			return false;
		}
		else
		{	
			return true;
		}
		numVal = null;
	}

	private function funNumValidate(Cntrl:Object):void
	{
		var str:String , val:int;
		if (Cntrl.text != "" )
		{
			var valFlag:Boolean = isNaN(Number(Cntrl.text));
			if ( valFlag == true )
			{
				Cntrl.text =""
				Cntrl.setFocus();
			}
		}
	}

	public function DateValid(CtrlNm:Event):void
	{	
		if (CtrlNm.currentTarget.text == "")
			return;		
		var GDt:Date = DateField.stringToDate(CtrlNm.currentTarget.text,"DD/MM/YYYY");
		if(GDt == null)
		{
			Alert.show("Please Enter in DD/MM/YYYY Format","Error",Alert.OK,this,null,iconErrLarge,Alert.OK);
		}
		else
		{
			var obj:Object=DateParts(CtrlNm.currentTarget.text);			
			CtrlNm.currentTarget.text = obj['DD/MM/YYYY'];
		}			
	}

	public function DateParts(Input:String):Object
	{
		var GivenDate:Date = DateField.stringToDate(Input,"DD/MM/YYYY")
		var Obj:Object=new Object()
		var  DF:DateFormatter = new DateFormatter()
		DF.formatString = "DD/MM/YYYY";
		Obj['DD/MM/YYYY'] = DF.format(GivenDate)
		DF.formatString = "DD-MM-YYYY";
		Obj['DD-MM-YYYY'] = DF.format(GivenDate)
		DF.formatString = 'YYYY-MM-DD';
		Obj['YYYY-MM-DD'] = DF.format(GivenDate)
		DF.formatString = 'YYYY/MM/DD';
		Obj['YYYY/MM/DD'] = DF.format(GivenDate)
		DF.formatString = 'DD';
		Obj['day'] = DF.format(GivenDate)
		DF.formatString = 'MM';
		Obj['month'] = DF.format(GivenDate)
		DF.formatString = 'YYYY';
		Obj['year'] = DF.format(GivenDate)
		return Obj
	}
public static function monthDifference(start:Date, end:Date):int
{
	return (end.getUTCFullYear() - start.getUTCFullYear()) * 12 +(end.getUTCMonth() - start.getUTCMonth());
}

	private function DGridNumChk(event:DataGridEvent):void
	{
		// get a reference to the datagrid
		var grid:DataGrid=event.target as DataGrid;
		// get a reference to the name of the property in the
		// underlying object corresponding to the cell that's being edited
		var field:String = event.dataField;
		// get a reference to the row number (the index in the 
		// dataprovider of the row that's being edited)
		var row:Number = Number(event.rowIndex);
		// get a reference to the column number of
		// the cell that's being edited
		var col:int = event.columnIndex;
		var ReturnVal:Number=0;
		
		
		//if (grid != null)
		//{
			// gets the value (pre-edit) from the grid's dataprovider
			//var oldValue:Number = Number( StringFunc.replaceAll(grid.dataProvider.getItemAt(row)[field],",",""));
			// you could also use the following line to get the value
			//var newValue:Number = Number(StringFunc.replaceAll(grid.itemEditorInstance[grid.columns[col].editorDataField],",",""));
			//var ChkNumVal:String=newValue.toString()
			//if(ChkNumVal=="NaN")
			//{	
//				event.preventDefault();
//				//Text(grid.itemEditorInstance).errorString="Enter a valid Value.";
//				grid.itemEditorInstance[grid.columns[col].editorDataField]="0"
//				newValue=0
//			}
//			else
//			{grid.itemEditorInstance[grid.columns[col].editorDataField]=newValue}			
		//}
	}

/*
	public static function daysInMonth( date:Date ):Number {
			// get the first day of the next month
		var _localDate:Date = new Date( date.fullYear, DateUtils.dateAdd( DateUtils.MONTH, 1, date ).month, 1 );
			// subtract 1 day to get the last day of the requested month
		return DateUtils.dateAdd( DateUtils.DAY_OF_MONTH, -1, _localDate ).date;
	}
*/