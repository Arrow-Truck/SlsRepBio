<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html><!-- InstanceBegin template="../Templates/main.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- InstanceBeginEditable name="doctitle" -->
<title>ViewRepEmailAddr</title>
<!- ******************************************************************* ->
<!- * File: ViewRepEmailAddr.aspx                                     * ->
<!- *                                                                 * ->
<!- * Purpose: View All STAFFs Email Addresses                    * -> 
<!- *                                                                 * ->
<!- * Written by: Clifton Davis 01.06.2006                            * ->
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
Public strbranch As String

Sub Page_Load
 strbranch = Request.QueryString( "branch" )
 lbl1x.Text = Request.QueryString( "branch" )
 GetReps()
  strbranch = lbl1x.Text

End Sub

Sub GetReps()
 Dim selectcon As New iDB2Connection
 Dim dtrSelect As iDB2DataReader
 Dim dadSelect As iDB2DataAdapter
 Dim dstSelect As DataSet

 If Not IsPostBack Then
            selectcon = New iDB2Connection(ConfigurationManager.AppSettings("ConnString"))
 Selectcon.Open()
 dstSelect = New DataSet
 'Select SLSREPNO,SLSBRANCH,SLSFNAME,SLSLNAME,SLSEMAIL from AISTESTLIB.SLSREPBIO Order by SLSBRANCH
 dadSelect = New iDB2DataAdapter("Select SLSREPNO,SLSBRANCH,SLSFNAME,SLSLNAME,SLSEMAIL from AIS2000D.SLSREPBIO Order by SLSBRANCH", selectcon)
 
 dadSelect.Fill(dstSelect)
 dgrdsalesrep.DataSource= dstSelect
 dgrdsalesrep.DataBind()
 
 selectcon.Close()
 
 End If
End Sub


Sub dgrdsalesrep_PageIndexChanged( s As Object, e As DataGridPageChangedEventArgs )

 dgrdsalesrep.CurrentPageIndex = e.NewPageIndex
 'GetReps()
 
 Dim sortcon As New iDB2Connection
 Dim dtrSelect As iDB2DataReader
 Dim dadSort As iDB2DataAdapter
 Dim dstSort As DataSet
 
        sortcon = New iDB2Connection(ConfigurationManager.AppSettings("ConnString"))
	sortcon.Open()
	dstSort = New DataSet

 strSortField = "SLSBRANCH"
	dadSort = New iDB2DataAdapter("Select SLSREPNO,SLSBRANCH,SLSFNAME,SLSLNAME,SLSEMAIL from AIS2000D.SLSREPBIO Order By " & strSortField, sortcon)
    dadSort.Fill(dstSort)
    dgrdsalesrep.DataSource= dstSort
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
        sortcon = New iDB2Connection(ConfigurationManager.AppSettings("ConnString"))
	sortcon.Open()
	dstSort = New DataSet

	dadSort = New iDB2DataAdapter("Select SLSREPNO,SLSBRANCH,SLSFNAME,SLSLNAME,SLSEMAIL from AIS2000D.SLSREPBIO Order By " & strSortField, sortcon)
 
    dadSort.Fill(dstSort)
    dgrdsalesrep.DataSource= dstSort
    dgrdsalesrep.DataBind()
	sortcon.Close()
End Sub

Sub Button_Click( s As Object, e As EventArgs )
 Response.Redirect( "SearchSlsRep.aspx" )
End Sub 

Sub Home_Click( s As Object, e As EventArgs )
 Request.QueryString( "branch" ) = strbranch
	Response.Redirect("SalesRepMenu.aspx?branch=" + strbranch)
End Sub
</script><!-- InstanceEndEditable -->
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
<p align="center"><b> ALL STAFFS EMAIL LIST </b></p>
  <center><form runat="Server">
    <asp:DataGrid
  	ID="dgrdsalesrep"
	AllowSorting="True"
	OnSortCommand="dgrdsalesrep_SortCommand"
	AllowPaging="true"
	PagerStyle-Mode="NextPrev"
	PagerStyle-Position="Bottom"
	PagerStyle-BackColor="#CCCCCC"
	PagerStyle-NextPageText="Next Page"
	PagerStyle-PrevPageText="Prev Page"
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
 
       
  <asp:BoundColumn
   HeaderText="Emp #"
   DataField="SLSREPNO" 
   SortExpression="slsrepno"/> 
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
   DataField="SLSEMAIL"/> 
   
   </Columns>
			
    </asp:DataGrid>    
      <table width="825" border="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
        <tr>
          <td width="245" bgcolor="#FFFFFF"><asp:Label
              ID="lbl1x"
			  Visible="false"
			  Text=""
			  runat="server" /></td>
          <td width="83" bgcolor="#FFFFFF"></td>
          <td width="164" bgcolor="#FFFFFF"><asp:Button
                   Text="Return to Menu"
                   OnClick="Home_Click"
                   runat="Server" /> </td>
          <td width="315" bgcolor="#FFFFFF"></td>
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
