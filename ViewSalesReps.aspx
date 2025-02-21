<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html><!-- InstanceBegin template="../Templates/main.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- InstanceBeginEditable name="doctitle" -->
<title>ViewSalesReps</title>
<!- ******************************************************************* ->
<!- * File: ViewSalesReps.aspx                                        * ->
<!- *                                                                 * ->
<!- * Purpose: View STAFFs                                        * ->
<!- *                                                                 * ->
<!- * Written by: Clifton Davis 12.19.2005                            * ->
<!- *                                                                 * ->
<!- ******************************************************************* -> 

<%@ Import NameSpace="IBM.Data.DB2.iseries" %>
<%@ Import NameSpace="System.Data" %>
<%@ Import NameSpace="System.Web.Mail" %>
<!- ******************************************************************* ->
<!- *                      Define Script                              * ->
<!- ******************************************************************* -> 
<Script Runat="Server">
Public strSortField As String
Public strBranch As String
Public strRepNo As String

    Sub Page_Load()

        strBranch = ucase(Request.QueryString("branch"))
        strRepNo = Request.QueryString("repno")
        ' strBranch = Session("branch")
        lblBranch.Text = strBranch
        Session("branch") = lblBranch.Text
 
        GetReps()

    End Sub

    Sub GetReps()
        Dim selectcon As New iDB2Connection
        Dim dtrSelect As iDB2DataReader
        Dim dadSelect As iDB2DataAdapter
        Dim dstSelect As DataSet

        If Not IsPostBack Then
            selectcon = New iDB2Connection(ConfigurationSettings.AppSettings("ConnString"))
            Selectcon.Open()
            dstSelect = New DataSet
 
            ' If strRepNo <> "" Then 
            ' dadSelect = New iDB2DataAdapter("Select SLSREPNO,SLSBRANCH,SLSFNAME,SLSLNAME,SLSEMAIL from AISTESTLIB.SLSREPBIO where SLSREPNO = " + strRepNo + " Order by SLSREPNO", selectcon)
            ' Else
            dadSelect = New iDB2DataAdapter("Select * from AIS2000D.SLSREPBIO where  SLSBRANCH Like ('%" & lblBranch.Text & "%')" + "  Order by SLSREPNO", selectcon)
            'End If 
            dadSelect.Fill(dstSelect)
            dgrdsalesrep.DataSource = dstSelect
            dgrdsalesrep.DataBind()
 
            selectcon.Close()
 
        End If
    End Sub

    Sub dgrdsalesrep_PageIndexChanged(s As Object, e As DataGridPageChangedEventArgs)
        Dim sortcon As New iDB2Connection
        Dim dtrSelect As iDB2DataReader
        Dim dadSort As iDB2DataAdapter
        Dim dstSort As DataSet
 
        dgrdsalesrep.CurrentPageIndex = e.NewPageIndex
 
        sortcon = New iDB2Connection(ConfigurationSettings.AppSettings("ConnString"))
        sortcon.Open()
        dstSort = New DataSet

        strSortField = "SLSBRANCH"

        dadSort = New iDB2DataAdapter("Select * from AIS2000D.SLSREPBIO where SLSBRANCH Like ('%" & lblBranch.Text & "%')" + " Order By " & strSortField, sortcon)
        dadSort.Fill(dstSort)
        dgrdsalesrep.DataSource = dstSort
        dgrdsalesrep.DataBind()
        sortcon.Close()

    End Sub

Sub dgrdsalesrep_SortCommand( s As Object, e As DataGridSortCommandEventArgs )

 Session( "sortField" ) = e.sortExpression
 strSortField = Session( "sortField" ) 
 getSortedReps( strSortField )

 End Sub
 
Sub getSortedReps( strSortField as String )
' *********************************************************************
' *                     Define getSortedTrucks                        *
' *********************************************************************	
 Dim sortcon As new iDB2Connection
 Dim dadSort As iDB2DataAdapter
 Dim dstSort As DataSet
        sortcon = New iDB2Connection(ConfigurationSettings.AppSettings("ConnString"))
	sortcon.Open()
	dstSort = New DataSet

        dadSort = New iDB2DataAdapter("Select * from AIS2000D.SLSREPBIO  where  SLSBRANCH Like ('%" & lblBranch.Text & "%')" + " Order By " & strSortField, sortcon)
 
    dadSort.Fill(dstSort)
    dgrdsalesrep.DataSource= dstSort
    dgrdsalesrep.DataBind()
	sortcon.Close()
End Sub

Sub Button_Click( s As Object, e As EventArgs )
 Response.Redirect( "SearchSlsRep.aspx" )
End Sub 

Sub Home_Click( s As Object, e As EventArgs )
        Response.Redirect("SalesRepMenu.aspx?branch=" + lblBranch.Text)
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
<p align="center"><strong>BRANCH STAFFS LIST</strong></p>
  <p><center><form runat="Server">
    <asp:DataGrid
  	ID="dgrdsalesrep"
	AllowSorting="True"
	OnSortCommand="dgrdsalesrep_SortCommand"
	AllowPaging="true"
	PagerStyle-Position="Bottom"
    PagerStyle-Mode="NumericPages"
	PagerStyle-BackColor="#CCCCCC"
	PagerStyle-HorizontalAlign="Center" 
	Font-Size="10pt"
	AutoGenerateColumns="False"
	CellPadding="2"
	PageSize="25"
	OnPageIndexChanged="dgrdsalesrep_PageIndexChanged"
	AlternatingItemStyle-Backcolor="#CCCCCC"
	Runat="Server">
			
	<HeaderStyle BackColor="#CCCCCC" HorizontalAlign="Center" Font-Bold="True">
	</HeaderStyle>
 <Columns>
 
  <asp:HyperLinkColumn
   DataNavigateUrlField="slsrepno"
   HeaderText="Emp #"
   DataNavigateUrlFormatString="UpdateSlsRep.aspx?slsrepno={0}"
   DataTextField="SLSREPNO" /> 
       
  <asp:BoundColumn
   HeaderText="Branch"
   DataField="SLSBRANCH" 
   SortExpression="slsbranch"/> 
  <asp:BoundColumn
   HeaderText="First Name"
   DataField="SLSFNAME"
   SortExpression="slsfname"/>
  <asp:BoundColumn
   HeaderText="Last Name"
   DataField="SLSLNAME"
   SortExpression="slslname"/> 
  <asp:BoundColumn
   HeaderText="E-Mail"
   DataField="SLSEMAIL" 
   SortExpression="SLSEMAIL" /> 

  <asp:BoundColumn
   HeaderText="Phone"
   DataField="SLSPHONE"
   SortExpression="SLSPHONE"/> 
   
   </Columns>
			
    </asp:DataGrid>    
      <table width="825" border="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
        <tr>
          <td colspan="3" align="center" bgcolor="#FFFFFF"><asp:Button
                   Text="Return to Menu"
                   OnClick="Home_Click"
                   runat="Server" /></td>
          </tr>
        <tr>
          <td align="center" bgcolor="#FFFFFF"><asp:Button
                   Text="Return To Search"
				   Visible="false"
                   OnClick="Button_Click"
                   runat="Server" /></td>
          <td width="238" align="center" bgcolor="#FFFFFF">&nbsp;</td>
          <td width="319" align="center" bgcolor="#FFFFFF">
              <asp:Label
              ID="lblBranch"
			  Visible="false"
			  Text=""
			  runat="server" /></td>
        </tr>
      </table>
	  </form></center> </p>
	
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
