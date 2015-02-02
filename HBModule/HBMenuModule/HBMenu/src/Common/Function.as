

import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.rpc.xml.SimpleXMLEncoder;
import mx.utils.ObjectUtil;
import mx.utils.XMLUtil;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.profiler.showRedrawRegions;
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.controls.DateField;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
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

import spark.components.TextInput;

private var GlobalObj:Object;
private var GlobalVar:String = ""; //"<FlexServiceUrl>http://testingserver/IBASDataService/clsDataInterface.asmx?WSDL</FlexServiceUrl><FlexSwfUrl>http://pro61/scmflex/ </FlexSwfUrl><gVchTypCd>PO2</gVchTypCd><gVchTypDesc>Flex Purchase Order</gVchTypDesc><gVchTypFk>1651</gVchTypFk><gLocFk>1</gLocFk><gUmpFk></gUmpFk><gFyrFk>3</gFyrFk><gUsr>ADMIN</gUsr><gUsrFk>1</gUsrFk><gCur>Indian Rupees</gCur><gCurFk>1</gCurFk><gCurRt> 1.0000000</gCurRt>"
private var gCPRights:String = ""; //"11111111";
private var Flx_CurDt:String;

private var gVchTypDesc:String = "", gVchTypCd:String = "", gVchTypFk:int = 0, gUsrFk:int = 0;
private var gAction:String = "";
private var gKeyValue:int = 0;
private var weburl:String;


[Bindable]
[Embed(source="//Assets/TickLarge.png")]
public var TickIcon:Class;
[Bindable]
[Embed(source='//Assets/Warning1.png')]
public var WarningIcon:Class;
[Bindable]
[Embed(source='//Assets/CrossLarge.png')]
public var CrossIcon:Class;
public var a:Alert;
public var items:ArrayCollection; 
private function onCreationComplete():void
{
//	var source:Array = [{id:1, name:"One"}, {id:2, name:"Two"}, {id:3, name:"Three"}];
//	var collection = new ArrayCollection(source);
//	trace(objectToXML(collection.source).toXMLString());
} 
private function objectToXML(obj:Object,Root:String):XML
{
	var qName:QName = new QName(Root);
	var xmlDocument:XMLDocument = new XMLDocument(); 
	var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
	var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument)
	var xml:XML = new XML(xmlDocument.toString());
	return xml; 
}  
private function ObjToXmlStr(XMLArrCol:ArrayCollection):String {
	var XMLStr="";
	XMLStr = "<GRID>";
	for each(var XMLNodeObj:Object in XMLArrCol) {
		
		XMLStr += "<PrdDtls PrdDispNm ='"  + XMLNodeObj.PrdDispNm + "' UId ='" + XMLNodeObj.UId + "' Sts ='" + XMLNodeObj.Sts + "' MRPAmt ='" + XMLNodeObj.MRPAmt + "' ModelNo ='" + XMLNodeObj.ModelNo + "'";
		XMLStr += " />";
	}
	XMLStr += "</GRID>"
	return	 XMLStr
}
private function ObjToXmlStr_Comm(XMLArrCol:ArrayCollection,Root:String):String {
	
	var XMLStr="";
	//XMLStr = "<GRID>";
	for each(var XMLNodeObj:Object in XMLArrCol) {
		
		XMLStr += "<"+Root+" "
		for(var tempObject1:Object in XMLNodeObj)
		{
			XMLStr += tempObject1 + "= '"+  XMLNodeObj[tempObject1] + "'  "
		}
		XMLStr += " />";
	}
	//XMLStr += "</GRID>"
	return	 XMLStr
}
private function getCurrentDate()
{	
	Flx_CurDt= DateField.dateToString(new Date(),"DD/MM/YYYY")
}

