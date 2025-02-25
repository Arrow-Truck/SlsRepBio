<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html><!-- InstanceBegin template="../Templates/main.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- InstanceBeginEditable name="doctitle" -->
<title>SearchSlsRep</title>
<!- ******************************************************************* ->
<!- * File: SearchSlsRep.aspx                                         * ->
<!- *                                                                 * ->
<!- * Purpose: STAFF Search                                       * ->
<!- *                                                                 * ->
<!- * Written by: Clifton Davis 12.22.2005                            * ->
<!- *                                                                 * ->
<!- ******************************************************************* -> 

<%@ Import NameSpace="IBM.Data.DB2.iseries" %>
<%@ Import NameSpace="System.Data" %>
<%@ Import NameSpace="System.Web.Mail" %>
<!- ******************************************************************* ->
<!- *                      Define Script                              * ->
<!- ******************************************************************* -> 
<Script Runat="Server">
Public strBranch As String

Sub Page_Load()
 LoadBranch()
 Session("branch") = ""
 Session("repno") = ""
 
End Sub

Sub Button_Click( s As Object, e As EventArgs )
	strBranch = DropBranch.SelectedItem.text.trim()
    Session("branch") = strBranch			'DropBranch.SelectedItem.Text.trim()
	Session("repno") = txtRepNo.Text.trim()
    Response.Redirect( "ViewSalesReps.aspx?branch=" + strBranch + "&repno=" + txtRepNo.Text.trim())
End Sub

Sub Menu_Click( s As Object, e As EventArgs )
 Response.Redirect( "SalesRepMenu.aspx" )
End Sub

Sub LoadBranch()
	dropBranch.Items.Add("  ")
	dropBranch.Items.Add("AT")
	dropBranch.Items.Add("AW")
	dropBranch.Items.Add("BC")
	dropBranch.Items.Add("BI")
	dropBranch.Items.Add("CA")
	dropBranch.Items.Add("CH")
	dropBranch.Items.Add("CN")
	dropBranch.Items.Add("CO")
	dropBranch.Items.Add("CC")
	dropBranch.Items.Add("CW")
	dropBranch.Items.Add("DA")
	dropBranch.Items.Add("EX")
	dropBranch.Items.Add("FT")
	dropBranch.Items.Add("HS")
	dropBranch.Items.Add("KC")
	dropBranch.Items.Add("KF")
	dropBranch.Items.Add("LA")
	dropBranch.Items.Add("ML")
	dropBranch.Items.Add("MN")
	dropBranch.Items.Add("NA")
	dropBranch.Items.Add("NJ")
	dropBranch.Items.Add("NS")
	dropBranch.Items.Add("OR")
	dropBranch.Items.Add("PH")
	dropBranch.Items.Add("PS")
	dropBranch.Items.Add("PX")
	dropBranch.Items.Add("RW")
	dropBranch.Items.Add("SA")
	dropBranch.Items.Add("SL")
	dropBranch.Items.Add("ST")
	dropBranch.Items.Add("SP")
	dropBranch.Items.Add("TA")
	dropBranch.Items.Add("TO")
	dropBranch.Items.Add("TW")
	dropBranch.Items.Add("VT")
	dropBranch.Items.Add("WS")

' Dim con As New iDB2Connection
' Dim dtrBranch As iDB2DataReader
' Dim dadBranch As iDB2DataAdapter
' Dim dstBranch As DataSet
' 
        ' con = New iDB2Connection(ConfigurationManager.AppSettings("ConnString"))
' con.Open()
' 
' dstBranch = New DataSet
' 
' dadBranch = New iDB2DataAdapter("Select BRNBRNID from AIS2000D.BRANCH desc", con)	'BRNNAME
' 
' dadBranch.Fill(dstBranch)
' dropBranch.DataSource= dstBranch
' dropBranch.DataTextField="BRNBRNID"
' dropBranch.DataValueField="BRNBRNID"
' dropBranch.DataBind()
' 
' con.Close()
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
          <td align="left" width="30%" ><img src="../Images/arrowlogoweb.GIF" >
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
	 <center><form runat="server">
<table width="689" border="0">
  <caption>
  SEARCH STAFFS
  </caption>
  <tr>
    <td width="98">&nbsp;</td>
    <th width="486" scope="col">Search by Branch:
      <asp:DropDownList
                 ID="DropBranch"
                  Columns="2"
                 runat="server" TabIndex="1" /></th>
    <td width="91">&nbsp;</td>
  </tr>
  </table>
<table width="689" border="0">
  <tr>
    <td width="299">&nbsp;</td>
    <td width="42">Or</td>
    <td width="334">&nbsp;</td>
  </tr>
  </table>
<table width="689" border="0">
  <tr>
    <th width="86" scope="col">&nbsp;</th>
    <th width="450" scope="col">Search by EMP Number:
      <asp:TextBox
                       ID="txtRepNo"
                       Columns="5"
                        runat="server" Wrap="false" TabIndex="2" /></th>
    <th width="139" scope="col">&nbsp;</th>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
      <table width="674" border="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
        <tr>
          <td width="102" bgcolor="#FFFFFF"></td>
          <td width="155" bgcolor="#FFFFFF"><asp:Button
                   Text="Submit Search"
                   OnClick="Button_Click"
                   runat="server" TabIndex="3" /></td>
          <td width="10" bordercolor="#FFFFFF" bgcolor="#FFFFFF"> </td> 
          <td width="15" bgcolor="#FFFFFF"></td>
          <td width="370" bgcolor="#FFFFFF"><asp:Button
                   Text="Return to Menu"
                   OnClick="Menu_Click"
                   runat="server" TabIndex="4" />
		      &nbsp;</td>
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
