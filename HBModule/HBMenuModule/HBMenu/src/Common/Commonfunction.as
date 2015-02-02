
//include "Functions.as";

import Master.Default;

import flash.external.ExternalInterface;
import flash.utils.flash_proxy;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.CursorManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.mxml.WebService;
import mx.validators.EmailValidator;
private var ws:WebService;
private var webSer_CallCnt:int=0;
private var TranWeb_CallCnt:int=0;
private var CtrlVal:String=""
private var icon:Class;
///Database Access the throw WEB
private function useWebService(PrcName:String,CtrlNm:String,ParmArry:Array):void 
{ 				
	var browserUrl:String = ExternalInterface.call("eval", "window.location.href");
	var arr:Array =browserUrl.split("/");		
	var Obj:Default = new Default();
	ws = new WebService();	
	//ws.wsdl=arr[0].toString()+"//"+arr[2].toString()+"/WebService/clsDataInterface.asmx?WSDL"
	ws.wsdl="http://localhost9467/web/clsDataInterface.asmx?WSDL";	
	ws.description=CtrlNm;
	ws.addEventListener("result", echoResultHandler);
	ws.addEventListener("fault",  faultHandle);
	ws.loadWSDL();
	CtrlVal=CtrlNm
	
	if (ws.ready==false && webSer_CallCnt==0)
	{
		CursorManager.setBusyCursor();
		if (this.enabled) this.enabled=false;
	}
	
	webSer_CallCnt++;
	
	switch(PrcName)
	{
		case "writeFile":
			ws.fnWriteFileContent(ParmArry[0]);
			break;
		case "openFile":
			ws.fnGetFileContent(ParmArry[0]);
			break;
		case "GetNormalCSV":
			ws.fnGetBuildXML(ParmArry[0], 0);
			break;		
		case "GetBeakupCSV":
			ws.fnGetBuildXML(ParmArry[0], 1);
			break;				
		//For test Purpose///////////////////
		case "txtFile":
			//ws.SSISExecute();
			ws.fnWriteFile(ParmArry[0]);
			break;
		case "ee":
			ws.SSISExecute();
			break;
		/////////////////////////////////////
		default:
			ws.fnExecute_Hlp(PrcName,ParmArry);
			break;
	}		
}
private function PurchaseWebService(Action:String,CtrlNm:String,ParmArry:Array):void 
{ 				
	var browserUrl:String = ExternalInterface.call("eval", "window.location.href");
	var arr:Array =browserUrl.split("/");		
	var Obj:Default = new Default();
	ws = new WebService();	
	//ws.wsdl=arr[0].toString()+"//"+arr[2].toString()+"/WebService/clsDataInterface.asmx?WSDL"
	ws.wsdl="http://localhost:9467/ERPService.asmx?WSDL";	
	ws.description=CtrlNm;
	ws.addEventListener("result", echoResultHandler);
	ws.addEventListener("fault",  faultHandle);
	ws.loadWSDL();
	CtrlVal=CtrlNm
	
	if (ws.ready==false && webSer_CallCnt==0)
	{
		CursorManager.setBusyCursor();
		if (this.enabled) this.enabled=false;
	}
	
	webSer_CallCnt++;
	
	switch(CtrlNm)
	{
		case "Save_CUSTOM":
			ws.PurchaseSave(Action,ParmArry);
			break;
		case "Search_CUSTOM":
			ws.PurchaseSearchResult(Action,ParmArry);
			break;
		case "Delete_CUSTOM":
			ws.PurchaseDelete(Action,ParmArry);
			break;		
		default:
			ws.PurchaseHelpResult(Action,ParmArry);
			break;
	}		
}
private function useWeb(Action:String,CtrlNm:String,ParmArry:Array):void 
{ 				
	var browserUrl:String = ExternalInterface.call("eval", "window.location.href");
	var arr:Array =browserUrl.split("/");		
	var Obj:Default = new Default();
	ws = new WebService();	
	//ws.wsdl=arr[0].toString()+"//"+arr[2].toString()+"/WebService/clsDataInterface.asmx?WSDL"
	ws.wsdl="http://localhost:9467/WebService1.asmx?WSDL";	
	ws.description=CtrlNm;
	ws.addEventListener("result", echoResultHandler);
	ws.addEventListener("fault",  faultHandle);
	ws.loadWSDL();
	CtrlVal=CtrlNm
	
	if (ws.ready==false && webSer_CallCnt==0)
	{
		CursorManager.setBusyCursor();
		if (this.enabled) this.enabled=false;
	}
	
	webSer_CallCnt++;
	
	switch(CtrlNm)
	{
		case "Save_CUSTOM":
			ws.Save(Action,ParmArry);
			break;
		case "Search_CUSTOM":
			ws.SearchResult(Action,ParmArry);
			break;
		case "Delete_CUSTOM":
			ws.Delete(Action,ParmArry);
			break;		
		default:
			ws.HelpResult(Action,ParmArry);
			break;
	}		
}

private function echoResultHandler(event:ResultEvent):void
{ 		
	
	webSer_CallCnt--;
	
	if (ws.ready==true && webSer_CallCnt==0)
	{
		CursorManager.removeBusyCursor();
		if (!this.enabled) this.enabled=true;
	}
	/*
	var xTblCnt:int  = 0;
	for each (var obj:Object in event.result.Tables)
	{ xTblCnt++; }
	
	if (xTblCnt == 1)
	{
	return;
	}*/
	
	
	//For test Purpose//////////////////////////
	
	////////////////////////////////////////
	
	
	
	if (event.result.Tables.ERRORTBL.Rows.length >= 1)
	{
		CursorManager.removeBusyCursor();		
		//alignAlert(Alert.show(event.result.Tables.ERRORTBL.Rows[0].Exception.toString(),"Error",Alert.OK,null,null,iconWarning));
		Alert.show(event.result.Tables.ERRORTBL.Rows[0].Exception.toString(),"Error",Alert.OK,null,null,null);
		return;
	}
	else if(event.currentTarget.description.toString()=="ee_CUSTOM")
	{
		Custom_WebSer_Result(event);
		return;
	}
	else
	{
		if (event.currentTarget.description.toString().indexOf("CUSTOM")!=-1)
		{			
			Custom_WebSer_Result(event);
		}
		else
		{
			try
			{
				/*
				var tmpArr:Array = new Array();
				var arrWidth:Array = new Array();
				
				arrWidth = this[event.currentTarget.description.toString()].pxSetColumnsWidth.toString().split(",");
				tmpArr = event.result.Tables.Table.Columns.source as Array;
				tmpArr = getDataGridColumn(tmpArr,tmpArr,arrWidth);
				
				this[event.currentTarget.description.toString()].dgridColumns = tmpArr; 
				this[event.currentTarget.description.toString()].dataProvider= event.result.Tables.Table.Rows;
				tmpArr = null;
				arrWidth = null;
				*/
				this[event.currentTarget.description.toString()].dataProvider1= event.result.Tables.Table;
			}catch(er:Error)
			{
				//alignAlert(Alert.show(er.toString(),"Error",Alert.OK,null,null,iconErrLarge));
				Alert.show(er.toString(),"Error",Alert.OK,null,null,icon.CrossLarge.png);
				return;
			}
			
		}
	}	
}


private function  faultHandle(event:FaultEvent, token:Object=null ):void
{	
	/*try
	{
	webSer_CallCnt--;		
	if (ws.ready==true && webSer_CallCnt==0)
	{		
	cursorManager.removeBusyCursor();
	if (!this.enabled) this.enabled=true;
	}
	}catch(er:Error){}*/
	
	CursorManager.removeBusyCursor();
	if (!this.enabled) this.enabled=true;
	
	//alignAlert(Alert.show( "FAULT: " +   event.fault.message, "FAULT",Alert.OK,null,null,iconErrLarge));
	//Alert.show( "FAULT: " +   event.fault.message, "FAULT",Alert.OK,null,null,icon.CrossLarge.png);
	//Alert.show("Network Problem, Please close and try again");
	Alert.show("Network Problem, Please close and try again")//,null,Alert.OK, null, null,icon.CrossLarge.png, Alert.OK);
	Alert.show(event.fault.message.toString())
	
}


private function funDocPrint(DocPk:int, CstmParam1:String, CstmParam2:String)
{
	ExternalInterface.call("callPrint",DocPk,CstmParam1,CstmParam2, 1);
}

private function funDocPrint_New(DocPk:int, CstmParam1:String, CstmParam2:String, PrntTyp:int)
{
	ExternalInterface.call("callPrint",DocPk,CstmParam1,CstmParam2, PrntTyp);
}

private function funDocBulkPrint_New(DocPk:String, CstmParam1:String, CstmParam2:String, PrntTyp:int, PrntFlg:String,CustXml:String)
{
	ExternalInterface.call("callPrint",DocPk,CstmParam1,CstmParam2, PrntTyp, PrntFlg,CustXml);
}
