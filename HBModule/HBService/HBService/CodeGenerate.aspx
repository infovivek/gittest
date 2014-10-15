<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CodeGenerate.aspx.cs" Inherits="HBService.CodeGenerate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style1
        {
            width: 709px;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
     <!-- Scripts Starts Here -->
        <script language="javascript" src='<%=Page.ResolveUrl("~/scripts/jquery-1.4.4.min.js")%>' type="text/javascript"></script>
        
       <script language="javascript" src='<%=Page.ResolveUrl("~/scripts/plugins/jquery-ui-1.8.7.custom.min.js")%>' type="text/javascript"></script>
       
       <script language="javascript" src='<%=Page.ResolveUrl("~/scripts/nest.js")%>' type="text/javascript"></script>
       
       <script language="javascript" src='<%=Page.ResolveUrl("~/App_ControlPanel/Scripts/Scripts.js")%>' type="text/javascript"></script>
    <!-- Scripts Ends Here -->
        <center>
        <div>
            <table border="0" cellpadding="0" cellspacing="0" width="1000px" align="center">
                <tr>
                    <td align="left" valign="top">
                        <div id="divHeader" class="div-header">
                            <table border="0" cellpadding="0" cellspacing="0" align="right">
                                <tr>
                                    <td align="left" valign="middle" style="width:20px;"><asp:Image ID="imgBookmark" runat="server" ToolTip="Book Mark" SkinID="imgbookmark" ImageAlign="AbsMiddle"/></td>
                                  
                                </tr>
                            </table>
                        </div>
                        <div id="divMain" class="div-main">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%" >                               
                                <tr>
                                    <td align="center" valign="middle">
                                        <div style="width:800px">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td align="center" valign="top" width="50%" style="padding:54px 0px 0px 0px;"><asp:Image ID="imglogo" runat="server" ToolTip="HB-Nest" SkinID="imgnestlogo" ImageAlign="AbsMiddle"/></td>
                                                    <td align="left" valign="top" width="4%" class="vertical-bar">&nbsp;</td>
                                                    <td align="left" valign="top" width="46%" style="padding-left:40px;">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                            
                                                            <tr>
                                                                <td align="left" valign="middle" class="title-cnt" style="padding-top:5px;">Sign in to your nest account.</td>
                                                            </tr>                                                           
                                                            <tr>
                                                                <td align="left" valign="middle" style="padding-top:20px;">
                                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="cnt">
                                                                        <tr>
                                                                            <td align="left" valign="middle">
                                                                                <asp:DropDownList ID="DropDownList1" runat="server" Width="291px" 
                                                                                    ontextchanged="Unnamed1_Click">
                                                                                </asp:DropDownList>
                                                                            </td>
                                                                        </tr>                                                                       
                                                                        <tr>
                                                                            <td align="left" valign="middle" style="padding-top:10px;">
                                                                                <asp:Button  runat="server" SkinID="btn" BorderWidth="0" Text="Generate >>" 
                                                                                    onclick="Unnamed1_Click" />
                                                                                <br />
                                                                            </td>
                                                                        </tr>    
                                                                        <asp:PlaceHolder ID="phpwd" Visible="false" runat="server">                                                                                                                        
                                                                        
                                                                        </asp:PlaceHolder>  
                                                                        <tr>
                                                                            <td align="left" valign="middle" style="padding-top:20px;">
                                                                                <asp:TextBox ID="txtCode" runat="server"  SkinID="txtboxBg" Height="97px" 
                                                                                    Width="433px" Enabled=false ForeColor=Black Font-Bold="False" 
                                                                                    Font-Underline="False"></asp:TextBox>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>                                                            
                                                            <tr>
                                                                <td height="20px"></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="divFooter" class="div-footer"><span class="footer-cnt">Copyright &copy; 2008-2018 HummingBird Corporate Travel and Stay Pvt Ltd. All rights reserved.</span></div>
                    </td>
                </tr>
            </table>
        </div>        
    </center>
    </form>
</body>


</html>
