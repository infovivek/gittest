
//include "Functions.as";

//import Master.FrmMenuScreen;

import flash.external.ExternalInterface;
import flash.utils.flash_proxy;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.effects.Rotate;
import mx.effects.Zoom;
import mx.effects.easing.Bounce;
import mx.managers.CursorManager;
import mx.managers.ToolTipManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.soap.mxml.WebService;
import mx.validators.EmailValidator;
import mx.validators.Validator;

private var ws:WebService;
private var webSer_CallCnt:int=0;
private var TranWeb_CallCnt:int=0;
private var CtrlVal:String=""
private var icon:Class;
///Database Access the throw WEB
private function BrowserData():Array 
{ 				
	var browserUrl:String = ExternalInterface.call("eval", "window.location.href");
	var arr:Array =browserUrl.split("/");	
	//var Obj:FrmMenuScreen = new FrmMenuScreen();		
	var BrowserStr:String = arr[0].toString()+"//"+arr[2].toString();
	return arr;	
}
 
private function useWeb(Action:String,CtrlNm:String,ParmArry:Array):void 
{
	/*var browserUrl:String = ExternalInterface.call("eval", "window.location.href");
	var arr:Array =browserUrl.split("/");	
	var arr1:Array =browserUrl.split("?");
	var urlstr:String= ParmArry[0].toString();	
	var urlxml:XML= XML(urlstr);  
	
	var Path:String=urlxml.children().attribute("ServicePath").toString();
	ws = new WebService(); 
	if(Path!="")
	{ 
		urlxml.GlobalXml.@UsrId =  arr1[1].toString();
		ParmArry[0]=urlxml.toString();
		ws.wsdl=arr[1].toString()+"/"+Path+"/HBService.asmx?WSDL"; 
	}
	else
	{   
		urlxml.GlobalXml.@UsrId = arr1[1].toString();
		ParmArry[0]=urlxml.toString();
		ws.wsdl="http://hbstay.in/HBService/HBService.asmx?WSDL"; 
		// ws.wsdl="http://localhost:3654/HBService.asmx?WSDL"; 
	}	 
	ws.description=CtrlNm;
	ws.addEventListener("result", echoResultHandler);
	ws.addEventListener("fault",  faultHandle);
	ws.loadWSDL();
	CtrlVal=CtrlNm*/
		
	var browserUrl:String = ExternalInterface.call("eval", "window.location.href");
	var arr:Array =browserUrl.split("/");		
	var urlstr:String= ParmArry[0].toString();
	var urlxml:XML= XML(urlstr);
	var Path:String=urlxml.children().attribute("ServicePath").toString();
	ws = new WebService();
	//ws.wsdl=arr[1].toString()+"HMS_Service/HMSService.asmx?WSDL"
	if(Path!="")
	{
		ws.wsdl=arr[1].toString()+"/"+Path+"/HBService.asmx?WSDL";
		//ws.wsdl="http://sstage.in/HBService/HBService.asmx?WSDL";
	}
	else
	{ 
	ws.wsdl="http://localhost:3654/HBService.asmx?WSDL"; 
	//	ws.wsdl="http://192.168.1.14/HBService.asmx?WSDL"; 
	}	
	//ws.wsdl="http://localhost/HMS_Service/HBService.asmx?WSDL"; 
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
		case "ErrorHelp_CUSTOM":
			ws.ErrorHelp(Action,ParmArry);
			break;
		case "Print_CUSTOM":						
			ws.FastPrint(Action,ParmArry);
			break;
		case "DynamicReport_CUSTOM":
			ws.DynamicReport(Action,ParmArry);
			break;
		default:
			ws.HelpResult(Action,ParmArry);
			break;
	}		
}
public  function TextValidator(a:String):void
{		
	var validator:Validator=new Validator();
	validator.required=true;
	validator.property="text";
	validator.source=this[a]
	ToolTripfunClose();
}
public  function ToolTripfunClose():void
{	
	var zoom:Zoom=new Zoom();
	var rotate:Rotate=new Rotate();
	ToolTipManager.hideDelay = 2000;
	//ToolTipManager.showEffect = rotate;
	ToolTipManager.hideEffect = zoom;
	
}	
public  function Alertfun(a:Alert):void
{		
	var zoom:Zoom=new Zoom();
	zoom.easingFunction=Bounce.easeOut;	
	a.visible=true;
	a.setStyle("creationCompleteEffect",zoom);
	
}
private function echoResultHandler(event:ResultEvent):void
{ 		
	
	webSer_CallCnt--;
	
	if (ws.ready==true && webSer_CallCnt==0)
	{
		CursorManager.removeBusyCursor();
		if (!this.enabled) this.enabled=true;
	}	
	if (event.result.Tables.ERRORTBL.Rows.length >= 1)
	{
		CursorManager.removeBusyCursor();
		Alertfun(Alert.show(event.result.Tables.ERRORTBL.Rows[0].Exception.toString(),"Error",Alert.OK,null,null,null));
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
				this[event.currentTarget.description.toString()].dataProvider1= event.result.Tables.Table;
			}catch(er:Error)
			{
				Alertfun(
				Alert.show(er.toString(),"Error",Alert.OK,null,null,icon.CrossLarge.png));
				return;
			}
			
		}
	}	
}
private function  faultHandle(event:FaultEvent, token:Object=null ):void
{	
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

public  function funDocBulkPrint_New(DocPk:String, CstmParam1:String, CstmParam2:String, PrntTyp:int, PrntFlg:String,CustXml:String)
{
	ExternalInterface.call("callPrint",DocPk,CstmParam1,CstmParam2, PrntTyp, PrntFlg,CustXml);
	ws = new WebService();	
	//ws.wsdl=arr[0].toString()+"//"+arr[2].toString()+"/ERPWebService/ERPService.asmx?WSDL"
	ws.wsdl="http://localhost:4329/PrintService.asmx?WSDL";
	ws.addEventListener("result", echoResultHandler);
	ws.addEventListener("fault",  faultHandle);
	ws.loadWSDL();	
	if (ws.ready==false && webSer_CallCnt==0)
	{
		CursorManager.setBusyCursor();
		if (this.enabled) this.enabled=false;
	}	
	webSer_CallCnt++;	
	ws.GetPrintFile("PrcPrintService_Flex",DocPk,CstmParam1,CstmParam2,true,PrntFlg,false,"",false,"",false);
}
