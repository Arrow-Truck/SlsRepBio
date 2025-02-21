<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html><!-- InstanceBegin template="../Templates/main.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- InstanceBeginEditable name="doctitle" -->
<title>Delete STAFF</title>
<!- ******************************************************************* ->
<!- * File: DeleteReps.aspx                                           * ->
<!- *                                                                 * ->
<!- * Purpose: Delete STAFF                                       * ->
<!- *                                                                 * ->
<!- * Written by: Clifton Davis 1.30.2006                             * ->
<!- *                                                                 * ->
<!- ******************************************************************* -> 

<%@ Import NameSpace="IBM.Data.DB2.iseries" %>
<%@ Import NameSpace="System.Data" %>
<%@ Import NameSpace="System.Web.Mail" %>
<!- ******************************************************************* ->
<!- *                      Define Script                              * ->
<!- ******************************************************************* -> 
<Script Runat="Server">
Public strRepNumber As String
Public strbranch As String
Public strSortField As String
Public strSls As String

Sub Page_Load
 
 strRepNumber = Request.QueryString( "slsrepno" )
 strbranch = Request.QueryString( "branch" )
'If Not IsPostBack Then

 GetReps()
 
'End If

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
 
 
 dadSelect = New iDB2DataAdapter("Select SLSREPNO,SLSBRANCH,SLSFNAME,SLSLNAME,SLSEMAIL from AIS2000D.SLSREPBIO where  SLSBRANCH Like ('%" &strBranch & "%')" + "  Order by SLSBRANCH", selectcon)
 dadSelect.Fill(dstSelect)
 dgrdsalesrep.DataSource= dstSelect
 dgrdsalesrep.DataBind()
 
 selectcon.Close()
 
 End If
End Sub

Sub dgrdsalesrep_PageIndexChanged( s As Object, e As DataGridPageChangedEventArgs )
 Dim sortcon As New iDB2Connection
 Dim dtrSelect As iDB2DataReader
 Dim dadSort As iDB2DataAdapter
 Dim dstSort As DataSet
 
 dgrdsalesrep.CurrentPageIndex = e.NewPageIndex
 
        sortcon = New iDB2Connection(ConfigurationSettings.AppSettings("ConnString"))
	sortcon.Open()
	dstSort = New DataSet

 strSortField = "SLSBRANCH"
 	 
 	dadSort = New iDB2DataAdapter("Select SLSREPNO,SLSBRANCH,SLSFNAME,SLSLNAME,SLSEMAIL from AIS2000D.SLSREPBIO Order By " & strSortField, sortcon)
    dadSort.Fill(dstSort)
    dgrdsalesrep.DataSource= dstSort
    dgrdsalesrep.DataBind()
	sortcon.Close()

End Sub

Sub dgrdsalesrep_ItemCommand( s As Object, e As DataGridCommandEventArgs )
 
        If e.CommandName = "Delete" Then
            Dim deletecon As New iDB2Connection
            Dim cmdDelete As iDB2Command
            Dim strDelete As String
 
            deletecon.ConnectionString = ConfigurationSettings.AppSettings("ConnString")
            deletecon.Open()

            Dim itemCell As TableCell = e.Item.Cells(0)
            Dim item As String = itemCell.Text
            strSls = item
 
 
            strDelete = "Delete from AIS2000D.SLSREPBIO Where SLSREPNO=? and SLSBRANCH = '" & strbranch & "' "

            cmdDelete = New iDB2Command(strDelete, deletecon)
            cmdDelete.Parameters.Add("@SLSREPNO", CInt(strSls))
   
            cmdDelete.ExecuteNonQuery()
            deletecon.Close()

            'Redirect back to menu
            Response.Redirect("SalesRepMenu.aspx?branch=" + strbranch)
        End If
End Sub

Sub Home_Click( s As Object, e As EventArgs )
	Response.Redirect("SalesRepMenu.aspx?branch=" + strBranch)
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
<p align="center"><b> DELETE STAFF </b></p>
  <center><form runat="Server">
    <asp:DataGrid
  	ID="dgrdsalesrep"
	AllowSorting="True"
	OnPageIndexChanged="dgrdsalesrep_PageIndexChanged"
	OnItemCommand="dgrdsalesrep_ItemCommand"
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
	AlternatingItemStyle-Backcolor="#CCCCCC"
	Runat="Server">
			
	<HeaderStyle BackColor="#CCCCCC" HorizontalAlign="Center" Font-Bold="True">
	</HeaderStyle>
 <Columns>
 
  <asp:BoundColumn
   HeaderText="Emp #"
   DataField="SLSREPNO" /> 
       
  <asp:BoundColumn
   HeaderText="Branch"
   DataField="SLSBRANCH"/> 
  <asp:BoundColumn
   HeaderText="First Name"
   DataField="SLSFNAME"/>
  <asp:BoundColumn
   HeaderText="Last Name"
   DataField="SLSLNAME"/> 
  <asp:BoundColumn
   HeaderText="E-Mail"
   DataField="SLSEMAIL"/> 
     <asp:ButtonColumn
  CommandName="Delete"
   Text="DELETE!" />

   </Columns>
			
    </asp:DataGrid>    
      <table width="825" border="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
        <tr>
          <td width="89" bgcolor="#FFFFFF"><asp:Label
ID="box"
runat="Server"/></td>
          <td width="244" bgcolor="#FFFFFF"> </td>
          <td width="133" bgcolor="#FFFFFF"><asp:Button
                   Text="Return to Menu"
                   OnClick="Home_Click"
                   runat="Server" /> </td>
          <td width="341" bgcolor="#FFFFFF"></td>
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
