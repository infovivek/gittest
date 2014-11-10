﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExternalIntermediateCheckOutTariff.aspx.cs" Inherits="HBReport.ExternalIntermediateCheckOutTariff" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    <div style="margin-left: 400px">
        <asp:Button ID="Button1" runat="server" Text="Print" style="font-weight: 700" 
            Width="79px" onclick="Button1_Click1" />
    </div>
    <div>
    </div>
    <div align="center">
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Height="100%" 
            Width="100%" Font-Names="Verdana" Font-Size="8pt" 
            InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Verdana" 
            WaitMessageFont-Size="14pt" AsyncRendering="False" SizeToReportContent="True"
            PromptAreaCollapsed="True">
            <LocalReport ReportPath="ExternalIntermediateCheckOutTariff.rdlc">
                <DataSources>
                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                </DataSources>
            </LocalReport>
        </rsweb:ReportViewer>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
            TypeName="HBReport.HBDataSet1TableAdapters."></asp:ObjectDataSource>
    </div>
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    </div>
    </form>
</body>
</html>