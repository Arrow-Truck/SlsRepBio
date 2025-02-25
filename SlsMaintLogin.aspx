<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html><!-- InstanceBegin template="Templates/main.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- InstanceBeginEditable name="doctitle" -->
<title>SlsMaintLogin</title>
<!- ******************************************************************* ->
<!- * File: SlsMaintLogin.aspx                                        * ->
<!- *                                                                 * ->
<!- * Purpose: Sales Rep Maintenance Login                            * ->
<!- *                                                                 * ->
<!- * Written by: Clifton Davis 12.27.2005                            * ->
<!- *                                                                 * ->
<!- ******************************************************************* -> 

<%@ Import NameSpace="IBM.Data.DB2.iseries" %>
<%@ Import NameSpace="System.Data" %>
<%@ Import NameSpace="System.Web.Mail" %>
<!- ******************************************************************* ->
<!- *                      Define Script                              * ->
<!- ******************************************************************* -> 
<Script Runat="Server">
    Public strid As String
    Public strbranch As String
    Public strpw As String
    Dim validUser As Boolean

    Sub Page_Load()
    End Sub

    Sub Button_Click( s As Object, e As EventArgs )

        Dim con as new iDB2Connection
        Dim cmdSelect as iDB2Command
        Dim dtrAccount as iDB2DataReader

        validUser = False

        con.ConnectionString = ConfigurationManager.AppSettings("ConnString")
        con.open()

        cmdSelect = New iDB2Command("select PROUSERID,PROUSERPW,PROUSRBRA from AIS2000d.PROFILEPW where PROUSERID = ?", con )
        cmdSelect.Parameters.Add( "@PROUSERID", txtUser.Text.ToUpper().trim() )
        ' cmdSelect.Parameters.Add( "@PROUSERPW", txtPswd.Text.ToUpper().trim() )

        dtrAccount = cmdSelect.ExecuteReader()

        If dtrAccount.Read() Then
            strid = dtrAccount( "PROUSERID" ).trim()
            strpw = dtrAccount( "PROUSERPW" ).trim()
            strbranch = dtrAccount( "PROUSRBRA" ).trim()
            validUser = true
        End If

        con.Close()

        If strid = txtUser.Text.ToUpper().trim() And strpw = txtPswd.Text.ToUpper().trim() Then
            If strbranch <> "IM" Then
                Session("branch") = strbranch
                Response.Redirect("SalesRepMenu.aspx?branch=" + strbranch)
            Else
                Session("branch") = strbranch
                Response.Redirect( "IMMaint/MainMenu.aspx?branch"  + strBranch)
            End If
        Else
            lblerror.Visible = "true"
        End If

    End Sub
</script>
<!-- InstanceEndEditable -->
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	font-family:Arial, Helvetica, sans-serif;
}
.style1 {
	font-weight: bold;
	font-style: italic;
	color: #FFFFFF;
}
.style2 {
	color: #000000;
	font-weight: bold;
	font-size: 25px;
}
-->
</style></head>

<body>
<table width="800" border="0" align="center">
  <tr>
    <td valign="top">
      <table width="799" border="0">
        <tr>	
          <td align="left" width="30%" ><img src="Images/arrowlogoweb.GIF" >
          </td>
          <td align="right" width="70%" valign="right" ><span class="style2">WEBSITE MAINTENANCE</span>
          </td>
        </tr>
      </table>
    </td>
   </tr>
   
   <tr>
      <td height="3" bgcolor="#CC3333"> </td>
   </tr>
       
  <tr>
    <td height="281"><!-- InstanceBeginEditable name="EditRegion3" -->
      <center><form runat="Server">
	  <table width="800" border="0">
	  <tr>
		<td align="center"><asp:Label
              ID="lblerror"
			  Visible="false"
			  ForeColor="#FF0000"
              Text="INVALID USERID OR PASSWORD."
              runat="Server" /></td>	  
	  </TR>
	  </table>
	  <table width="800" border="0">
        <tr>
          <td valign="top" bordercolor="#000000">
            <table width="200" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000">
              <tr>
                <td><table width="400" border="0" align="center" bgcolor="#CCCCCC" ID="Table1">
                  <tr>
                    <td height="35" colspan="2" valign="middle"><div align="center" style="font-size:20px;"><b> Branch Login </b></div></td>
                  </tr>
                  <tr>
                    <td >&nbsp;</td>
                    <td >&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="106" align="right">
                        User ID:
                    </td>
                    <td align="left">
					<asp:TextBox
					id="txtUser"
					runat="server" width="180px"/>
					 <asp:RequiredFieldValidator
                        ControlToValidate="txtUser"
                        Text="Required!"
                        Display="Dynamic"
                        runat="Server" />					</td>
                  </tr>
                  <tr>
                    <td height="2"></td>
                    <td height="2">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="106" align="right">Password:</td>
                    <td align="left">
					<asp:TextBox
					id="txtPswd"
                    TextMode="password"
					runat="server" width="180px"/>
					 <asp:RequiredFieldValidator
                        ControlToValidate="txtPswd"
                        Text="Required!"
                        Display="Dynamic"
                        runat="Server" />					   
                        </td>
                  </tr>
                  <tr>
                    <td width="106">&nbsp;</td>
                    <td width="284">&nbsp;</td>
                  </tr>
                  <tr>
                    <td height="40" colspan="2" valign="middle"><div align="center">
                        <asp:Button
                   Text="Click Here to Login!"
                   OnClick="Button_Click"
                   Runat="Server" />                
    </div></td>
                  </tr>
                </table></td>
              </tr>
            </table>
            </td>
        </tr>
      </table>
	  </form></center>	
	<!-- InstanceEndEditable --></td>
  </tr>
  
  <tr>
    <td valign="top">
         <table width="799" border="0">
              <tr>
                <td height="12" bgcolor="#cc3333"> </td>
              </tr>
         </table>
    </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
